//
//  ViewModel.swift
//  search
//
//  Created by Sushant kumar on 16/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import RxSwift

class ViewModel: NSObject {
    
    var list: Variable<[String]> = Variable([])
    var dismiss: PublishSubject<Bool> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    func searchUser(query: String) {

        NetworkLayer.searchUser(user: query).subscribe({ result in
            switch result {
                case .next(let tempList):
                    self.list.value = tempList 
                case .completed:
                    self.dismiss.onNext(true)
                case .error(let err):
                    self.dismiss.onError(err)
            }
        }).disposed(by: disposeBag)
        
    }

}
