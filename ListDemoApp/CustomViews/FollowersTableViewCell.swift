//
//  FollowersTableViewCell.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 19/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {
    static let identifier: String = "FollowersTableViewCell"

    var followerNameLabel: UILabel!
    var avatarView: UIImageView!
    var view: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    func configure() {
        
        view = UIView(frame: .zero)
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        
        avatarView = UIImageView()
        self.view.addSubview(avatarView)
        avatarView.snp.makeConstraints {(make) -> Void in
            make.leading.top.equalToSuperview().offset(5)
            make.width.height.equalTo(70)
        }
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 35
        
        followerNameLabel = UILabel()
        self.view.addSubview(followerNameLabel)
        followerNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(avatarView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
