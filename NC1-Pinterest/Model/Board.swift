//
//  Board.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 17/11/23.
//

import Foundation
import SwiftData

@Model
class Board {
    var name: String
    var pins: [Pin]
    var date: Date
    
    init(name: String, pins: [Pin]) {
        self.name = name
        self.pins = pins
        self.date = Date.now
    }
}
