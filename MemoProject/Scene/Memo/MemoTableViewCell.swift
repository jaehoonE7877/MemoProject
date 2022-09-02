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
        $0.font = .systemFont(ofSize: 14)
    }
    
    let contentsLabel = UILabel().then {
        $0.textColor = Constants.BaseColor.subText
        $0.font = .systemFont(ofSize: 14)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [dateLabel, contentsLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureCell() {
        [titleLabel, stackView].forEach { contentView.addSubview($0) }
    }
    
    override func setCellConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView).offset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).offset(16)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
}
