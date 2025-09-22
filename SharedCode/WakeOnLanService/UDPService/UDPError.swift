import Foundation

public enum UDPError {
    case socketSetup(reason: String)
    case send(reason: String)
}

// MARK: - LocalizedError

extension UDPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .socketSetup, .send:
            return "Unexpected error occured"
        }
    }

    public var failureReason: String? {
        switch self {
        case let .socketSetup(reason), let .send(reason):
            return reason
        }
    }
}
