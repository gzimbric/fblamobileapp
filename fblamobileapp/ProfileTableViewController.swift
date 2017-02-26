//
//  ProfileTableViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/10/17.
// 
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Shows username of user logged in
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.userLabel.text = dictionary["username"] as? String
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Logs user out on button tap
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(vc!, animated: true, completion: nil)
        } catch {
            print("Error signing out user.")
        }
    }
}
