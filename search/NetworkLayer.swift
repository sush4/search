//
//  NetworkLayer.swift
//  search
//
//  Created by Sushant kumar on 16/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import RxSwift
import Foundation

class NetworkLayer: NSObject {

    static func searchUser(user:String) -> Single<[String]> {
        
        
          return Single.create { observer in
            let q = user.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
            let path = "https://api.github.com/search/users?q=\(q)&sort=followers"
            let url :URL = URL(string: path)!
            var request = URLRequest(url: url)
            
                request.httpMethod = "GET"
                let session = URLSession.shared
            
                session.dataTask(with: request) {data, response, err in
                    if let list = data {
                        do {
                        
                        let jsonResponse = try JSONSerialization.jsonObject(with: list, options: .mutableContainers)
                        
                            guard let dictionary = jsonResponse as? [String: Any], let userList = dictionary["items"] as? Array<Dictionary<String,Any>>, let name: [String] = userList.flatMap({ userList in
                                userList["login"]}) as? [String] else{
                                observer(.error(NSError()))
                                    return
                            }
                            observer(.success(name))
            
                        } catch let myJSONError {
                            observer(.error(myJSONError))
                        }
                    } else {
                            observer(.error(err ?? NSError()))
                    }
                    
                }.resume()
                return Disposables.create()
                }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
                .observeOn(MainScheduler.instance)
        
    }
}
