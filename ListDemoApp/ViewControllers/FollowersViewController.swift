//
//  FollowersViewController.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 14/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift

class FollowersViewController: UIViewController {

    var userId: String = ""
    var listType: String = ""
    var followersList: [PeopleListModelItem] = []
    let peopleListModel = PeopleListDataViewModel()
    
    let realm = try! Realm()
    var category = Category()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    var peopleList: List<PeopleData> = List<PeopleData>()
    
    var followersListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        fetchPeopleList()
    }
    
    // MARK: - Methods

    func setupTableView() {
        followersListTableView = UITableView(frame: .zero)
        self.view.addSubview(followersListTableView)
        followersListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        followersListTableView.register(FollowersTableViewCell.self, forCellReuseIdentifier: FollowersTableViewCell.identifier)
        followersListTableView.dataSource = self
        followersListTableView.delegate = self
        //followersListTableView.estimatedRowHeight = 200
        followersListTableView.tableFooterView = UIView()
    }
    
    func fetchPeopleList() {
        peopleListModel.delegate = self
        category = Category()
        category.name = self.userId
        peopleListModel.getPeoplesList(self.userId)
    }
}

extension FollowersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersList.count == 0 ? peopleList.count : followersList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = .zero
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowersTableViewCell.identifier, for: indexPath) as! FollowersTableViewCell
        if !followersList.isEmpty {
            cell.followerNameLabel.text = followersList[indexPath.row].login
            let url = URL(string: followersList[indexPath.row].avatarUrl)!
            let placeholderImage = UIImage(named: "placeholder_ic")!
            cell.avatarView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            cell.followerNameLabel.text = peopleList[indexPath.row].login
            let url = URL(string: peopleList[indexPath.row].avatar)!
            let placeholderImage = UIImage(named: "placeholder_ic")!
            cell.avatarView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FollowersViewController: PeopleListDataViewModelDelegate {
    func getPeopleListSuccessful(model: PeopleListDataModel) {
        if model.items != nil {
            followersList = model.items
        } else {
            let items = self.categories.filter { $0.name == self.category.name}
            for item in items {
                if item.name == category.name {
                    peopleList = item.peopleList
                    break
                }
            }
        }
        self.followersListTableView.reloadData()
    }
}
