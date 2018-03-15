//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/21/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit
import PromiseKit

class DetailViewController: UIViewController {

    var post : Post!
    var memberName : UILabel!
    var eventDate : UILabel!
    var eventDescription : UILabel!
    var locationWeather : UILabel!
    var numInterested : UIButton!
    var interestedButton : UIButton!
    var exitButton: UIButton!
    var interestedClicked = false
    var getDirectionsButton: UIButton!

    var currentUser: SocialsUser?
    var cUserId : String!
    
    var weather : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let currUser = Auth.auth().currentUser {
            cUserId = currUser.uid
        }
        setupImage()
        setupMap()
        setupLabels()
        setupButtons()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        queryWeather()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMap() {
        var mapView = MKMapView(frame: CGRect(x: view.frame.width/2 + 10, y: view.frame.height/2 - 60, width: view.frame.width/2 - 20, height: view.frame.height/2 - 70))
        mapView.mapType = .standard
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.001, 0.001)), animated: true)
        view.addSubview(mapView)
        
        getDirectionsButton = UIButton(frame: CGRect(x: view.frame.width/2 + 10, y: view.frame.height - 130, width: view.frame.width/2 - 20, height: 30))
        getDirectionsButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        getDirectionsButton.layer.cornerRadius = 10
        getDirectionsButton.setTitle("Get Directions", for: .normal)
        getDirectionsButton.setTitleColor(.blue, for: .normal)
        getDirectionsButton.backgroundColor = .white
        getDirectionsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        view.addSubview(getDirectionsButton)
    }
    
    func setupImage() {
        let imageURL = URL(string: post.imageUrl!)
        let data = try? Data(contentsOf: imageURL!)
        DispatchQueue.main.async {
            if let retrievedImage = data {
                let backgroundImage = UIImage(data: retrievedImage)
                let imageView = UIImageView(image: backgroundImage)
                imageView.frame = CGRect(x: 40, y: 80, width: 300, height: 300)
                imageView.contentMode = .scaleAspectFit
                self.view.addSubview(imageView)
            }
        }
    }
    func setupLabels() {
        memberName = UILabel(frame: CGRect(x:40,y:80,width: view.frame.width, height:50))
        memberName.text = post.text
        memberName.font = UIFont(name: "Helvetica", size: 24)
        view.addSubview(memberName)
        
        eventDate = UILabel(frame: CGRect(x: 40,y:380,width:view.frame.width/2, height:40))
        eventDate.text = "Date: \(post.dateString!)"
        eventDate.font = UIFont(name: "Helvetica", size: 16)
        view.addSubview(eventDate)
        
        locationWeather = UILabel(frame: CGRect(x: 40,y:410,width:view.frame.width/2, height:40))
        locationWeather.font = UIFont(name: "Helvetica", size: 16)
        view.addSubview(locationWeather)
        
        //Open Settings on Mike's iPhone and navigate to General -> Device Management, then select your Developer App certificate to trust it.
        eventDescription = UILabel(frame: CGRect(x: 40,y:430,width:view.frame.width/2 - 80, height: view.frame.width * 0.3))
        eventDescription.numberOfLines = 3
        eventDescription.text = "Description: \(post.description!)"
        eventDescription.font = UIFont(name: "Helvetica", size: 18)
        view.addSubview(eventDescription)
    }
    
    func setupButtons() {
        numInterested = UIButton(frame: CGRect(x: 30,y:550,width:view.frame.width/2 - 40, height:40))
        numInterested.setTitle("\(post.numInterested!) interested", for: .normal)
        numInterested.addTarget(self, action: #selector(toWhosInterested), for: .touchUpInside)
        numInterested.backgroundColor = .red
        view.addSubview(numInterested)
        
        interestedButton = UIButton(frame: CGRect(x: 25, y: view.frame.height - 100, width: UIScreen.main.bounds.width - 50, height: 50))
        interestedButton.backgroundColor = .green
        interestedButton.setTitle("Interested", for: .normal)
        interestedButton.titleLabel?.textColor = .white
        interestedButton.addTarget(self, action: #selector(interestedClick), for: .touchUpInside)

        view.addSubview(interestedButton)
        
        exitButton = UIButton(frame: CGRect(x: 40, y: 40, width: 40, height: 40))
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        exitButton.setTitleColor(UIColor.gray, for: .normal)
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    @objc func goBack(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toWhosInterested(){
        performSegue(withIdentifier: "toWhosInterested", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWhosInterested" {
            let whosInterestedController = segue.destination as! WhosInterestedController
            whosInterestedController.post = post
        }
    }
    @objc func getDirections(){
        let urlString = "http://maps.apple.com/?saddr=&daddr=\(post.latitude!),\(post.longitude!)"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!)
    }
    
    @objc func interestedClick(sender: UIButton!) {
        if !interestedClicked && !post.membersInterested.contains(cUserId) {
            numInterested.setTitle("\(post.numInterested! + 1) interested", for: .normal)
            FirebaseAPIClient.incrementPostInterested(postId: post.id!, cUserId: cUserId)
            interestedButton.backgroundColor = UIColor(red: 6/255, green: 112/255, blue: 31/255, alpha: 1.0)
        } else {
            let alert = UIAlertController(title: "", message: "You already said you were interested in this event :)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        interestedClicked = true
    }
    
    func queryWeather(){
        firstly {
            return DarkSkyAPI.getCurrentWeather(latitude: post.latitude!, longitude: post.longitude!)
        }.done { weather in
            self.locationWeather.text! = "Weather: \(weather)°"
        }
    }
}

