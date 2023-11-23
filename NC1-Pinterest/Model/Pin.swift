//
//  Item.swift
//  NC1-Pinterest
//
//  Created by Alejandro Oliva Ochoa on 13/11/23.
//

import Foundation
import SwiftData

@Model
class Pin {
    var image: Data
    var title: String
    var desc: String
    var link: String
    var date: Date
    
    init(image: Data, title: String, desc: String, link: String) {
        self.image = image
        self.title = title
        self.desc = desc
        self.link = link
        self.date = Date.now
    }
}
