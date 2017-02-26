//
//  RegisterViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/8/17.
//
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tap to dismiss Keyboard Gesture Recognizer
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard)))
        
        // ViewController Styling
        self.emailTextField.alpha = 0.70
        self.passwordTextField.alpha = 0.70
        self.usernameTextField.alpha = 0.70
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.alpha = 0.70
    }
    
    // Tap to Dismiss Keyboard
    func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
    }
    
    // Create new user account
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        
        // Shows error if any field is empty
        if emailTextField.text == "" || self.usernameTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter info into all fields", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                
                if error == nil {
                    
                    // Console message for successful registration
                    print("Sign up successful.")
                    
                    // Create user in database
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let userRef = FIRDatabase.database().reference().child("users").child(uid)
                        let object = ["username": username]
                        userRef.setValue(object)
                        
                        // Show feed if registration is successful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                }
                // If error occurs, show UIAlertController from Firebase
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
