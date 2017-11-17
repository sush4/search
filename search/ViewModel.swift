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
        NetworkLayer.searchUser(user: query).subscribe(onSuccess: { result in
            self.list.value = result
            self.dismiss.onNext(true)
        }).disposed(by: disposeBag)
        
    }

}
