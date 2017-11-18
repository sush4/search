//
//  ViewController.swift
//  search
//
//  Created by Sushant kumar on 16/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let CellReuseIdentifier = "tableViewCell"
    private var userList: Array<String> = Array()
    private let disposeBag = DisposeBag()
    private let viewModel: ViewModel = ViewModel()
    private let refresh = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Git Users"
        self.setUpView()
    }
    
    private func setUpView() {
        
        searchBar.placeholder = "Search Git Users"
        weak var weakSelf = self
        
        searchBar.rx.text.orEmpty.changed.throttle(0.3, scheduler: MainScheduler.asyncInstance).asObservable().subscribe(onNext: { test in
            SVProgressHUD.show()
            weakSelf?.search()
        }).disposed(by: disposeBag)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellReuseIdentifier)
        tableView.addSubview(refresh)
        
        refresh.addTarget(self, action:  #selector(ViewController.refreshList), for: .valueChanged)
        
        viewModel.list.asObservable().bind(to: tableView.rx.items(cellIdentifier: CellReuseIdentifier)){
            index, name, cell in
            cell.textLabel?.text = name
            }.disposed(by: disposeBag)
        
        viewModel.dismiss.asObserver().subscribe(onNext: { ACTION in
            SVProgressHUD.dismiss()
            weakSelf?.refresh.endRefreshing()
        },onError: { err in
            SVProgressHUD.showError(withStatus: err.localizedDescription)
            weakSelf?.refresh.endRefreshing()
        }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refreshList() {
        refresh.beginRefreshing()
        search()
    }
    
    func search(){
        viewModel.searchUser(query: searchBar.text ?? "")
    }

}

