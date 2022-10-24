//
//  WriteViewController.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/03.
//

import UIKit

final class WriteViewController: BaseViewController{
    
    lazy var textView = UITextView().then {
        $0.backgroundColor = Constants.BaseColor.background
        $0.textColor = .defaultTextColor
        $0.font = .boldSystemFont(ofSize: 16)
        $0.delegate = self
    }
    
    private let repository = UserMemoRepository()
    var memoTitle: String?
    var memoContents: String?
    var memoTask: UserMemo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        
        guard let memoTask = memoTask else { return }
        textView.text = "\(String(describing: memoTask.title))\n\(String(describing: memoTask.contents ?? ""))"
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        guard let memoTitle = memoTitle, let memoContents = memoContents else { return }
        let userMemo = UserMemo(title: memoTitle, contents: memoContents, writtenDate: Date(), isFixed: memoTask?.isFixed ?? false)
        let detailTask = DetailMemo(content: "List 연습해보자\(Int.random(in: 1...5))", date: Date())
        repository.addMemo(item: userMemo, detail: detailTask)
        
        guard let memoTask = memoTask else { return }
        if memoTask.contents == memoContents {
            return
        } else {
            repository.deleteMemo(item: memoTask)
        }
    }
    
    override func configure() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeRecognizer)
        
        view.addSubview(textView)
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setNavi(){
        naviBackground()
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left{
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

