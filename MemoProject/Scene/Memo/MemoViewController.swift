//
//  MemoViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import UIKit
import RealmSwift

class MemoViewController: BaseViewController {
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 54
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let repository = UserMemoRepository()
    
    var fixedList: [String]?
    
    var tasks: Results<UserMemo>! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell()}
        
        return cell
    }
    
    
}
