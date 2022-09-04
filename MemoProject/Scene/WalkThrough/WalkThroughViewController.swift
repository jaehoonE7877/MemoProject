//
//  WalkThroughViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import UIKit

class WalkThroughViewController: BaseViewController {
    
    var mainView = WalkThroughView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mainButton.addTarget(self, action: #selector(moveToMemo), for: .touchUpInside)
    }
    
    @objc func moveToMemo(){
        
        UserDefaults.standard.set(true, forKey: "isFirst")
        
        self.dismiss(animated: true)
    }
    
}
