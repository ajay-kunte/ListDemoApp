//
//  APIService.swift
//  Zalck
//
//  Created by Vishal Kale on 14/11/19.
//  Copyright © 2019 Zalck. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class APIService: NSObject {
    
    class func getSearchUserList<T: BaseModel>(requestEndPoint: APIRouter,
                                         completion: @escaping (_ viewModel :T?, _ error: Error?) -> Void){
        makeRequest(requestEndpoint: requestEndPoint, completion: completion)
    }
    
    class func getUserDetails<T: BaseModel>(requestEndPoint: APIRouter,
                                         completion: @escaping (_ viewModel :T?, _ error: Error?) -> Void){
        makeRequest(requestEndpoint: requestEndPoint, completion: completion)
    }
    
    class func getFollowersList<T: BaseModel>(requestEndPoint: APIRouter,
                                         completion: @escaping (_ viewModel :T?, _ error: Error?) -> Void){
        makeRequest(requestEndpoint: requestEndPoint, completion: completion)
    }
}

// MARK: Base API Call

extension APIService {
    private class func makeRequest<T: BaseModel>(requestEndpoint: APIRouter,
                                                 completion: @escaping (_ viewModel: T?, _ error: Error?) -> Void) {

        print("network: URL \(requestEndpoint.urlRequest?.url?.absoluteString ?? "")")
        print("network: Method \(requestEndpoint.urlRequest?.httpMethod ?? "")")
        print("network: headers \(requestEndpoint.urlRequest?.allHTTPHeaderFields ?? [:])")
        print("network: parameters \(JSON(requestEndpoint.urlRequest?.httpBody ?? Data()).rawString(options: .prettyPrinted) ?? "")")

        Alamofire
            .request(requestEndpoint)
            .responseJSON { response in
                
                guard let data = response.data else {
                    completion(nil, response.error)
                    return
                }
                
                let swiftyJsonVar = JSON(data)
                print("network: response \(swiftyJsonVar.rawString(options: [.prettyPrinted]) ?? "")")
                print("network: ############################################################")
                let responseModel = T.init(fromJson: swiftyJsonVar)
                completion(responseModel, nil)
        }
    }
}
