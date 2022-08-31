//
//  BaseView.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import UIKit

import SnapKit
import Then
class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
            super.init(coder: coder)
            configureUI()
            setConstraints()
        }
    
    func configureUI() { }
    
    func setConstraints() { }
    
}

