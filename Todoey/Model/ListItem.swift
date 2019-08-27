//
//  ListItem.swift
//  Todoey
//
//  Created by Jakub Jachowski on 27/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import Foundation

class ListItem : Codable {
    var itemText = ""
    var isSelected = false
    
    init(text: String) {
        itemText = text
        isSelected = false
    }
}


