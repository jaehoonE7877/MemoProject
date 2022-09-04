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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(data: UserMemo){
        
        titleLabel.text = data.memoTitle
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko-KR")
        dateLabel.text = formatter.string(from: data.memoDate)
        contentsLabel.text = data.memoContents
    }
    
    override func configureCell() {
        contentView.backgroundColor = .systemGray6
        [titleLabel, dateLabel, contentsLabel].forEach { contentView.addSubview($0) }
    }
    
    override func setCellConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(12)
            make.leading.equalTo(contentView).offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.leading.equalTo(dateLabel.snp.trailing).offset(12)
            make.trailing.equalTo(contentView).offset(-4)
        }
    }
}
