//
//  UserListViewModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 18/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserListViewModelDelegate: class {
    func getUsersListSuccessful(model: UserListModel)
}

class UserListViewModel {
    
    weak var delegate: UserListViewModelDelegate?
    let realm = try! Realm()
    var category = Category()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    
    func getUserList(_ searchText: String) {
        let parameters = ["q": searchText, "page":1] as [String : Any]
        APIService.getSearchUserList(requestEndPoint: .getSearchUserList(parameters: parameters)) { (model: UserListModel?, error: Error?) -> Void in
            if let model = model {
                self.category = Category()
                self.category.name = searchText
                
                if (self.categories.filter { $0.name == self.category.name}).count == 0 {
                    self.save(category: self.category)
                    self.saveSearchList(category: self.category, model: model)
                }
                
                self.delegate?.getUsersListSuccessful(model: model)
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
    
    func saveSearchList(category: Category, model: UserListModel) {
        do {
            try self.realm.write {
                for item in model.items {
                    let data = SearchData()
                    data.userName = item.name
                    category.items.append(data)
                }
                print("Realm Path: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
            }
        } catch {
            print("Error Saving Category: \(error)")
        }
    }
}
