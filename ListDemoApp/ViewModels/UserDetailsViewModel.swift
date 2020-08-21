//
//  UserDetailsViewModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 19/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserDetailsViewModelModelDelegate: class {
    func getUsersDetailsSuccessful(model: UserDetailsModel)
}

class UserDetailsViewModel {
    
    weak var delegate: UserDetailsViewModelModelDelegate?
    let realm = try! Realm()
    var category = Category()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
        
    func getUserDetails(_ username: String) {
        let parameters = ["username": username] as [String : Any]
        APIService.getUserDetails(requestEndPoint: .getUserDetails(parameters: parameters)) { (model: UserDetailsModel?, error: Error?) in
            if let model = model {
                self.category = Category()
                self.category.name = username.capitalized
                
                let items = (self.categories.filter { $0.name == self.category.name})
                
                outerloop:for item in items {
                    
                    if item.userDetails.isEmpty {
                        self.save(category: self.category)
                        self.saveUserDetails(category: self.category, model: model)
                        break outerloop
                    }
                    for userDetail in item.userDetails {
                        let name = userDetail.login ?? ""
                        if name != self.category.name {
                            self.save(category: self.category)
                            self.saveUserDetails(category: self.category, model: model)
                            break outerloop
                        }
                    }
                }
                
                self.delegate?.getUsersDetailsSuccessful(model: model)
            }
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving User User Details: \(error)")
        }
    }
    
    func saveUserDetails(category: Category, model: UserDetailsModel) {
        do {
            try self.realm.write {
                
                let data = SearchDetailData()
                data.avatarUrl = model.avatarUrl
                data.company = model.company
                data.followers = "\(model.followers ?? 0)"
                data.following = "\(model.following ?? 0)"
                data.location = model.location
                data.login = model.login
                data.name = model.name
                data.publicRepos = "\(model.publicRepos ?? 0)"
                category.userDetails.append(data)
                print("Realm Path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
            }
        } catch {
            print("Error Saving Category: \(error)")
        }
    }
}
