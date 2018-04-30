//
//  GoogleSignInViewController.swift
//  Optima Coding Challenge
//
//  Created by Sukhpreet  Deol on 8/30/17.
//  Copyright © 2017 Sukhpreet  Deol. All rights reserved.
//

import UIKit

class GoogleSignInViewController: UIViewController {
    
    @IBOutlet var signInView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    private let service = GTLRYouTubeService()
    private let signInButton = GIDSignInButton()
    private var trySignInSilently = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        signInView.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.topAnchor.constraint(equalTo: signInView.topAnchor, constant: 40).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: signInView.centerXAnchor, constant: 0).isActive = true
        signInButton.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension GoogleSignInViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        DispatchQueue.main.async {
            
            // If silent sign in failed on start then do not show error.
            // User can login by login button
            if self.trySignInSilently && error != nil {
                self.service.authorizer = nil
                self.trySignInSilently = false
                self.signInButton.alpha = 1.0
                self.activityIndicator.stopAnimating()
                return
            }
            
            // if error then show in alert
            if let error = error {
                self.service.authorizer = nil
                UIAlertController.present(on: self, "Authentication Error", message: error.localizedDescription)
                return
            }
            
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
            // set SearchCollectionViewController as navigatior root view controller
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchCollectionViewController") as? SearchCollectionViewController else { return }
            controller.service = self.service
            self.navigationController?.setViewControllers([controller], animated: true)
        }
    }
    
}

