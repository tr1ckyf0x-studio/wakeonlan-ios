import Foundation
import Network

public final class NWUDPService {
    public init() { }
}

// MARK: - UDPService

extension NWUDPService: UDPService {
    public func send(_ packet: [UInt8], to destination: String, port: UInt16) async throws {
        guard let connection = NWConnectionBuilder.build(with: destination, port: port)
        else {
            throw UDPError.socketSetup(reason: "Wrong address or port \(destination):\(port)")
        }

        defer { connection.cancel() }

        try await connection.send(
            content: packet,
            timeout: Constants.sendTimeout,
            on: DispatchQueue(label: Constants.queueLabel),
            contentContext: .finalMessage
        )
    }
}

// MARK: - Constants

extension NWUDPService {
    private enum Constants {
        static let queueLabel = "com.tr1ckyf0x.wake-on-lan.udp"
        /// A magic packet is a single datagram on the local network, so anything slower than this
        /// means the path never became usable — an unresolvable host, an unreachable network, or a
        /// local network permission prompt left unanswered — rather than a slow send.
        static let sendTimeout: TimeInterval = 5
    }
}

// MARK: - Private

extension NWConnection {
    fileprivate func send<Content: DataProtocol>(
        content: Content,
        timeout: TimeInterval,
        on queue: DispatchQueue,
        contentContext: NWConnection.ContentContext = .defaultMessage,
        isComplete: Bool = true
    ) async throws {
        let result = OneShotContinuation()

        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                result.store(continuation)

                // NOTE: Without a state handler a connection that never becomes ready leaves
                // `contentProcessed` unfired and the caller suspended forever.
                stateUpdateHandler = { state in
                    switch state {
                    case let .failed(error):
                        result.finish(.failure(UDPError.send(reason: error.localizedDescription)))

                    // NOTE: `.waiting` on its own is not a failure — it also covers the window in
                    // which the user is answering the local network permission prompt, and the path
                    // may still become satisfied. A DNS failure, however, is terminal for this
                    // hostname, so a mistyped destination fails immediately instead of waiting out
                    // the timeout.
                    case let .waiting(error) where error.isDNS:
                        result.finish(.failure(UDPError.send(reason: error.localizedDescription)))

                    case .cancelled:
                        result.finish(.failure(CancellationError()))

                    default:
                        break
                    }
                }

                // NOTE: Bounds every remaining way the connection can fail to become usable.
                queue.asyncAfter(deadline: .now() + timeout) {
                    result.finish(
                        .failure(UDPError.send(reason: "Sending timed out after \(Int(timeout)) s"))
                    )
                }

                start(queue: queue)

                send(
                    content: content,
                    contentContext: contentContext,
                    isComplete: isComplete,
                    completion: SendCompletion.contentProcessed { (error: NWError?) in
                        if let error {
                            result.finish(.failure(UDPError.send(reason: error.localizedDescription)))
                            return
                        }
                        result.finish(.success(()))
                    }
                )
            }
        } onCancel: {
            cancel()
        }
    }
}

extension NWError {
    /// `true` when the endpoint's hostname could not be resolved.
    fileprivate var isDNS: Bool {
        guard case .dns = self else { return false }
        return true
    }
}

/// Guarantees that a continuation is resumed exactly once, whichever of the concurrent callbacks —
/// state change, timeout, send completion or cancellation — reaches it first.
///
/// - Important: never give this type an actor. Every caller is a `NWConnection` callback delivered
///   on the connection's own queue, so it has to be reachable from any isolation; the `lock` below is
///   what makes that safe.
private final class OneShotContinuation: @unchecked Sendable {
    // MARK: - Properties

    private let lock = NSLock()
    private var continuation: CheckedContinuation<Void, Error>?

    // MARK: - Internal

    func store(_ continuation: CheckedContinuation<Void, Error>) {
        lock.lock()
        defer { lock.unlock() }
        self.continuation = continuation
    }

    func finish(_ result: Result<Void, Error>) {
        lock.lock()
        let continuation = self.continuation
        self.continuation = nil
        lock.unlock()
        continuation?.resume(with: result)
    }
}
