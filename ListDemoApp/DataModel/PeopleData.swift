//
//  PeopleData.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 20/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

class PeopleData: Object {
    @objc dynamic var login : String!
    @objc dynamic var avatar : String!
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "peopleList")
}
