//
//  PinWOrder.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 20/11/23.
//

import Foundation

struct PinWOrder: Identifiable{
    var id = UUID()
    var pinContent: Pin
    var orderVO: Int
}
