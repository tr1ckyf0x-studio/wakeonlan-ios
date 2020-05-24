//
//  AddHostTableManager.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class AddHostTableManager: NSObject {
    
    var form: AddHostForm?
    
    var sections: [FormSection] {
        guard let form = form else { return [] }
        return form.formSections
    }
    
}

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
        case .text:
            let textInputCell =
                tableView.dequeueReusableCell(
                    withIdentifier: TextInputCell.reuseIdentifier, for: indexPath) as? TextInputCell
            textInputCell?.configure(with: model)
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
        }
        guard let unwrappedCell = cell else { fatalError("\(self): Unknown cell identifier") }
        
        return unwrappedCell
    }
}

extension AddHostTableManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
