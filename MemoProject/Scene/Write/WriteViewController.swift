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
        $0.font = .boldSystemFont(ofSize: 16)
        $0.delegate = self
    }
    
    let repository = UserMemoRepository()
    var memoTitle: String?
    var memoContents: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
    }
    
    override func configure() {
        view.addSubview(textView)
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setNavi(){
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    //UiActivityViewController
    @objc func shareButtonTapped(){
        let activityItems: [Any] = ["메모를 공유해보세요!"]
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    //realm
    @objc func saveButtonTapped(){
        
        if let memoTitle = memoTitle, let memoContents = memoContents {
            let userMemo = UserMemo(memoTitle: memoTitle, memoContents: memoContents, memoDate: Date(), isFixed: false)
            repository.addMemo(item: userMemo)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    
}

extension WriteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let currentText = textView.text else { return true }
        
        let textArray = currentText.components(separatedBy: "\n")
        
        memoTitle = String(textArray[0])
        memoContents = textArray.filter{ $0 != textArray[0] }.joined(separator: "\n")
        
        return true
    }
    
}
