//
//  NetworkLayer.swift
//  search
//
//  Created by Sushant kumar on 16/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import Foundation
import RxAlamofire
import RxSwift
import Moya

class NetworkLayer: NSObject {

    static func searchUser(user:String) -> Single<[String]> {
        
        let path = "https://api.github.com/search/users"
        let query: [String: Any] = ["q":user,
                     "sort":"followers"]
        
        return RxAlamofire.requestJSON(.get,path, parameters: query).debug().map{ result in
            guard let data = result.1 as? [String:Any], let list = data["items"] as? [[String:Any]] else {
                return []
            }
            return list.flatMap({ user -> String? in
                if let name = user["login"] as? String {
                    return name
                } else {
                    return nil
                }
            })}.asSingle()
    }
}
