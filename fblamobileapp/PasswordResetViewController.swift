//
//  PasswordResetViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/8/17.
//
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordResetViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tap to dismiss Keyboard Gesture Recognizer
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PasswordResetViewController.dismissKeyboard)))
        
        // ViewController Styling
        self.emailTextField.alpha = 0.70
        self.resetButton.layer.cornerRadius = 5
        self.resetButton.alpha = 0.70
    }
    
    // Tap to Dismiss Keyboard
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
    }
    
    // Sends email to server for password reset
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success"
                    message = "A password reset link has been sent to your email."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
