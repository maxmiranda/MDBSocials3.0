//
//  NewSocialViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/21/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
import PromiseKit
import CoreLocation
import LocationPicker

class NewSocialViewController: UIViewController {

    var newPostTitle : UILabel!
    var postTextField : UITextField!
    var postDescriptionField : UITextView!
    var datePicker: UIDatePicker!
    var newPostButton : UIButton!
    var exitButton : UIButton!
    
    var selectLocationButton: UIButton!
    var selectedLocation: CLLocationCoordinate2D!

    var addAPhotoButton : UIButton!
    var eventImageView: UIImageView!
    let picker = UIImagePickerController()

    var uid : String!
    var user : SocialsUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        if let currUser = Auth.auth().currentUser {
            uid = currUser.uid
            firstly {
                return RestAPIClient.fetchUser(id: uid)
            }.done { user1 in
                self.user = user1
            }
        }
    
        setupTitle()
        setupTextFields()
        setupButtons()
        setupEventImageView()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTitle() {
        newPostTitle = UILabel(frame: CGRect(x: 10, y: 25, width: UIScreen.main.bounds.width - 20, height: 0.3 * UIScreen.main.bounds.height))
        newPostTitle.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight(rawValue: 3))
        newPostTitle.adjustsFontSizeToFitWidth = true
        newPostTitle.textAlignment = .center
        newPostTitle.font = UIFont(name:"Hiragino Sans", size: 40)
        newPostTitle.text = "Create a New Post"
        view.addSubview(newPostTitle)
    }
    
    func setupTextFields() {
        let frameText = CGRect(x: 25, y: 290, width: view.frame.width - 50, height: 50)
        postTextField = UITextField(frame: frameText)
        postTextField.placeholder = "  Social Name"
        postTextField.layer.borderColor = UIColor.lightGray.cgColor
        postTextField.layer.borderWidth = 1.0
        postTextField.layer.cornerRadius = 5.0
        postTextField.textColor = UIColor.black
        view.addSubview(postTextField)

        let descriptionText = CGRect(x: 25, y: 360, width: view.frame.width - 50, height: 150)
        postDescriptionField = UITextView(frame: descriptionText)
        postDescriptionField.placeholder = "  Social Description"
        postDescriptionField.layer.cornerRadius = 5.0
        postDescriptionField.layer.borderColor = UIColor.lightGray.cgColor
        postDescriptionField.layer.borderWidth = 1.0
        postDescriptionField.textColor = UIColor.black
        view.addSubview(postDescriptionField)

        
        datePicker = UIDatePicker(frame: CGRect(x: 25, y: 545, width: view.frame.width - 50, height: 50))
        datePicker.datePickerMode = .dateAndTime
        view.addSubview(datePicker)
    }
    
    func setupButtons() {
        newPostButton = UIButton(frame: CGRect(x: 0, y: view.frame.height - 125, width:0.6 *  UIScreen.main.bounds.width - 20, height: 50))
        newPostButton.center = CGPoint(x: view.frame.width/2, y: 0.9 * view.frame.height)
        newPostButton.setTitle("Add Post", for: .normal)
        newPostButton.setTitleColor(UIColor.blue, for: .normal)
        newPostButton.layer.borderWidth = 2.0
        newPostButton.layer.cornerRadius = 3.0
        newPostButton.layer.borderColor = UIColor.blue.cgColor
        newPostButton.addTarget(self, action: #selector(addNewPost), for: .touchUpInside)
        view.addSubview(newPostButton)
        
        selectLocationButton = UIButton(frame: CGRect(x: 40, y: 80, width: view.frame.width/2 - 40, height: 100))
        selectLocationButton.center = CGPoint(x: view.frame.width/2, y:view.frame.height - 170)
        selectLocationButton.setTitle("Select Location", for: .normal)
        selectLocationButton.layer.cornerRadius = 10
        selectLocationButton.setTitleColor(.black, for: .normal)
        selectLocationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        view.addSubview(selectLocationButton)
        
        exitButton = UIButton(frame: CGRect(x: 40, y: 40, width: 40, height: 50))
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        exitButton.setTitleColor(UIColor.gray, for: .normal)
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    @objc func addNewPost(sender: UIButton!) {
        if postTextField.text != "" && postDescriptionField.text != "" && eventImageView.image != nil && selectedLocation != nil {
            let eventImageData = UIImageJPEGRepresentation(eventImageView.image!, 0.1)
            let date = Utils.createOverallDateString(date: datePicker.date)
            RestAPIClient.createNewPost(text: postTextField.text!, description: postDescriptionField.text!, date: date, location: selectedLocation, poster: user.name!, imageData: eventImageData!, posterId: uid)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields before adding a post.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func goBack(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupEventImageView() {
        eventImageView = UIImageView(frame: CGRect(x: 20, y: 200, width: UIScreen.main.bounds.width - 40, height: 75))
        addAPhotoButton = UIButton(frame: eventImageView.frame)
        addAPhotoButton.setTitle("Add a Photo!", for: .normal)
        addAPhotoButton.setTitleColor(UIColor.blue, for: .normal)
        addAPhotoButton.addTarget(self, action: #selector(photoAdd), for: .touchUpInside)
        view.addSubview(eventImageView)
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
        } else {
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
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func selectLocation() {
        let locationPicker = LocationPickerViewController()
        
        locationPicker.showCurrentLocationButton = true
        locationPicker.currentLocationButtonBackground = .blue
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .standard
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.resultRegionDistance = 500
        locationPicker.completion = { location in
            self.selectedLocation = location?.coordinate
        }
        
        present(locationPicker, animated: true) {
            print("Selecting location")
        }
    }
}
extension NewSocialViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [String : Any]){
        addAPhotoButton.removeFromSuperview()
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.image = chosenImage // this is not actually helping to display the image
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
