//
//  SubCategoryViewController.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 14/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import AlamofireImage

class UserDetailsViewController: UIViewController {

    var userID: String = ""
    var avatarUrl : String!
    var company : String!
    var followers : Int!
    var following : Int!
    var location : String!
    var name : String!
    var publicRepos : Int!
    
    var imageAvatar: UIImageView!
    var userDetailView: UIView!
    var userNameLabel: UILabel!
    var userIDLabel: UILabel!
    var followersButton: UIButton!
    var followingButton: UIButton!
    var userRepoLabel: UILabel!
    var userCompanyLabel: UILabel!
    var userLocation: UILabel!
    
    let userDetailsModel = UserDetailsViewModel()
    
    let realm = try! Realm()
    var category = Category()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    var userDetails: SearchDetailData = SearchDetailData()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        setupUserDetailView()
        setupNavigationBar()
    }
    
    // MARK: - Methods
    
    func setupUserDetailView() {
        
        self.view.backgroundColor = .gray
        // Setup user details view
        userDetailView = UIView()
        self.view.addSubview(userDetailView)
        userDetailView.backgroundColor = .white
        userDetailView.snp.makeConstraints { (make) -> Void in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(350)
        }
        
        // Setup user avatar
        imageAvatar = UIImageView()
        self.userDetailView.addSubview(imageAvatar)
        imageAvatar.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(70)
            make.leading.equalTo(userDetailView.snp.leading).offset(10)
            make.top.equalTo(userDetailView.snp.top).offset(30)
        }
        imageAvatar.layer.borderWidth = 2
        imageAvatar.layer.borderColor = UIColor.blue.cgColor
        imageAvatar.clipsToBounds = true
        imageAvatar.layer.cornerRadius = 35
        
        // Setup userID Label
        userIDLabel = UILabel()
        self.userDetailView.addSubview(userIDLabel)
        userIDLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(imageAvatar.snp.trailing).offset(20)
            make.top.equalTo(userDetailView.snp.top).offset(30)
        }
        
        // Setup username
        userNameLabel = UILabel()
        self.userDetailView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(userIDLabel.snp.leading)
            make.top.equalTo(userIDLabel.snp.top).offset(30)
        }
        
        // Setup followers button
        followersButton = UIButton()
        self.userDetailView.addSubview(followersButton)
        followersButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.top.equalTo(imageAvatar.snp.bottom).offset(10)
            make.leading.equalTo(userDetailView.snp.leading).offset(10)
        }
        self.followersButton.backgroundColor = .blue
        followersButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        followersButton.tag = 1
        
        // Setup following button
        followingButton = UIButton()
        self.userDetailView.addSubview(followingButton)
        followingButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.leading.equalTo(followersButton.snp.trailing).offset(20)
            make.top.equalTo(imageAvatar.snp.bottom).offset(10)
        }
        self.followingButton.backgroundColor = .blue
        followingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        followingButton.tag = 2
        
        // Setup username
        userRepoLabel = UILabel()
        self.userDetailView.addSubview(userRepoLabel)
        userRepoLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(userDetailView.snp.leading).offset(10)
            make.top.equalTo(followingButton.snp.bottom).offset(20)
        }
        
        // Setup company
        userCompanyLabel = UILabel()
        self.userDetailView.addSubview(userCompanyLabel)
        userCompanyLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(userDetailView.snp.leading).offset(10)
            make.top.equalTo(userRepoLabel.snp.bottom).offset(20)
        }
        
        // Setup username
        userLocation = UILabel()
        self.userDetailView.addSubview(userLocation)
        userLocation.snp.makeConstraints { (make) -> Void in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalTo(userDetailView.snp.leading).offset(10)
            make.top.equalTo(userCompanyLabel.snp.bottom).offset(20)
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .blue
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let BarButtonItemAppearance = UIBarButtonItem.appearance()
        BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        self.title = "User Details screen"
    }
    
    func fetchUserData() {
        userDetailsModel.delegate = self
        category = Category()
        category.name = "\(self.userID) Detail"
        userDetailsModel.getUserDetails(self.userID)
    }
    
    func updateUI() {
        self.userNameLabel.text = "Name: \(self.name ?? "")"
        self.userIDLabel.text = "ID: \(self.userID)"
        self.followersButton.setTitle("\(self.followers ?? 0) Followers", for: .normal)
        self.followingButton.setTitle("\(self.following ?? 0) Following", for: .normal)
        let url = URL(string: self.avatarUrl)!
        let placeholderImage = UIImage(named: "placeholder_ic")
        self.imageAvatar.af_setImage(withURL: url, placeholderImage: placeholderImage)
        self.userRepoLabel.text = "Repositories: \(self.publicRepos ?? 0)"
        self.userCompanyLabel.text = "Company: \(self.company ?? "")"
        self.userLocation.text = "Location: \(self.location ?? "")"
    }
    
    // MARK: - Button Action Event
    
    @objc func buttonAction(sender: UIButton!) {
        let followersListViewController = FollowersViewController()
        followersListViewController.userId = userID
        self.navigationController?.pushViewController(followersListViewController, animated: true)
    }
}

extension UserDetailsViewController: UserDetailsViewModelModelDelegate {
    func getUsersDetailsSuccessful(model: UserDetailsModel) {
        if model.login != nil {
            userID = model.login
            name = model.name
            avatarUrl = model.avatarUrl
            company = model.company
            location = model.location
            publicRepos = model.publicRepos
            followers = model.followers
            following = model.following
        } else {
            let items = (self.categories.filter { $0.name == self.category.name})
            
            for item in items {
                for userDetail in item.userDetails {
                    let userserName = userDetail.login ?? ""
                    if userserName != self.category.name {
                        userID = userDetail.login ?? ""
                        name = userDetail.name ?? ""
                        avatarUrl = userDetail.avatarUrl ?? ""
                        company = userDetail.company ?? ""
                        location = userDetail.location ?? ""
                        publicRepos = Int(userDetail.publicRepos ?? "0")
                        followers = Int(userDetail.followers ?? "0")
                        following = Int(userDetail.following ?? "0")
                        break
                    }
                }
            }
        }
        
        updateUI()
    }
}
