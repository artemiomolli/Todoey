//
//  Item.swift
//  Todoey
//
//  Created by Артём Гуральник on 2/6/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
