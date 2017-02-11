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
    
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        
        //Tells user that either there is nothing in the email text field
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Make sure to enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                
                if error == nil {
                    
                    //Console message for successful registration
                    print("Sign up successful.")
                    
                    // Store username
                    if let uid = FIRAuth.auth()?.currentUser?.uid {
                        let userRef = FIRDatabase.database().reference().child("users").child(uid)
                        let object = ["username": username]
                        userRef.setValue(object)
                        
                        //Go to the success screen if registration works
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                        self.present(vc!, animated: true, completion: nil)
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
