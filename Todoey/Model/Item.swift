//
//  Item.swift
//  Todoey
//
//  Created by Jakub Jachowski on 29/08/2019.
//  Copyright © 2019 Jakub Jachowski. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var timeCreated = Date()
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
