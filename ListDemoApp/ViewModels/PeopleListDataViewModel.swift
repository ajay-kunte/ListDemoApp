//
//  PeopleListDataViewModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 19/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

protocol PeopleListDataViewModelDelegate: class {
    func getPeopleListSuccessful(model: PeopleListDataModel)
}

class PeopleListDataViewModel {
    
    weak var delegate: PeopleListDataViewModelDelegate?
    
    let realm = try! Realm()
    var category = Category()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
        
    func getPeoplesList(_ username: String) {
        let parameters = ["username": username] as [String : Any]
        APIService.getFollowersList(requestEndPoint: .getUserFollowersList(parameters: parameters)) { (model: PeopleListDataModel?, error: Error?) in
            if let model = model {
                
                self.category = Category()
                self.category.name = username.capitalized
                
                let followersList = self.categories.filter { $0.name == self.category.name}
                
                for item in followersList {
                    if item.name == self.category.name {
                        self.save(category: self.category)
                        self.savePeopleList(category: self.category, model: model)
                        break
                    }
                }
                
                self.delegate?.getPeopleListSuccessful(model: model)
            }
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category: \(error)")
        }
    }
    
    func savePeopleList(category: Category, model: PeopleListDataModel) {
        guard model.items != nil else {
            return
        }
        do {
            try self.realm.write {
                for item in model.items {
                    let data = PeopleData()
                    data.login = item.login
                    data.avatar = item.avatarUrl
                    category.peopleList.append(data)
                }
                print("Realm Path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
            }
        } catch {
            print("Error Saving People list: \(error)")
        }
    }
}
