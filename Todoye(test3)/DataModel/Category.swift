//
//  Category.swift
//  Todoye(test3)
//
//  Created by Nurqalam on 04.02.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
