//
//  Category.swift
//  Todoey
//
//  Created by Adithep Pruekpitakpong on 22/12/2561 BE.
//  Copyright © 2561 Adithep Pruekpitakpong. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
