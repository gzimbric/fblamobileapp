//
//  PostViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/9/17.
//  Copyright © 2017 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postcomplete(_ sender: Any) {
        
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if let title = titleTextField.text {
                if let price = priceTextField.text {
                    if let rating = ratingTextField.text {
                        if let description = descriptionTextView.text {
                            let postObject: Dictionary<String, Any> = [
                                "uid": uid,
                                "title": title,
                                "price": price,
                                "rating": rating,
                                "description": description
                            ]
                            
                            FIRDatabase.database().reference().child("posts").childByAutoId().setValue(postObject)
                            
                            let alert = UIAlertController(title: "Success", message: "Your post was successfully created.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            print("Successfully Posted.")
                        }
                    }
                }
            }
        }
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
