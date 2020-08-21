//
//  SearchData.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 20/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

class SearchData: Object {
    @objc dynamic var userName : String!
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
