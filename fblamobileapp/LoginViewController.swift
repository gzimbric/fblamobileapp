//
//  LoginViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/8/17.
//
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetAccountButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if FIRAuth.auth()?.currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(vc!, animated: false, completion: nil)
        }
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard)))

        self.emailTextField.borderStyle = UITextBorderStyle.roundedRect
        self.passwordTextField.borderStyle = UITextBorderStyle.roundedRect
        self.emailTextField.alpha = 0.70
        self.passwordTextField.alpha = 0.70
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.alpha = 0.70
        self.resetAccountButton.layer.cornerRadius = 5
        self.resetAccountButton.alpha = 0.70
        self.createAccountButton.layer.cornerRadius = 5
        self.createAccountButton.alpha = 0.70
        
    }
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Tells user that either there is nothing in the email text field
            let alertController = UIAlertController(title: "Error", message: "Make sure to enter an email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Console message for successful login
                    print("Login Successful.")
                    
                    //Go to the success screen if login works
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Gives user error from firebase itself
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
