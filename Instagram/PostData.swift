//
//  PostData.swift
//  Instagram
//
//  Created by 溝越啓介 on 2018/12/23.
//  Copyright © 2018 Keisuke Mizogoshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    var id: String?             // 投稿のID
    var image: UIImage?         // 画像（UIImageに変換済み）
    var imageString: String?    // 画像（Base64のまま）
    var name: String?           // 投稿者名
    var caption: String?        // キャプション
    var date: Date?             // 日付
    var likes: [String] = []    // 「いいね」をした人のID配列
    var isLiked: Bool = false   // 自分が「いいね」をしたかどうかのフラグ
    var comments: [String] = [] // この投稿に対するコメントの配列
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let allcomment = valueDictionary["comments"] as? [String]{
            self.comments = allcomment
        }
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
    }
}
