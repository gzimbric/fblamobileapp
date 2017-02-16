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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return self.posts.count
    }

    // Displays posts in postsTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]
        cell.titleLabel.text = post["title"] as? String
        cell.priceLabel.text = post["price"] as? String
        cell.conditionLabel.text = post["rating"] as? String
        cell.contentTextView.text = post["description"] as? String
        cell.userLabel.text = post["username"] as? String
        if let imageName = post["image"] as? String {
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion: { (data, error) -> Void in if error == nil {
                let image = UIImage(data: data!)
                cell.titleLabel.alpha = 0
                cell.contentTextView.alpha = 0
                cell.postImageView.alpha = 0
                cell.conditionLabel.alpha = 0
                cell.priceLabel.alpha = 0
                cell.condLabel.alpha = 0
                UIView.animate(withDuration: 0.4, animations: {
                    cell.titleLabel.alpha = 1
                    cell.contentTextView.alpha = 1
                    cell.postImageView.alpha = 1
                    cell.conditionLabel.alpha = 1
                    cell.priceLabel.alpha = 1
                    cell.condLabel.alpha = 1
                cell.postImageView.image = image
                })
            } else {
                print("Error occured during image download: \(error?.localizedDescription)")
                }
            })
        }
        return cell
    }
    
    

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.postsTableView.indexPathForSelectedRow {
                let post = posts[indexPath.row] as! [String: AnyObject]
                let shoeSize = post["price"] as? String
                let controller = (segue.destination as!
                    UINavigationController).topViewController as! DetailsViewController
                controller.detailItem = shoeSize
            }
        }
    }
    *\
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
 
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
 *\
 }*/
}
