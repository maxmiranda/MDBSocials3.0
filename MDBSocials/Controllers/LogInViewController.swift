//
//  ViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/21/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LogInViewController: UIViewController {

    var appImage: UIImage!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user { //need to check that this is functional first
                // User is signed in. Show home screen
                self.performSegue(withIdentifier: "toFeedFromLogin", sender: self)
            } else {
                // No User is signed in. Show user the login screen
                for view in self.view.subviews{
                    view.removeFromSuperview()
                }
                self.setupTitle()
                self.setupTextFields()
                self.setupButtons()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.isUserInteractionEnabled = true
    }

    func setupTitle() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        appImage = UIImage(named: "mdbsocials")
        let appImageView = UIImageView(image: appImage)
        appImageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        appImageView.center = CGPoint(x: view.frame.width/2, y: 200)
        appImageView.contentMode = .scaleAspectFit
        view.addSubview(appImageView)
    }
    
    func setupTextFields() {
        emailTextField = UITextField(frame: CGRect(x: 10, y: 0.4 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 50))
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.placeholder = " Email"
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 3.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.black
        self.view.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 10, y: 0.5 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 50))
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.placeholder = " Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 3.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.black
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
    }
    
    func setupButtons() {
        loginButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0.6 * UIScreen.main.bounds.width - 20, height: 50))
        loginButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 0.7 * UIScreen.main.bounds.height)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(UIColor.blue, for: .normal)
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.cornerRadius = 3.0
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.layer.masksToBounds = true
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        signupButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0.3 * UIScreen.main.bounds.width - 20, height: 40))
        signupButton.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 0.77 * UIScreen.main.bounds.height)
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.black, for: .normal)
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        self.view.addSubview(signupButton)
    }
    
    @objc func loginButtonClicked() {
        view.isUserInteractionEnabled = false
        let email = emailTextField.text!
        let password = passwordTextField.text!
        emailTextField.text = ""
        passwordTextField.text = ""
        UserAuthHelper.logIn(email: email, password: password, view: self, withBlock: {(user) in
        })
        // if we're still here and logIn wasn't triggered
        /*let alert = UIAlertController(title: "Error", message: "This username and password did not match a current user.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)*/
    }
    
    @objc func signupButtonClicked() {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard(){
        view.endEditing(true)
    }

}

