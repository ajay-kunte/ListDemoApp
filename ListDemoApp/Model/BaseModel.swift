//
//  BaseModel.swift
//  ListDemoApp
//
//  Created by Ajay Kunte on 18/08/20.
//  Copyright © 2020 Ajay Kunte. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol BaseModel {
    init(fromJson json: JSON!)
}
