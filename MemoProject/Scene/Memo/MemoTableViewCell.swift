//
//  MemoTableViewCell.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import UIKit

class MemoTableViewCell: BaseTableViewCell {
    
    
    let titleLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.text
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.subText
        $0.font = .systemFont(ofSize: 13)
    }
    
    let contentsLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.subText
        $0.font = .systemFont(ofSize: 13)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [dateLabel, contentsLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 12
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    func setData(data: UserMemo){
        
        titleLabel.text = data.memoTitle
        dateLabel.text = getDataFormat(date: data.memoDate)
        if data.memoContents == "" {
            contentsLabel.text = "추가 텍스트 없음"
        } else {
            contentsLabel.text = data.memoContents
        }
    }
    
    func getDataFormat(date: Date) -> String {
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
    
    override func configureCell() {
        contentView.backgroundColor = .systemGray6
        [titleLabel, stackView].forEach { contentView.addSubview($0) }
    }
    
    override func setCellConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
        }
        
    }
}
