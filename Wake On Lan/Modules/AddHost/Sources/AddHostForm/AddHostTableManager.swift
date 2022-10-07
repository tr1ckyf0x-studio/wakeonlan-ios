//
//  AddHostTableManager.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import SharedExtensions
import UIKit
import WOLResources
import WOLUIComponents

// TODO: Implement custom header/footer views
final class AddHostTableManager: NSObject {

    weak var delegate: AddHostTableManagerDelegate?

    var form: AddHostForm?

    var sections: [FormSection] {
        guard let form else { return [] }
        return form.sections
    }

}

// MARK: - UITableViewDataSource

extension AddHostTableManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let model = sections[indexPath.section].items[indexPath.row]
        switch model {
        case .text(let textFormItem):
            let textInputCell = tableView.dequeueReusableCell(
                withIdentifier: "\(TextInputCell.self)",
                for: indexPath
            ) as? TextInputCell
            textFormItem.indexPath = indexPath
            textInputCell?.configure(with: model)
            // Scroll table view to next responder
            textInputCell?.onNextResponderAction = { indexPath in
                guard
                    let nextIndexPath = tableView.nextIndexPath(for: indexPath)
                else {
                    return
                }
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

        case .icon:
            let deviceIconCell = tableView.dequeueReusableCell(
                withIdentifier: "\(DeviceIconCell.self)",
                for: indexPath
            ) as? DeviceIconCell
            deviceIconCell?.configure(with: form?.iconModel)
            deviceIconCell?.didTapChangeIconBlock = { [weak self] model in
                guard let self else { return }
                self.delegate?.tableManagerDidTapDeviceIconCell(self, model)
            }
            cell = deviceIconCell
        }

        guard let unwrappedCell = cell else {
            fatalError("\(self): Unknown cell identifier")
        }

        return unwrappedCell
    }

}

// MARK: - UITableViewDelegate

extension AddHostTableManager: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        guard
            let sectionHeader = sections[section].header, !sectionHeader.isMandatory,
            let header = view as? UITableViewHeaderFooterView,
            let headerLabel = header.textLabel,
            let headerText = headerLabel.text
        else {
            return
        }
        // Make source attributed string
        let sourceAttributes: [NSAttributedString.Key: UIFont] = [.font: headerLabel.font]
        let sourceAttributedString = NSMutableAttributedString(
            string: headerText,
            attributes: sourceAttributes
        )
        sourceAttributedString.appendOptional()
        headerLabel.attributedText = sourceAttributedString
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].header?.header
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footer?.footer
    }

}

private extension NSMutableAttributedString {

    /// Appending `Optional` part to existing string
    func appendOptional() {
        let additionalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 12),
            .foregroundColor: Asset.Colors.secondary.color
        ]
        let additionalAttributedString =
            NSMutableAttributedString(
                string: " - " + L10n.AddHost.optional,
                attributes: additionalAttributes
            )
        guard
            let attributedText = additionalAttributedString.copy() as? NSAttributedString
        else {
            return
        }
        append(attributedText)
    }

}
