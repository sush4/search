//
//  NetworkLayer.swift
//  search
//
//  Created by Sushant kumar on 16/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class NetworkLayer: NSObject {

    private static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
    
    
    static let gitHubProvider = MoyaProvider<GitHub>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    
    static func searchUser(user:String) -> Observable<[String]> {
        
        return gitHubProvider.rx.request(GitHub.userProfile(user)).debug().map { result in
            
            guard let data = try result.mapJSON() as? [String:Any], let list = data["items"] as? [[String:Any]] else {
                return []
            }
            return list.flatMap({ user -> String? in
                if let name = user["login"] as? String {
                    return name
                } else {
                    return nil
                }
            })}.asObservable()
        }

}
