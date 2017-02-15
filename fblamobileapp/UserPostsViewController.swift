//
//  UserPostsViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/14/17.
//
//

import UIKit
import Firebase
import FirebaseDatabase

class UserPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userPostsTableView: UITableView!

    var userPosts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userPostsTableView.delegate = self
        self.userPostsTableView.dataSource = self
        
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loads post database from Firebase
    func loadData() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("posts").child(uid!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.userPosts.add(post.value)
                }
                self.userPostsTableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // pass any object as parameter, i.e. the tapped row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userPosts.count
    }
    
    // Displays posts in postsTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! PostTableViewCell
        // Configure the cell...
        let post = self.userPosts[indexPath.row] as! [String: AnyObject]
        cell.titleLabel.text = post["title"] as? String
        cell.priceLabel.text = post["price"] as? String
        if let imageName = post["image"] as? String {
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in if error == nil {
                let image = UIImage(data: data!)
                cell.titleLabel.alpha = 0
                cell.contentTextView.alpha = 0
                cell.postImageView.alpha = 0
                UIView.animate(withDuration: 0.4, animations: {
                    cell.titleLabel.alpha = 1
                    cell.contentTextView.alpha = 1
                    cell.postImageView.alpha = 1
                })
            } else {
                print("Error occured during image download: \(error?.localizedDescription)")
                }
            })
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
