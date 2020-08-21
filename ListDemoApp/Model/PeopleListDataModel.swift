//
//  PeopleListDataModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 19/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import SwiftyJSON

class PeopleListDataModel : NSObject, BaseModel {

    var items : [PeopleListModelItem]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        items = [PeopleListModelItem]()
        let itemsArray = json.arrayValue
        for itemsJson in itemsArray{
            let value = PeopleListModelItem(fromJson: itemsJson)
            items.append(value)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if items != nil{
        var dictionaryElements = [[String:Any]]()
        for itemsElement in items {
            dictionaryElements.append(itemsElement.toDictionary())
        }
        dictionary["items"] = dictionaryElements
        }
        return dictionary
    }
}

class PeopleListModelItem : NSObject {

    var avatarUrl : String!
    var login : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        avatarUrl = json["avatar_url"].stringValue
        login = json["login"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if avatarUrl != nil{
            dictionary["avatar_url"] = avatarUrl
        }
        if login != nil{
            dictionary["login"] = login
        }
        return dictionary
    }
}
