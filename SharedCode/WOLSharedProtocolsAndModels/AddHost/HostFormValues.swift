//
//  HostFormValues.swift
//
//
//  Created by Vladislav Lisianskii on 21. 8. 2026..
//

/// Sendable snapshot of everything a host is built from.
///
/// - Important: Core Data work runs inside `@Sendable` blocks on the context's own queue, which may
///   capture neither the form object nor a managed object. Every value that crosses that boundary
///   has to be exactly that — a value.
public struct HostFormValues: Sendable {
    // MARK: - Properties

    public let title: String
    public let iconName: String
    public let macAddress: String
    public let destination: String?
    public let port: String?

    // MARK: - Init

    public init(
        title: String,
        iconName: String,
        macAddress: String,
        destination: String?,
        port: String?
    ) {
        self.title = title
        self.iconName = iconName
        self.macAddress = macAddress
        self.destination = destination
        self.port = port
    }

    public init(form: any AddHostFormRepresentable) {
        self.init(
            title: form.title,
            iconName: form.iconModel.symbol.rawValue,
            macAddress: form.macAddress,
            destination: form.destination,
            port: form.port
        )
    }
}
