//
//  SearchDetailData.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 20/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

class SearchDetailData: Object {
    @objc dynamic var avatarUrl : String!
    @objc dynamic var company : String!
    @objc dynamic var followers : String!
    @objc dynamic var following : String!
    @objc dynamic var location : String!
    @objc dynamic var login : String!
    @objc dynamic var name : String!
    @objc dynamic var publicRepos : String!
}
