//
//  UITableView+Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 20.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

// NOTE: Grabbed from
// https://stackoverflow.com/questions/27472249/get-indexpath-of-next-uitableviewcell
public extension UITableView {

    func nextIndexPath(for currentIndexPath: IndexPath) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = currentIndexPath.row
        for section in currentIndexPath.section ..< numberOfSections {
            nextSection = section
            for row in startRow ..< numberOfRows(inSection: section) {
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

        if startRow == 0, startSection == 0 {
            return nil
        } else if startRow == 0 {
            previousSection -= 1
            previousRow = numberOfRows(inSection: previousSection) - 1
        } else {
            previousRow -= 1
        }

        return IndexPath(row: previousRow, section: previousSection)
    }
}
