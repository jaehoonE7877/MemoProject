//
//  BaseTableViewCell.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import UIKit

import SnapKit
import Then
class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        configureCell()
        setCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell() { }
    
    func setCellConstraints() { }
    
}
