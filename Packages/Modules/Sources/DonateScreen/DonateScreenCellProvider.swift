//
//  DonateScreenCellProvider.swift
//  
//
//  Created by Vladislav Lisianskii on 15.04.2023.
//

import SharedProtocolsAndModels
import UIKit

struct DonateScreenCellProvider: ProvidesTableViewCell {
    func makeTableViewCell(
        _ tableView: UITableView,
        _ indexPath: IndexPath,
        _ item: DonateScreenTableItem
    ) -> UITableViewCell? {
        switch item {
        case let .purchase(purchaseModel):
            let donateItemCell = tableView.dequeueReusableCell(
                withIdentifier: "\(DonateItemCell.self)",
                for: indexPath
            ) as? DonateItemCell

            donateItemCell?.configure(model: purchaseModel)
            return donateItemCell
        }
    }
}
