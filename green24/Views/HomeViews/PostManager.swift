//
//  PostManager.swift
//  green24
//
//  Created by Karina Kazbekova on 16.03.23.
//

import Foundation
import Firebase

class postManager: ObservableObject{
    
    @State var post = postm
    func post(){
        
        let db = Firestore.firestore()
        db.collection("posts").addDocument(data: [
            "id": post.id,
            "postText": post.text,
            "createdDate": post.crea
        ]) { error in
            if let error = error {
                print("Ошибка при сохранении поста: \(error.localizedDescription)")
            } else {
                print("Пост успешно сохранен!")
            }
        }
    }
}
