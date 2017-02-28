//
//  PostDetailsTableViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/27/17.
//  Copyright © 2017 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class PostDetailsTableViewController: UITableViewController {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var postDetails: String?
    var posts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Loads post information from database to View Controller
        FIRDatabase.database().reference().child("posts").child(postDetails!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.title = dictionary["title"] as? String
                self.priceLabel.text = dictionary["price"] as? String
                self.ratingLabel.text = dictionary["rating"] as? String
                self.usernameLabel.text = dictionary["username"] as? String
                self.detailsTextView.text = dictionary["description"] as? String
                if let imageName = dictionary["image"] as? String {
                    FIRStorage.storage().reference().child("images/\(imageName)").downloadURL(completion: {(url, error) in
                        guard let url = url else {
                            return
                        }
                        // Display post with animation
                        self.postImageView.alpha = 0
                        UIView.animate(withDuration: 0.4, animations: {
                            self.postImageView.alpha = 1
                            let resource = ImageResource(downloadURL: url, cacheKey: imageName)
                            let processor = RoundCornerImageProcessor(cornerRadius: 40)
                            self.postImageView.kf.indicatorType = .activity
                            self.postImageView.kf.setImage(with: resource, options: [.processor(processor)])
                        })
                    })
                }
            }
        })

        loadData()
    }
    
    // Send postID over segue to CommentViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addComment" {
            let commentDetails = self.postDetails
            let controller = segue.destination as! CommentViewController
            controller.commentDetails = commentDetails
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }
    
    func loadData() {
        FIRDatabase.database().reference().child("posts").child(postDetails!).child("comments").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.posts.add(post.value)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    // Displays posts in postsTableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        cell.selectionStyle = .none
        cell.commentLabel.text = post["comment"] as? String
        return cell
    }
}
