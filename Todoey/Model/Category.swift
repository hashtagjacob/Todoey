//
//  Category.swift
//  Todoey
//
//  Created by Jakub Jachowski on 29/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
