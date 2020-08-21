//
//  ViewController.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 13/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    var dataArray = [String]()
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    
    let userListModel = UserListViewModel()
    var userListData: [UserListModelItem] = []
    
    let realm = try! Realm()
    var category = Category()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    var userList: List<SearchData> = List<SearchData>()

    var searchResultTableView: UITableView!
    var searchController: UISearchController!
    
    // MARK: - View Controller Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Navigation Bar
        setupNavigationBar()
        
        // Configure Search Bar
        configureSearchController()
        
        // Setup tableview
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = searchResultTableView.indexPathForSelectedRow {
            searchResultTableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: - Methods

    func setupTableView() {
        searchResultTableView = UITableView(frame: .zero)
        self.view.addSubview(searchResultTableView)
        searchResultTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self

        searchResultTableView.estimatedRowHeight = 70
        searchResultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.searchResultTableView.reloadData()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .darkGray
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = "Search"
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Github users.."
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.tintColor = .black
     
        // Place the search bar view to the tableview headerview.
        self.navigationItem.searchController = searchController
    }
    
    func fetchUserList() {
        userListModel.delegate = self
        let searchText = searchController.searchBar.text ?? ""
        category = Category()
        category.name = searchText
        userListModel.getUserList(searchText)
    }
    
    // MARK: - SearchBar Delegate Methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchResultTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchResultTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchUserList()
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            searchResultTableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
        self.searchResultTableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userListData.count == 0 ? userList.count : userListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        if userListData.count != 0 {
            cell.textLabel?.text = userListData[indexPath.row].name
        } else if userList.count != 0 {
            cell.textLabel?.text = userList[indexPath.row].userName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let subCategoryViewController = UserDetailsViewController()
        subCategoryViewController.userID = cell?.textLabel?.text ?? ""
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(subCategoryViewController, animated: true)
    }
}

extension SearchViewController: UserListViewModelDelegate {
    
    func getUsersListSuccessful(model: UserListModel) {
        if model.items != nil {
            userListData = model.items
        }
        if (self.categories.filter { $0.name == self.category.name})[0].name == category.name {
            userList = (self.categories.filter { $0.name == self.category.name})[0].items
        }
        searchResultTableView.reloadData()
    }
}

