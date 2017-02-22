//
//  Comment.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/19/17.
//
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct Comment {
    var image: String!
    var postID: String!
    var description: String!
    var username: String!
    var price: String!
    var rating: String!
    var title: String!
    var ref: FIRDatabaseReference?
    var key: String!
    
    
    init(postID: String, image: String, description: String, username: String, title: String, rating: String, price: String, key: String = ""){
        
        self.description = description
        self.postID = postID
        self.username = username
        self.title = title
        self.rating = rating
        self.price = price
        self.image = image
        self.ref = FIRDatabase.database().reference()
        
        
    }
    
    init(snapshot: FIRDataSnapshot){
        guard let values = snapshot.value as? [String: Any] else {
            return
        }
        
        self.description = values["description"] as! String
        self.postID = values["postID"] as! String
        self.title = values["title"] as! String
        self.rating = values["rating"] as! String
        self.price = values["price"] as! String
        self.image = values["image"] as! String
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: AnyObject] {
        
   
        return ["image": image as AnyObject, "description": description as AnyObject, "username": username as AnyObject, "postId": postID as AnyObject, "title": title as AnyObject, "rating": rating as AnyObject, "price": price as AnyObject]
    }
    
    
}
