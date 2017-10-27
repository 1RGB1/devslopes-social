//
//  SignInVC.swift
//  devslopes-social
//
//  Created by Ahmad Ragab on 10/21/17.
//  Copyright © 2017 Ahmad Ragab. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: FancyField!
    @IBOutlet weak var passwordTxtField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissKeyboardBtnPressed(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        var alert: UIAlertController!
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        // Authenticate with Facebook
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Ahmad: Unable to authenticate with Facebook - \(String(describing: error?.localizedDescription))")
                
                alert = UIAlertController(title: "Facebook Failed", message: "Unable to authenticate with Facebook", preferredStyle: .alert)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            } else if result?.isCancelled == true {
                print("Ahmad: User cancelled Facebook authentication")
                
                alert = UIAlertController(title: "Facebbok authentication", message: "User cancelled Facebook authentication", preferredStyle: .alert)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Ahmad: Successfully authenticated with Facebook")
                
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        
        // Authenticate with Firebase
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if error != nil {
                print("Ahmad: Unable to authenticate with Firebase - \(String(describing: error?.localizedDescription))")
                
                let alert = UIAlertController(title: "Firebase Failed", message: "Unable to authenticate with Firebase", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                print("Ahmad: Successfully authenticated with Firebase")
            }
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        // Authenticate with Email
        if let email = emailTxtField.text, let pass = passwordTxtField.text {
            
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                
                if error == nil {
                    print("Ahmad: Successfully authenticated with Firebase using email")
                } else {
                    
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        
                        if error != nil {
                            print("Ahmad: Unable to authenticated with Firebase using email")
                            
                            let alert = UIAlertController(title: "Creating Failed", message: "User already exists", preferredStyle: .alert)
                            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            print("Ahmad: Successfully created user in Firebase using email")
                        }
                    })
                }
            })
        }
    }
}

