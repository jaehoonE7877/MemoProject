//
//  WalkThroughView.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import UIKit

class WalkThroughView: BaseView {
    
    let view = UIView().then {
        $0.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
    }
    
    let backgroundView = UIView().then {
        $0.backgroundColor = Constants.BaseColor.background
        $0.layer.cornerRadius = Constants.Design.cornerRadius
    }

    let topLabel = UILabel().then {
        $0.text = "처음오셨군요!\n환영합니다:)"
        $0.textColor = Constants.BaseColor.text
        $0.numberOfLines = 2
        $0.backgroundColor = .clear
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let bottomLabel = UILabel().then {
        $0.text = "당신만의 메모를 작성하고\n관리해보세요!"
        $0.textColor = Constants.BaseColor.text
        $0.numberOfLines = 2
        $0.backgroundColor = .clear
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    let mainButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.tintColor = Constants.BaseColor.text
        $0.backgroundColor = Constants.BaseColor.myYello
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = Constants.Design.cornerRadius
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        self.addSubview(view)
        view.addSubview(backgroundView)
        [topLabel, bottomLabel, mainButton].forEach { backgroundView.addSubview($0)}
    }
    
    override func setConstraints() {
        
        view.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(backgroundView.snp.width)
        }
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(28)
            make.leading.equalTo(backgroundView.snp.leading).offset(24)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(28)
            make.leading.equalTo(backgroundView.snp.leading).offset(24)
        }
        
        mainButton.snp.makeConstraints { make in
            make.top.equalTo(bottomLabel.snp.bottom).offset(28)
            make.leading.equalTo(backgroundView.snp.leading).offset(24)
            make.height.equalTo(56)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
    }
}
