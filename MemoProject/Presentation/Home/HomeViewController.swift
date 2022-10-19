//
//  HomeViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/10/18.
//

import UIKit

import RealmSwift

final class HomeViewController: BaseViewController {
    
    //MARK: Property, View
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout()).then {
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var tasks: Results<UserMemo>! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let localRealm = try! Realm()
        
    private var dataSource: UICollectionViewDiffableDataSource<Int, UserMemo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = localRealm.objects(UserMemo.self)
        
        configureCollectionView()
    }
    
    override func configure() {
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureCellLayout() -> UICollectionViewLayout {

        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        return layout
    }
    
    
    private func configureCollectionView() {
        
       let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>(handler: { cell, indexPath, itemIdentifier in
            
            var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.memoTitle
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            
            guard let memoContents = itemIdentifier.memoContents else { return }
            
           let dateString = self.getDateFormat(date: itemIdentifier.memoDate)
            content.secondaryText = "\(dateString) \(memoContents)"
            content.secondaryTextProperties.numberOfLines = 1
            content.prefersSideBySideTextAndSecondaryText = false
            content.secondaryTextProperties.font = .systemFont(ofSize: 13)
            
            cell.contentConfiguration = content
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        let list = Array(tasks)
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserMemo>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        self.dataSource.apply(snapshot)
        
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    
}

extension HomeViewController {
    
    private func getDateFormat(date: Date) -> String {
        
        var dateType: DateType = .all
        
        if Calendar.current.isDateInToday(date) {
            dateType = .today
        } else if Date.isDateInThisWeek(date) {
            dateType = .thisWeek
        } else {
            dateType = .all
        }
        
        return DateType.toString(date, to: dateType)
    }
    
}
