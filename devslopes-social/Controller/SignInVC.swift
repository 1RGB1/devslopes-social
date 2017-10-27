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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: FancyField!
    @IBOutlet weak var passwordTxtField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Ahmad: Go to feed view controller")
            performSegue(withIdentifier: "FeedSegue", sender: nil)
        }
    }
    
    @IBAction func dismissKeyboardBtnPressed(_ sender: Any) {
        view.endEditing(true)
    }
    
    func showAlertWith(title: String, message: String) {
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Ahmad: Data saved to Keychain: \(keychainResult)")
        performSegue(withIdentifier: "FeedSegue", sender: nil)
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        // Authenticate with Facebook
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                
                print("Ahmad: Unable to authenticate with Facebook - \(String(describing: error?.localizedDescription))")
                self.showAlertWith(title: "Facebook Failed", message: "Unable to authenticate with Facebook")
                
            } else if result?.isCancelled == true {
                
                print("Ahmad: User cancelled Facebook authentication")
                self.showAlertWith(title: "Facebbok authentication", message: "User cancelled Facebook authentication")
                
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
                self.showAlertWith(title: "Firebase Failed", message: "Unable to authenticate with Firebase")
                
            } else {
                print("Ahmad: Successfully authenticated with Firebase")
                
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        }
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        
        // Authenticate with Email
        if let email = emailTxtField.text, let pass = passwordTxtField.text {
            
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                
                if error == nil {
                    print("Ahmad: Successfully authenticated with Firebase using email")
                    
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                } else {
                    
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        
                        if error != nil {
                            
                            print("Ahmad: Unable to authenticated with Firebase using email")
                            self.showAlertWith(title: "Creating Failed", message: "User already exists")
                            
                        } else {
                            print("Ahmad: Successfully created user in Firebase using email")
                            
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
}

