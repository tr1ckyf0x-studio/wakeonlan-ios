//
//  DonateScreenTableManager.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import SharedExtensions
import SharedProtocolsAndModels
import UIKit

protocol ManagesDonateScreenTable {
    var sections: [DonateScreenTableSectionModel] { get set }
}

final class DonateScreenTableManager: NSObject {

    // MARK: - Properties

    var sections: [DonateScreenTableSectionModel] = []
}

// MARK: - ManagesDonateScreenTable

extension DonateScreenTableManager: ManagesDonateScreenTable {

}

// MARK: - UITableViewDataSource

extension DonateScreenTableManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].content.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].content[indexPath.item]
        switch model {
        case let .purchase(purchaseModel):
            let donateItemCell = tableView.dequeueReusableCellWithAutoregistration(
                DonateItemCell.self
            )

            donateItemCell.configure(model: purchaseModel)
            return donateItemCell
        }
    }
}

// MARK: - UITableViewDelegate

extension DonateScreenTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let model = sections[section]

        switch model {
        case let .donateSection(_, footer):
            return footer
        }
    }
}
