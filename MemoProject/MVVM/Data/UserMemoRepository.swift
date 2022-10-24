//
//  UserMemoRepository.swift
//  MemoProject
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import Foundation
import RealmSwift

class UserMemoRepository {
    
    let localRealm = try! Realm()
    
    // 메모 하나 작성했을때(WriteVC에서 사용)
    func addMemo(item: UserMemo, detail: DetailMemo){
        do {
            try localRealm.write{
                localRealm.add(item)
                item.detailMemo.append(detail)
            }
        } catch {
            print(error)
        }
    }
    // tableView에 보여줄 때⭐️함수 변경해야됨 isFixed에 따라서 섹션분리
    func fetchMemo() -> Results<UserMemo>! {
        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "writtenDate", ascending: false)
    }
    //trailingSwipe에서
    func deleteMemo(item: UserMemo){
        do {
            try localRealm.write{
                localRealm.delete(item.detailMemo)
                localRealm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    //leadingSwipe에서
    func updateIsFixed(item: UserMemo){
        do {
            try localRealm.write{
                item.isFixed.toggle()
            }
        } catch {
            print(error)
        }
    }
    
    func fetchIsFixed() -> Bool{
        var cnt = 0
        localRealm.objects(UserMemo.self).forEach { item in
            if item.isFixed {
            cnt += 1
            }
        }
        return cnt > 0 ? true : false
    }
    
}
