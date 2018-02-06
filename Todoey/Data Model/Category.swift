//
//  Category.swift
//  Todoey
//
//  Created by Артём Гуральник on 2/6/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    let items = List<Item>()
}
