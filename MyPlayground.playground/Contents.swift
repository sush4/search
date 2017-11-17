//: Playground - noun: a place where people can play

import UIKit
import RxAlamofire

let path = "https://api.github.com/search/users"
let query: [String: Any] = ["q":"user",
                            "sort":"followers"]

RxAlamofire.requestJSON(.get,path, parameters: query,encoding:.default,headers:nil).debug().map{ result in
    guard let data = result.1 as? [String:Any], let list = data["items"] as? [[String:Any]] else {
        return []
    }
    return list.flatMap({ user -> String? in
        if let name = user["login"] as? String {
            return name
        } else {
            return nil
        }
    })}.subscribe(onNext: { list in
        print(list)
    }).disposed(by: dispose)
