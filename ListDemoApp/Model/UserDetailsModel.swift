//
//  UserDetailsModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 19/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserDetailsModel : NSObject, BaseModel {

    var avatarUrl : String!
    var company : String!
    var followers : Int!
    var following : Int!
    var location : String!
    var login : String!
    var name : String!
    var publicRepos : Int!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        login = json["login"].stringValue
        name = json["name"].stringValue
        avatarUrl = json["avatar_url"].stringValue
        company = json["company"].stringValue
        location = json["location"].stringValue
        followers = json["followers"].intValue
        following = json["following"].intValue
        publicRepos = json["public_repos"].intValue
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
        if company != nil{
            dictionary["company"] = company
        }
        if followers != nil{
            dictionary["followers"] = followers
        }
        if following != nil{
            dictionary["following"] = following
        }
        if location != nil{
            dictionary["location"] = location
        }
        if login != nil{
            dictionary["login"] = login
        }
        if name != nil{
            dictionary["name"] = name
        }
        if publicRepos != nil{
            dictionary["public_repos"] = publicRepos
        }
        return dictionary
    }
}
