//
//  PostLaunchPresenter.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import SharedRouter

@MainActor
final class PostLaunchPresenter: Navigates {
    weak var view: PostLaunchViewInput?
    var interactor: PostLaunchInteractorInput?
    var router: PostLaunchRoutes?
}

// MARK: - PostLaunchViewOutput

extension PostLaunchPresenter: PostLaunchViewOutput {
    func viewDidLoad(_ view: PostLaunchViewInput) {
        interactor?.performMigration()
    }
}

// MARK: - PostLaunchInteractorOutput

extension PostLaunchPresenter: PostLaunchInteractorOutput {
    func interactorDidFinishMigrationFailure(_ interactor: PostLaunchInteractorInput) {
        // TODO: - Add error handling
    }

    func interactorDidFinishMigrationSuccess(_ interactor: PostLaunchInteractorInput) {
        navigate(to: router?.hostList())
    }
}
