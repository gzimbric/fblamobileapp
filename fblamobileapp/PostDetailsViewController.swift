//
//  PostDetailsViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/21/17.
// 
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class PostDetailsViewController: UIViewController {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var postDetails: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
