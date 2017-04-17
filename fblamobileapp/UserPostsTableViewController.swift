//
//  UserPostsTableViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 4/16/17.
//  Copyright © 2017 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class UserPostsTableViewController: UITableViewController {
    @IBOutlet weak var userLabel: UILabel!

    var userPosts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Shows username of user logged in
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.userLabel.text = dictionary["username"] as? String
            }
        })
        
        // Set delegate in viewDidLoad
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Variable cell size
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 457
        
        loadData()
        
        // Add refreshControl to ViewController
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loads post database from Firebase
    func loadData() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("userposts").child(uid!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.userPosts.add(post.value)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    // Slide to Refresh
    func refresh(_ refreshControl: UIRefreshControl) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        userPosts.removeAllObjects()
        FIRDatabase.database().reference().child("userposts").child(uid!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.userPosts.add(post.value)
                }
                self.tableView.reloadData()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Do your job, when done:
                    refreshControl.endRefreshing()
                }
            }
        })
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Determines # of cells based on number of posts in database
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userPosts.count
    }
    
    // Displays posts in postsTableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserPostsTableViewCell
        // Configure the cell...
        let post = self.userPosts[indexPath.row] as! [String: AnyObject]
        cell.titleLabel.text = post["title"] as? String
        cell.priceLabel.text = post["price"] as? String
        if let imageName = post["image"] as? String {
            FIRStorage.storage().reference().child("images/\(imageName)").downloadURL(completion: {(url, error) in
                guard let url = url else {
                    return
                }
                cell.postImageView.alpha = 0
                UIView.animate(withDuration: 0.4, animations: {
                    cell.postImageView.alpha = 1
                    let resource = ImageResource(downloadURL: url, cacheKey: imageName)
                    let processor = RoundCornerImageProcessor(cornerRadius: 40)
                    cell.postImageView.kf.indicatorType = .activity
                    cell.postImageView.kf.setImage(with: resource, options: [.processor(processor)])
                })
            })
        }
        return cell
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
