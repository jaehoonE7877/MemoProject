//
//  HomeViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/10/18.
//

import UIKit

import RealmSwift

@available(iOS 14.0, *)
final class HomeViewController: BaseViewController {
    
    //MARK: Property, View
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var tasks: Results<UserMemo>! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let localRealm = try! Realm()
    
    var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>!
    
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
        
        cellRegisteration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            
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
        
    }
    
    private func getDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        if date > date.addingTimeInterval(-86400) {
            formatter.dateFormat = "a hh:mm"
        } else if date <= date.addingTimeInterval(-86400) && date > date.addingTimeInterval(-(86400 * 7)) {
            formatter.dateFormat = "EEEE"
        } else {
            formatter.dateFormat = "yyyy. MM. dd a hh:mm"
        }
        return formatter.string(from: date)
    }
    
    
}

@available(iOS 14.0, *)
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = tasks[indexPath.item]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        
        return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
}

enum DateType {
    case today
    case thisWeek
    case all
}

extension DateType {
    
    var format: String {
        switch self {
        case .today:
            return "a hh:mm"
        case .thisWeek:
            return "EEEE"
        case .all:
            return "yyyy. MM. dd a hh:mm"
        }
    }
    
    static func toString(_ date: Date, to dateFormat: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = dateFormat.format
        return dateFormatter.string(from: date)
    }
    
}
