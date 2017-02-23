//
//  MainViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/9/17.
//
//

import UIKit
import Firebase
import FirebaseStorage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts = NSMutableArray()
    var postDetails = ""
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        loadData()
        
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
            self.postsTableView.insertSubview(refreshControl, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Loads post database from Firebase
    func loadData() {
        FIRDatabase.database().reference().child("posts").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.posts.add(post.value)
                }
                self.postsTableView.reloadData()
            }
        })
    }
    
    // Slide to Refresh
    func refresh(_ refreshControl: UIRefreshControl) {
        posts.removeAllObjects()
        FIRDatabase.database().reference().child("posts").observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject] {
                for post in postsDictionary {
                    self.posts.add(post.value)
                }
                self.postsTableView.reloadData()
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
            performSegue(withIdentifier: "showDetails", sender: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }

    // Displays posts in postsTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        cell.titleLabel.text = post["title"] as? String
        cell.priceLabel.text = post["price"] as? String
        if let imageName = post["image"] as? String {
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in if error == nil {
                let image = UIImage(data: data!)
                UIView.animate(withDuration: 0.4, animations: {
                    cell.titleLabel.alpha = 1
                    cell.postImageView.alpha = 1
                    cell.priceLabel.alpha = 1
                cell.postImageView.image = image
                })
            } else {
                print("Error occured during image download: \(error?.localizedDescription)")
                }
            })
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.postsTableView.indexPathForSelectedRow {
                let post = posts[indexPath.row] as! [String: AnyObject]
                let postDetails = post["postID"] as? String
                let controller = segue.destination as! PostDetailsViewController
                controller.postDetails = postDetails
            }
        }
    }
}
