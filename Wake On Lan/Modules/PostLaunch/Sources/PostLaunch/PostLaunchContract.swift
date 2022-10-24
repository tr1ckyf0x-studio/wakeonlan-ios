//
//  PostLaunchContract.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

// sourcery: AutoMockable
protocol PostLaunchViewInput: AnyObject { }

// sourcery: AutoMockable
protocol PostLaunchViewOutput {
    func viewDidLoad(_ view: PostLaunchViewInput)
}

// sourcery: AutoMockable
protocol PostLaunchInteractorInput {
    func performMigration()
}

// sourcery: AutoMockable
@MainActor
protocol PostLaunchInteractorOutput: AnyObject {
    func interactorDidFinishMigrationSuccess(_ interactor: PostLaunchInteractorInput)
    func interactorDidFinishMigrationFailure(_ interactor: PostLaunchInteractorInput)
}
