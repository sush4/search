//
//  GitHubProvider.swift
//  search
//
//  Created by Sushant kumar on 18/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import Foundation
import Moya

enum GitHub{
    case userProfile(String)
}

extension GitHub: TargetType{
    
    var path: String {
        switch self {
        case .userProfile( _):
            return "/search/users"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .userProfile( _):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .userProfile(let user):
            return "{\"search\": \"\(user)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .userProfile(let user):
            return .requestParameters(parameters: ["q": user,"sort" : "followers"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .userProfile( _):
            return nil
        }
    }
    
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
}
