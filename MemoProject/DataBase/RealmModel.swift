//
//  RealmModel.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import Foundation
import RealmSwift

class UserMemo: Object {
    // title, content, date, isFixed, objectId
    @Persisted var memoTitle: String
    @Persisted var memoContents: String?
    @Persisted var memoDate: Date
    @Persisted var isFixed: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(memoTitle: String, memoContents: String?, memoDate: Date, isFixed: Bool) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContents = memoContents
        self.memoDate = memoDate
        self.isFixed = false
    }
}
