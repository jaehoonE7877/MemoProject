//
//  EditViewModel.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/10/25.
//

import Foundation

protocol EditMemoPresentable {
    var title: String { get }
    var content: String? { get }
}

struct EditMemoViewModel: EditMemoPresentable {
    var title: String
    var content: String?
}

protocol MemoViewDelegate {
    func onMemoItemAdded() -> ()
}


struct EditViewModel {
    
    var newMemoItem: String?
    let memo: [EditMemoPresentable] = []
    
    
    struct Input {
        let deleteMemo: Observable<Bool> = Observable(false)
        let pinMemo: Observable<Bool> = Observable(false)
    }
    
}

extension EditViewModel: MemoViewDelegate {
    
    func onMemoItemAdded() {
        
    }
    
    
}
