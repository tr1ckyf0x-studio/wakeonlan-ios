//
//  DonateScreenState.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

enum DonateScreenState {
    case paymentsUnavailable
    case loading
    case loaded
    /// Products could not be fetched. Without it a failed fetch left the screen on `.loading`
    /// forever, with no message and no way out other than leaving the screen.
    case loadingFailed
}
