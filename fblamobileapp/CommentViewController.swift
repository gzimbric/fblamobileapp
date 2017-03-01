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
    let timestamp = Date().iso8601

    override func viewDidLoad() {
        super.viewDidLoad()
        // Displays username of logged in user
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.usernameLabel.text = dictionary["username"] as? String
            }
        })
        
        // ViewController styling
        self.commentTextView.layer.cornerRadius = 5
        self.commentTextView.alpha = 0.70

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sends comment data to Firebase
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

// Timestamp
extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
