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
import Kingfisher

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var postsTableView: UITableView!
    
    var posts = NSMutableArray()
    var postDetails = ""
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate in viewDidLoad
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        // Variable cell size
        self.postsTableView.estimatedRowHeight = 457
        self.postsTableView.rowHeight = UITableViewAutomaticDimension

        // UIImage in Navigation
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView
        
        loadData()
        
        // Add refreshControl to ViewController
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
        return 1
    }
    
    // Preforms showDetails segue when cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showDetails", sender: self)
    }

    // Determines # of cells based on number of posts in database
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    // Displays posts in postsTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        cell.selectionStyle = .none
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

    // Send postID over segue to PostDetailsViewController
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
