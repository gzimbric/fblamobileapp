//
//  PostViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/9/17.
//
//

import UIKit
import Firebase
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    var imageFileName = ""
    
    let imagePicker = UIImagePickerController()
    
    let postID = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.descriptionTextView.layer.cornerRadius = 5
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboard)))
        
        self.titleTextField.borderStyle = UITextBorderStyle.roundedRect
        self.priceTextField.borderStyle = UITextBorderStyle.roundedRect
        self.ratingTextField.borderStyle = UITextBorderStyle.roundedRect
        self.titleTextField.alpha = 0.70
        self.priceTextField.alpha = 0.70
        self.ratingTextField.alpha = 0.70
        self.descriptionTextView.alpha = 0.70
        self.selectImageButton.alpha = 0.70
        self.selectImageButton.layer.cornerRadius = 5
    }
    
    // Enables tap to dismiss keyboard
    func dismissKeyboard() {
        titleTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        ratingTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Runs imagePicker when button is tapped
    @IBAction func selectImageTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Generating Random String for photo ID
    func RandomStringwithLength(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    // Upload image to server
    func uploadImage(image: UIImage) {
        let randomName = RandomStringwithLength(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let uploadRef = FIRStorage.storage().reference().child("images/\(randomName).jpeg")
        
        let uploadTask = uploadRef.put(imageData!, metadata: nil) {metadata, error in
            if error == nil {
                print("Image added to post successfully.")
                self.imageFileName = "\(randomName as String).jpeg"
            } else {
                print("Error adding image: \(error?.localizedDescription)")
            }
        }
    }
    
    // Dismisses imagePickerController if user cancels operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Runs when user cancels image pick operation
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Displays imagePickerController and runs uploadImage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Runs when user is picking image from library
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = pickedImage
            self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // Runs when 'Submit Post' button is tapped
    @IBAction func postComplete(_ sender: Any) {
        if (self.imageFileName != "") {
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            
            // Submits uiTextField values to Firebase Database
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDictionary = snapshot.value as? [String: AnyObject] {
                for user in userDictionary {
                    if let username = user.value as? String {
                        if let title = self.titleTextField.text {
                            if let price = self.priceTextField.text {
                                if let rating = self.ratingTextField.text {
                                    if let description = self.descriptionTextView.text {
                                        let postObject: Dictionary<String, Any> = [
                                            "uid": uid,
                                            "title": title,
                                            "price": price,
                                            "rating": rating,
                                            "description": description,
                                            "username" : username,
                                            "postID": self.postID,
                                            "image": self.imageFileName
                                        ]
                                        
                                        FIRDatabase.database().reference().child("posts").child(self.postID).setValue(postObject)
                                    }
                                }
                            }
                        }
                    }
                    }
                }
            })
            
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let userDictionary = snapshot.value as? [String: AnyObject] {
                    for user in userDictionary {
                        if let username = user.value as? String {
                            if let title = self.titleTextField.text {
                                if let price = self.priceTextField.text {
                                    if let rating = self.ratingTextField.text {
                                        if let description = self.descriptionTextView.text {
                                            let postObject: Dictionary<String, Any> = [
                                                "uid": uid,
                                                "title": title,
                                                "price": price,
                                                "rating": rating,
                                                "description": description,
                                                "username" : username,
                                                "postID": self.postID,
                                                "image": self.imageFileName
                                            ]
                                            
                                            FIRDatabase.database().reference().child("userposts").child(uid).child(self.postID).setValue(postObject)
                                            
                                            let alert = UIAlertController(title: "Success", message: "Your post was successfully created.", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                                                self.present(vc!, animated: true, completion: nil)
                                            }))
                                            self.present(alert, animated: true, completion: {
                                            })
                                            
                                            print("Successfully Posted to UserPosts.")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }
           // Displays message if iamge has not finished uploading to server
        else {
            let alert = UIAlertController(title: "Please Wait", message: "The image has not finished processing yet", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
