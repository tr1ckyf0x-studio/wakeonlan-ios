//
//  PostLaunchContract.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

protocol PostLaunchViewInput: AnyObject { }

protocol PostLaunchViewOutput {
    func viewDidLoad(_ view: PostLaunchViewInput)
}

protocol PostLaunchInteractorInput {
    func performMigration()
}

@MainActor
protocol PostLaunchInteractorOutput: AnyObject {
    func interactorDidFinishMigrationSuccess(_ interactor: PostLaunchInteractorInput)
    func interactorDidFinishMigrationFailure(_ interactor: PostLaunchInteractorInput)
}
