//
//  AddHostTableManager.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

protocol AddHostTableManagerDelegate: class {
    func tableManagerDidTapDeviceIconCell(_ manager: AddHostTableManager, _ model: IconModel)
}

// TODO: Implementing custom header/footer views
class AddHostTableManager: NSObject {

    weak var delegate: AddHostTableManagerDelegate?

    var form: AddHostForm?

    var sections: [FormSection] {
        guard let form = form else { return [] }
        return form.formSections
    }

}

// MARK: - UITableViewDataSource
extension AddHostTableManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let model = sections[indexPath.section].items[indexPath.row]
        switch model {
        case .text(let textFormItem):
            let textInputCell =
                tableView.dequeueReusableCell(
                    withIdentifier: TextInputCell.reuseIdentifier, for: indexPath) as? TextInputCell
            textFormItem.indexPath = indexPath
            textInputCell?.configure(with: model)
            // Scroll table view to next responder
            textInputCell?.onNextResponderAction = { indexPath in
                guard let nextIndexPath =
                    tableView.nextIndexPath(for: indexPath) else { return }
                tableView.scrollToRow(at: nextIndexPath, at: .top, animated: true)
            }
            // NOTE: We need to hide failure label in
            // completion block for smoothy animation working
            textInputCell?.onExpandAction = { completion in
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    completion?()
                })
                tableView.beginUpdates()
                tableView.endUpdates()
                CATransaction.commit()
            }
            cell = textInputCell
        case .icon(let model):
            if model.selected {
                let deviceIconCell = tableView.dequeueReusableCell(
                    withIdentifier: "\(DeviceIconCell.self)", for: indexPath) as? DeviceIconCell
                deviceIconCell?.configure(with: model)
                deviceIconCell?.didTapChangeIconBlock = { [unowned self] model in
                    self.delegate?.tableManagerDidTapDeviceIconCell(self, model)
                }
                cell = deviceIconCell
            } else {
                let emptyCell = tableView.dequeueReusableCell(
                    withIdentifier: "\(EmptyCell.self)", for: indexPath) as? EmptyCell
                cell = emptyCell
            }
        }

        guard let unwrappedCell = cell else {
            fatalError("\(self): Unknown cell identifier")
        }
        
        return unwrappedCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = sections[indexPath.section].items[indexPath.row]
        switch model {
        case .icon(let model):
            guard model.selected else { return .zero }
        default:
            return UITableView.automaticDimension
        }

        return UITableView.automaticDimension
    }

}

// MARK: - UITableViewDelegate
extension AddHostTableManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let sectionHeader = sections[section].header,
            !sectionHeader.isMandatory,
            let header = view as? UITableViewHeaderFooterView,
            let headerLabel = header.textLabel,
            let headerText = headerLabel.text else { return }
        // Make source attributed string
        let sourceAttributes: [NSAttributedString.Key : UIFont] = [ .font : headerLabel.font ]
        let sourceAttributedString =
            NSMutableAttributedString(string: headerText, attributes: sourceAttributes)
        sourceAttributedString.appendOptional()
        headerLabel.attributedText = sourceAttributedString
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header?.header
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer?.footer
    }

}

// NOTE: Grabbed from
// https://stackoverflow.com/questions/27472249/get-indexpath-of-next-uitableviewcell
private extension UITableView {
    
    func nextIndexPath(for currentIndexPath: IndexPath) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = currentIndexPath.row
        for section in currentIndexPath.section ..< self.numberOfSections {
            nextSection = section
            for row in startRow ..< self.numberOfRows(inSection: section) {
                nextRow = row
                iteration += 1
                if iteration == 2 {
                    let nextIndexPath = IndexPath(row: nextRow, section: nextSection)
                    return nextIndexPath
                }
            }
            startRow = 0
        }
        
        return nil
    }
    
    // As per CC BY-SA 3.0 license, the code below was created by:
    // https://stackoverflow.com/users/1294448/bishal-ghimire
    // Source: https://stackoverflow.com/a/56867271
    func previousIndexPath(for currentIndexPath: IndexPath) -> IndexPath? {
        let startRow = currentIndexPath.row
        let startSection = currentIndexPath.section
        
        var previousRow = startRow
        var previousSection = startSection
        
        if startRow == 0 && startSection == 0 {
            return nil
        } else if startRow == 0 {
            previousSection -= 1
            previousRow = self.numberOfRows(inSection: previousSection) - 1
        } else {
            previousRow -= 1
        }
        
        return IndexPath(row: previousRow, section: previousSection)
    }

}

private extension NSMutableAttributedString {
    /// Appending `Optional` part to existing string
    func appendOptional() {
        let additionalAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.italicSystemFont(ofSize: 12),
            .foregroundColor : UIColor.lightGray
        ]
        let additionalAttributedString =
            NSMutableAttributedString(string: " - " + R.string.addHost.optional(),
                                      attributes: additionalAttributes)
        guard let attributedText =
            additionalAttributedString.copy() as? NSAttributedString else { return }
        self.append(attributedText)
    }

}
