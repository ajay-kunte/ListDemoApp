//
//  Category.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 14/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<SearchData>()
    var userDetails = List<SearchDetailData>()
    let peopleList = List<PeopleData>()
}
