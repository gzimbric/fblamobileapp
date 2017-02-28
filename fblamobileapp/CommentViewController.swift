//
//  CommentViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/26/17.
//  Copyright © 2017 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CommentViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    var commentDetails: String?
    let commentID = UUID().uuidString
    let timestamp = FIRServerValue.timestamp()

    override func viewDidLoad() {
        super.viewDidLoad()
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usernameLabel.text = dictionary["username"] as? String
            }
        })
        
        self.commentTextView.layer.cornerRadius = 5
        self.commentTextView.alpha = 0.70

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func commentComplete(_ sender: Any) {
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                // Submits comment to Firebase Database
                FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDictionary = snapshot.value as? [String: AnyObject] {
                        for user in userDictionary {
                            if let username = user.value as? String {
                                if let comment = self.commentTextView.text {
                                    let postObject: Dictionary<String, Any> = [
                                                    "comment": comment,
                                                    "username" : username,
                                                    "timestamp" : self.timestamp,
                                                    "commentID": self.commentID,
                                                ]
                                                
                                                FIRDatabase.database().reference().child("posts").child(self.commentDetails!).child("comments").child(self.commentID).setValue(postObject)
                                    
                                                    let alert = UIAlertController(title: "Success", message: "Your comment was successfully added to the post.", preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                                                        self.present(vc!, animated: true, completion: nil)
                                                    }))
                                                    self.present(alert, animated: true, completion: {
                                                })
                                                print("Successfully posted Comment.")
                            }
                        }
                    }
                }
            })
        }
    }
}
