//
//  MemoViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import UIKit
import RealmSwift
import Toast
//NumberFormatter, DateFormatter

class MemoViewController: BaseViewController {
    
    lazy var tableView = UITableView().then {
        $0.rowHeight = 64
        $0.sectionHeaderHeight = 56
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
    }
    
    
    let repository = UserMemoRepository()
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    var filteredArr: [String] = []
    
    var tasks: Results<UserMemo>! {
        didSet {
            self.tableView.reloadData()
            self.navigationItem.title = "\(tasks?.count ?? 0)개의 메모"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
        if !UserDefaults.standard.bool(forKey: "isFirst") {
            self.present(WalkThroughViewController(), animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm()
    }
    
    override func configure() {
        
        view.addSubview(tableView)
        self.navigationController?.isToolbarHidden = false
        
        
        setSearchController()
        setToolbar()
        fetchRealm()
    }
    
    
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = true
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = .systemGray6
    }
    
    func setToolbar(){
        
        var items: [UIBarButtonItem] = []
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let toolbarItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writeButtonTapped))
        
        items.append(flexibleSpace)
        items.append(toolbarItem)
        
        items.forEach { $0.tintColor = .orange }
        
        self.toolbarItems = items
    }
    
    @objc func writeButtonTapped(){
        let vc = WriteViewController()
        self.navigationItem.backButtonTitle = "메모"
        vc.textView.becomeFirstResponder()
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchRealm(){
        tasks = repository.fetchMemo()
    }
    
}

extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return repository.fetchIsFixed() ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HeaderView()
        
        if repository.fetchIsFixed() {
            if section == 0 {
                headerView.headerLabel.text = "고정된 메모"
            } else if section == 1 {
                headerView.headerLabel.text = "메모"
            }
        } else {
            if section == 0 {
                headerView.headerLabel.text = "메모"
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var memoList = [UserMemo]()
        var fixList = [UserMemo]()
        
        for item in tasks {
            if item.isFixed {
                fixList.append(item)
            } else {
                memoList.append(item)
            }
        }
        
        if fixList.count == 0 {
            return memoList.count
        } else {
            return section == 0 ? fixList.count : memoList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell()}
        
        var memoList = [UserMemo]()
        var fixList = [UserMemo]()
        
        for item in tasks {
            if item.isFixed {
                fixList.append(item)
            } else {
                memoList.append(item)
            }
        }
        
        if fixList.count == 0 {
            cell.setData(data: memoList[indexPath.row])
        } else {
            if indexPath.section == 0 {
                cell.setData(data: fixList[indexPath.row])
            } else if indexPath.section == 1 {
                cell.setData(data: memoList[indexPath.row])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var memoList = [UserMemo]()
        var fixList = [UserMemo]()
        
        for item in tasks {
            if item.isFixed {
                fixList.append(item)
            } else {
                memoList.append(item)
            }
        }
         
        let isFixed = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            //분기 처리 해야될 부분 -> 1. 맨 처음 => section0만 존재, 만약 section0, 1 존재
            if fixList.count == 0 {
                self.repository.updateIsFixed(item: memoList[indexPath.row])
            } else {
                if indexPath.section == 0 {
                    self.repository.updateIsFixed(item: fixList[indexPath.row])
                } else if indexPath.section == 1, fixList.count < 5{
                    self.repository.updateIsFixed(item: memoList[indexPath.row])
                } else {
                    self.view.makeToast("5개 까지만 저장할 수 있지롱^~^")
                }
            }
            
            self.tableView.reloadData()
        }
        var image = ""
        if fixList.count == 0 {
            image = "pin.fill"
        } else {
            image = indexPath.section == 0 ? "pin.slash.fill" : "pin.fill"
        }
        isFixed.image = UIImage(systemName: image)
        isFixed.backgroundColor = .orange
        let swipeConfig = UISwipeActionsConfiguration(actions: [isFixed])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: nil) { action, view, comletionHandler in
            self.repository.deleteMemo(item: self.tasks[indexPath.row])
            self.fetchRealm()
        }
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var memoList = [UserMemo]()
        var fixList = [UserMemo]()
        
        for item in tasks {
            if item.isFixed {
                fixList.append(item)
            } else {
                memoList.append(item)
            }
        }
        var title = ""
        var contents = ""
        if fixList.count == 0 {
            title = memoList[indexPath.row].memoTitle
            contents = memoList[indexPath.row].memoContents ?? ""
        } else {
            if indexPath.section == 0 {
                title = fixList[indexPath.row].memoTitle
                contents = fixList[indexPath.row].memoContents ? ""
            } else if indexPath.section == 1{
                title = memoList[indexPath.row].memoTitle
                contents = memoList[indexPath.row].memoContents ? ""
            }
        }
        
        let vc = WriteViewController()
        vc.textView.text = "\(title) + \()"
        self.navigationItem.backButtonTitle = "수정"
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MemoViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        //        self.filteredArr = memoTitle.filter{ $0.lowercased().contains(text) }
        //        dump(filteredArr)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
