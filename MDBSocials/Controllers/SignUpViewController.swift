//
//  SignUpViewController.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar & Max Miranda
//  Copyright © 2017 Vidya Ravikumar & Max Miranda. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var signUpTitle: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var signupButton: UIButton!
    
    var addAPhotoButton : UIButton!
    var profileImageView: UIImageView!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user { //need to check that this is functional first
                // User is signed in. Show home screen
               // self.performSegue(withIdentifier: "toFeedFromSignup", sender: self)
            }
        }

        // Do any additional setup after loading the view.
        setupTitle()
        setupTextFields()
        setupProfileImageView()
        setupButtons()
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.isUserInteractionEnabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTitle() {
        signUpTitle = UILabel(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width - 20, height: 0.3 * UIScreen.main.bounds.height))
        signUpTitle.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight(rawValue: 3))
        signUpTitle.adjustsFontSizeToFitWidth = true
        signUpTitle.textAlignment = .center
        signUpTitle.text = "Sign Up"
        signUpTitle.font = UIFont(name:"Hiragino Sans", size: 40)
        view.addSubview(signUpTitle)
    }
    
    func setupTextFields() {
        nameTextField = UITextField(frame: CGRect(x: 30, y: 0.3 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 60, height: 50))
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.placeholder = "  Name"
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 5.0
        nameTextField.layer.masksToBounds = true
        nameTextField.textColor = UIColor.black
        self.view.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 30, y: 0.4 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 60, height: 50))
        emailTextField.adjustsFontSizeToFitWidth = true
        emailTextField.placeholder = "  Email"
        emailTextField.layoutIfNeeded()
        emailTextField.layer.cornerRadius = 5.0
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.black
        self.view.addSubview(emailTextField)
        
        usernameTextField = UITextField(frame: CGRect(x: 30, y: 0.5 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 60, height: 50))
        usernameTextField.adjustsFontSizeToFitWidth = true
        usernameTextField.placeholder = "  Username"
        usernameTextField.layer.cornerRadius = 5.0
        usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.masksToBounds = true
        usernameTextField.textColor = UIColor.black
        self.view.addSubview(usernameTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 30, y: 0.6 * UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 60, height: 50))
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.placeholder = "  Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.black
        passwordTextField.isSecureTextEntry = true
        self.view.addSubview(passwordTextField)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupButtons() {
        
        signupButton = UIButton(frame: CGRect(x: 10, y: 0.8 * view.frame.height, width: 0.6 * view.frame.width - 20, height: 50))
        signupButton.center = CGPoint(x: view.frame.width/2, y: 0.8 * view.frame.height)
        signupButton.layoutIfNeeded()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.blue, for: .normal)
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.cornerRadius = 3.0
        signupButton.layer.borderColor = UIColor.blue.cgColor
        signupButton.layer.masksToBounds = true
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
        self.view.addSubview(signupButton)
    }
    

    @objc func signupButtonClicked() {
        print("signup button clicked")
        view.isUserInteractionEnabled = false
        let name = nameTextField.text!
        let username = usernameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        var profileImageData : Data? = nil
        if profileImageView.image != nil {
            profileImageData = UIImageJPEGRepresentation(profileImageView.image!, 0.1)
        }
        UserAuthHelper.createUser(name: name, username: username, email: email, password: password, imageData: profileImageData, view: self, withBlock: { (String) in
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.nameTextField.text = ""
        })
    }

    
    @objc func goBackButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    func setupProfileImageView() {
        profileImageView = UIImageView(frame: CGRect(x: 20, y: 200, width: UIScreen.main.bounds.width - 40, height: 75))
        addAPhotoButton = UIButton(frame: profileImageView.frame)
        addAPhotoButton.setTitle("Add a Photo!", for: .normal)
        addAPhotoButton.setTitleColor(UIColor.blue, for: .normal)
        addAPhotoButton.addTarget(self, action: #selector(photoAdd), for: .touchUpInside)
        view.addSubview(profileImageView)
        view.addSubview(addAPhotoButton)
    }
    
    @objc func photoAdd(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.pickImage()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(picker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func pickImage() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
}
extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        addAPhotoButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = chosenImage // this is not actually helping to display the image
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    


