//
//  PostLaunchInteractor.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import CoreDataService
import Foundation

final class PostLaunchInteractor {

    // MARK: - Properties

    weak var presenter: PostLaunchInteractorOutput?

    private let coreDataMigration: CoreDataMigration
    private let coreDataService: CoreDataServiceProtocol

    // MARK: - Init

    init(coreDataMigration: CoreDataMigration, coreDataService: CoreDataServiceProtocol) {
        self.coreDataMigration = coreDataMigration
        self.coreDataService = coreDataService
    }
}

// MARK: - PostLaunchInteractorInput

extension PostLaunchInteractor: PostLaunchInteractorInput {
    func performMigration() {
        Task {
            do {
                try await coreDataMigration.execute()
                await presenter?.interactorDidFinishMigrationSuccess(self)
            } catch {
                await presenter?.interactorDidFinishMigrationFailure(self)
            }
        }
    }
}
