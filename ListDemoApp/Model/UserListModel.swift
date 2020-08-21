//
//  UserListModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 18/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserListModel : NSObject, BaseModel {

    var items : [UserListModelItem]!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        items = [UserListModelItem]()
        let itemsArray = json["items"].arrayValue
        for itemsJson in itemsArray{
            let value = UserListModelItem(fromJson: itemsJson)
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

class UserListModelItem : NSObject {

    var name : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        name = json["login"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["login"] = name
        }
        return dictionary
    }
}

