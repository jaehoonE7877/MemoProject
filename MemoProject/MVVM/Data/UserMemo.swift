//
//  RealmModel.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import Foundation
import RealmSwift

class UserMemo: Object {
    
    @Persisted var title: String
    @Persisted var contents: String?
    @Persisted var writtenDate: Date
    @Persisted var isFixed: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var detailMemo: List<DetailMemo>
    
    convenience init(title: String, contents: String?, writtenDate: Date, isFixed: Bool) {
        self.init()
        self.title = title
        self.contents = contents
        self.writtenDate = writtenDate
        self.isFixed = false
    }
}

class DetailMemo: Object {
    @Persisted var content: String
    @Persisted var date: Date
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(content: String, date: Date) {
        self.init()
        self.content = content
        self.date = date
    }
}
