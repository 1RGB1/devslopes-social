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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        // Authenticate with Facebook
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil {
                print("Ahmad: Unable to authenticate with Facebook - \(String(describing: error?.localizedDescription))")
            } else if result?.isCancelled == true {
                print("Ahmad: User cancelled Facebook authentication")
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
            } else {
                print("Ahmad: Successfully authenticated with Firebase")
            }
        }
    }
}

