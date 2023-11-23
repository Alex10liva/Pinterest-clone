//
//  Column.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 14/11/23.
//

import Foundation

struct ColumnPins: Identifiable{
    var id = UUID()
    var columnContent = [PinWOrder]()
}
