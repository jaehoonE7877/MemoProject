//
//  WriteViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/03.
//

import UIKit

class WriteViewController: BaseViewController{
    
    lazy var textView = UITextView().then {
        $0.textColor = Constants.BaseColor.text
        $0.delegate = self
    }
    
    let repository = UserMemoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
    }
    
    override func configure() {
        view.addSubview(textView)
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavi(){
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        navigationItem.rightBarButtonItems = [shareButton, saveButton]
    }
    //UiActivityViewController
    @objc func shareButtonTapped(){
        
    }
    //realm
    @objc func saveButtonTapped(){
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        <#code#>
    }
    
}

extension WriteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let currentText = textView.text else { return true }
        
        if text == "\n" {
            let userMemo = UserMemo(memoTitle: currentText, memoContents: nil, memoDate: Date(), isFixed: false)
            repository.addMemo(item: userMemo)
        } else {
            
        }
        
    }
    
}

