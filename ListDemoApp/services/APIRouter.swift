//
//  APIRouter.swift
//  Zalck
//
//  Created by Vishal Kale on 14/11/19.
//  Copyright © 2019 Zalck. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRouter: URLRequestConvertible {
    static var baseURLPath: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

public enum APIRouter: NetworkRouter, Equatable {
    
    static var baseURLPath: String {
        return "https://api.github.com"
    }
    
    case getSearchUserList(parameters: Parameters)
    case getUserDetails(parameters: Parameters)
    case getUserFollowersList(parameters: Parameters)

    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getSearchUserList:
            return "/search/users"
        case .getUserDetails:
            return "/users"
        case .getUserFollowersList:
            return "/users"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        //Setting the request with all the necessary parameters for the call
        
        let url = try APIRouter.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(30)
        
        switch self {
        case .getSearchUserList(let parameters):
            var urlRequestLocal = request
            if let stringUrl = request.url?.absoluteString{
                if let userID = parameters["q"], let page = parameters["page"] {
                    let urlString = "\(stringUrl)?q=\(userID)&page=\(page)"
                    urlRequestLocal.url = URL(string: urlString)
                }
            }
            return try JSONEncoding.default.encode(urlRequestLocal, with: nil)
            
        case .getUserDetails(let parameters):
            var urlRequestLocal = request
            if let stringUrl = request.url?.absoluteString{
                if let userID = parameters["username"] {
                    let urlString = "\(stringUrl)/\(userID)"
                    urlRequestLocal.url = URL(string: urlString)
                }
            }
            return try JSONEncoding.default.encode(urlRequestLocal, with: nil)
            
        case .getUserFollowersList(let parameters):
            var urlRequestLocal = request
            if let stringUrl = request.url?.absoluteString{
                if let userID = parameters["username"] {
                    let urlString = "\(stringUrl)/\(userID)/followers"
                    urlRequestLocal.url = URL(string: urlString)
                }
            }
            return try JSONEncoding.default.encode(urlRequestLocal, with: nil)
        }
    }
    
    public static func ==(lhs: APIRouter, rhs: APIRouter) -> Bool {
        return lhs.path == rhs.path && lhs.method == rhs.method && lhs.urlRequest == rhs.urlRequest
    }
}
