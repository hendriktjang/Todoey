//
//  Category.swift
//  Todoey
//
//  Created by Hendrik Hendrik on 19/8/18.
//  Copyright © 2018 Hendrik Hendrik. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
