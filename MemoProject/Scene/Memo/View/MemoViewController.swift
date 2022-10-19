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

final class MemoViewController: BaseViewController {
    
    private let viewModel = MemoViewModel()
    
    lazy var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 300, height: 300), style: .insetGrouped).then {
        $0.rowHeight = 64
        $0.sectionHeaderHeight = 56
        $0.backgroundColor = Constants.BaseColor.background
        $0.delegate = self
        $0.dataSource = self
        $0.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
    }
    
    
    private let repository = UserMemoRepository()
        
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    var filteredItem: Results<UserMemo>!
    var filteredText: String?
    var fixedList: Results<UserMemo>!
    var memoList: Results<UserMemo>!
    
    var tasks: Results<UserMemo>! {
        didSet {
            self.tableView.reloadData()
            self.navigationItem.title = "\(getNumFormat(for: tasks.count))개의 메모"
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
            make.edges.equalToSuperview()
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
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        naviBackground()
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
    
    func devideByIsFixed(){
        memoList = repository.fetchMemo().where{ $0.isFixed == false }
        fixedList = repository.fetchMemo().where{ $0.isFixed == true }
    }
}

//MARK: TableView Delegate, DataSource
extension MemoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering || !repository.fetchIsFixed() ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = HeaderView()
        // searchController is on
        if isFiltering {
            headerView.headerLabel.text = "\(getNumFormat(for: filteredItem.count))개 찾음"
        } else {
        // searchController is off
                if !repository.fetchIsFixed() {
                    if section == 0 {
                        headerView.headerLabel.text = "메모"
                    }
                } else {
                    if section == 0 {
                        headerView.headerLabel.text = "고정된 메모"
                    } else if section == 1 {
                        headerView.headerLabel.text = "메모"
                    }
                }
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        devideByIsFixed()
        
        if isFiltering {
            return filteredItem.count
        } else {
            if fixedList.count == 0 {
                return memoList.count
            } else {
                return section == 0 ? fixedList.count : memoList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else { return UITableViewCell()}
        
        devideByIsFixed()
        
        if isFiltering {
            cell.setData(data: filteredItem[indexPath.row])
            cell.titleLabel.attributedText = changeFilteredColor(totalString: filteredItem[indexPath.row].memoTitle, searchString: filteredText ?? "")
            cell.contentsLabel.attributedText = changeFilteredColor(totalString: filteredItem[indexPath.row].memoContents ?? "", searchString: filteredText ?? "")
            
        } else {
            if fixedList.count == 0 {
                cell.setData(data: memoList[indexPath.row])
            } else {
                indexPath.section == 0 ? cell.setData(data: fixedList[indexPath.row]) : cell.setData(data: memoList[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        devideByIsFixed()
        
        let isFixed = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print(indexPath.description)
            //분기 처리 해야될 부분 -> 1. 맨 처음 => section0만 존재, 만약 section0, 1 존재
            //isFiltering 넣고
            if self.isFiltering {
                self.repository.updateIsFixed(item: self.filteredItem[indexPath.row])
            } else {
                if self.fixedList.count == 0 {
                    self.repository.updateIsFixed(item: self.memoList[indexPath.row])
                } else {
                    if indexPath.section == 0 {
                        self.repository.updateIsFixed(item: self.fixedList[indexPath.row])
                    } else if indexPath.section == 1, self.fixedList.count < 5{
                        self.repository.updateIsFixed(item: self.memoList[indexPath.row])
                    } else {
                        self.view.makeToast("5개 까지만 저장할 수 있지롱^~^")
                    }
                }
                
            }
            self.fetchRealm()
        }
        
        var image = ""
        
        if isFiltering {
            if filteredItem[indexPath.row].isFixed {
                image = "pin.slash.fill"
            } else {
                image = "pin.fill"
            }
        } else {
            if fixedList.count == 0 {
                image = "pin.fill"
            } else {
                image = indexPath.section == 0 ? "pin.slash.fill" : "pin.fill"
            }
        }
        
        isFixed.image = UIImage(systemName: image)
        isFixed.backgroundColor = .orange
        let swipeConfig = UISwipeActionsConfiguration(actions: [isFixed])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
                
        let delete = UIContextualAction(style: .destructive, title: nil) { action, view, comletionHandler in
            
            if self.isFiltering {
                self.repository.deleteMemo(item: self.filteredItem[indexPath.row])
            } else {
                self.repository.deleteMemo(item: self.tasks[indexPath.row])
            }
            self.fetchRealm()
        }
        delete.backgroundColor = .red
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        devideByIsFixed()
        
        let vc = WriteViewController()
        
        if fixedList.count == 0 {
            vc.memoTask = memoList[indexPath.row]
        } else {
            if indexPath.section == 0 {
                vc.memoTask = fixedList[indexPath.row]
            } else if indexPath.section == 1{
                vc.memoTask = memoList[indexPath.row]
            }
        }
        
        self.navigationItem.backButtonTitle = "수정"
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MemoViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        filteredItem = self.repository.fetchMemo().where { $0.memoTitle.contains(text) || $0.memoContents.contains(text) }
        filteredText = searchController.searchBar.text?.lowercased()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    func changeFilteredColor(totalString: String, searchString: String) -> NSMutableAttributedString{
        let attrStr = NSMutableAttributedString(string: totalString)
        var range = NSRange(location: 0, length: totalString.count)
        var rangeArray = [NSRange]()
        
        while(range.location != NSNotFound){
            range = (attrStr.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
            rangeArray.append(range)
            if (range.location != NSNotFound){
                range = NSRange(location: range.location + range.length, length: totalString.count - (range.location + range.length))
            }
        }
        rangeArray.forEach { attrStr.addAttribute(.foregroundColor, value: UIColor.orange, range: $0) }
        return attrStr
    }
}
