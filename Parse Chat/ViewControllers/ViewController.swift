//
//  ViewController.swift
//  Parse Chat
//
//  Created by Allen Lozano on 11/21/18.
//  Copyright © 2018 Allen Lozano. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUp(_ sender: UIButton) {
        let newUser = PFUser()
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .actionSheet)

        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            // handle case of user logging out
        }
        // add the logout action to the alert controller
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // handle case of user canceling. Doing nothing will dismiss the view.
        }
        // add the cancel action to the alert controller
        alertController.addAction(cancelAction)
        
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        if let _text = usernameTextField.text, _text.isEmpty {
            print("Username field is empty")
        }
        if let _text1 = passwordTextField.text, _text1.isEmpty {
            print("Password field is empty")
        }
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "User sign up failed", message: error.localizedDescription, preferredStyle: .alert)

                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }

                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {
                }
            } else {
                print("User signed up successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "User login failed", message: error.localizedDescription, preferredStyle: .alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                self.present(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            } else {
                print("Welcome back (currentUser.username!)")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
}

