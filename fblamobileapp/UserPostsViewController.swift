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
import Kingfisher

class UserPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userPostsTableView: UITableView!

    var userPosts = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userPostsTableView.delegate = self
        self.userPostsTableView.dataSource = self
        
        loadData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.userPostsTableView.insertSubview(refreshControl, at: 0)
        // Do any additional setup after loading the view.
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
                self.userPostsTableView.reloadData()
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
                self.userPostsTableView.reloadData()
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    // Do your job, when done:
                    refreshControl.endRefreshing()
                }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
