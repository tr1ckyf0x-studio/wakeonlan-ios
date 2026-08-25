//
//  HostStatus.swift
//  Wake on LAN
//

import Foundation

/// The six states a host can be in, as documented by card 4b of the design system.
///
/// The type carries meaning only. Response time, the wake countdown and the attempt counter are
/// row data rather than indicator input — the dot never draws them — so they belong to the host
/// row's view model. Keeping them out also keeps equality meaningful: a `waking` host is the same
/// state whether 47 or 46 seconds remain.
enum HostStatus: Hashable, CaseIterable, Sendable {
    /// Ping returned.
    case online

    /// Ping did not return while the network is reachable — an ordinary sleeping machine.
    case offline

    /// The first poll after the list appeared or after pull-to-refresh. Lives one to two seconds.
    case probing

    /// The magic packet was sent and the one-minute wait is running.
    case waking

    /// The minute elapsed with no answer. Holds until the host is woken again.
    case unreachable

    /// Polling is impossible: the host has no IP address, or Wi-Fi is off.
    case unknown
}
