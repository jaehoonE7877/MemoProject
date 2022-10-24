//
//  EditViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/10/24.
//

import UIKit

final class EditViewController: BaseViewController {
    
    lazy var textView = UITextView().then {
        $0.backgroundColor = Constants.BaseColor.background
        $0.textColor = .defaultTextColor
        $0.font = .boldSystemFont(ofSize: 16)
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension EditViewController: UITextViewDelegate {
    
    
}

