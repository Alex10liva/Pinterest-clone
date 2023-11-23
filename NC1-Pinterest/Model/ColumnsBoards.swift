//
//  ColumnsBoard.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 21/11/23.
//

import Foundation

struct ColumnBoards: Identifiable{
    var id = UUID()
    var columnContent = [Board]()
}
