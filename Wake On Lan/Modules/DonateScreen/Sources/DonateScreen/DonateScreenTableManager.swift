//
//  DonateScreenTableManager.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import SharedProtocolsAndModels
import UIKit

typealias DonateScreenTableSection = DonateScreenTableSectionModel
typealias DonateScreenTableItem = DonateScreenTableSectionModel.Item

typealias DonateScreenTableSnapshot = NSDiffableDataSourceSnapshot<
    DonateScreenTableSection,
    DonateScreenTableItem
>

typealias DonateScreenTableDataSource = UITableViewDiffableDataSource<
    DonateScreenTableSection,
    DonateScreenTableItem
>

protocol ManagesDonateScreenTable: DonateScreenTableDataSource, UITableViewDelegate { }

final class DonateScreenTableManager: DonateScreenTableDataSource, ManagesDonateScreenTable {

    typealias CellProvider = ProvidesTableViewCell<DonateScreenTableItem>

    // MARK: - Init

    init(
        tableView: UITableView,
        cellProvider: any CellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider.makeTableViewCell)
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionModel = snapshot().sectionIdentifiers[section]

        switch sectionModel {
        case let .donateSection(_, header):
            return header
        }
    }
}
