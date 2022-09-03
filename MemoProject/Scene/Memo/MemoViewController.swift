//
//  MemoViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import UIKit
import RealmSwift

//NumberFormatter, DateFormatter

class MemoViewController: BaseViewController {
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 54
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 60))
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
    
    override func configure() {
        
        searchController.view.addSubview(tableView)
        tableView.addSubview(toolbar)
        
        setSearchController()
        setToolbar()
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(searchController.view.safeAreaLayoutGuide)
        }
        
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.title = "\(tasks.count)개의 메모"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setToolbar(){
        
        var items: [UIBarButtonItem] = []
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let toolbarItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        
        items.append(flexibleSpace)
        items.append(toolbarItem)
        
        items.forEach { $0.tintColor = .orange }
        
        toolbar.setItems(items, animated: true)
    }
    
    @objc func writeButtonTapped(){
        let vc = WriteViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(nav, animated: true)
    }
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text = tasks[indexPath.row].memoTitle
        //cell.dateLabel.text = tasks[indexPath.row].memoDate
       cell.contentsLabel.text = tasks[indexPath.row].memoContents ?? "추가텍스트 없음"
        
        return cell
    }
    
    
}

extension MemoViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
//        self.filteredList = diaryTitleList?.filter{ $0.lowercased().contains(text) }
//        dump(filteredList)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
