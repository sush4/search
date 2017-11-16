//
//  ViewController.swift
//  search
//
//  Created by Sushant kumar on 16/11/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let CellReuseIdentifier = "tableViewCell"
    private var userList: Array<String> = Array()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Git Users"
        self.setUpView()
    }
    
    private func setUpView() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Git Users"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SVProgressHUD.show()
        let result = NetworkLayer.searchUser(user: searchText)
        result.subscribe(onSuccess: { list in
            self.userList = list
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }) { err in
            SVProgressHUD.showError(withStatus: "Error occurred")
        }.disposed(by: disposeBag)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = userList[indexPath.row]
        return cell
    }
    
}

