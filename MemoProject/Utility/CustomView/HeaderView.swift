//
//  HeaderView.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/04.
//

import UIKit

class HeaderView: BaseView {
    
    let headerLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = Constants.BaseColor.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        self.addSubview(headerLabel)
    }
    
    override func setConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.snp.leading)
        }
    }
}
