//
//  PasswordResetViewController.swift
//  fblamobileapp
//
//  Created by Gabe Zimbric on 2/8/17.
//  Copyright © 2017 Gabe Zimbric. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordResetViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oh No!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
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
                
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
