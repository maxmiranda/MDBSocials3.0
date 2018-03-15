
//
//  MainTabBarController.swift
//  MDBSocials
//
//  Created by Max Miranda on 3/2/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var nav : UINavigationItem!
    var postSelected : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav = navigationItem
        let tabOne = FeedViewController()
        let image1 = UIImage(named: "Feed")
        tabOne.tabBarItem = UITabBarItem(title: "Feed", image: image1, tag: 0)
        let tabTwo = MyEventsViewController()
        let image2 = UIImage(named: "MyEvents")
        tabTwo.tabBarItem = UITabBarItem(title: "My Events", image: image2, tag: 1)
        self.viewControllers = [tabOne, tabTwo]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            let nav = segue.destination as! UINavigationController
            let dvc = nav.topViewController as! DetailViewController
            dvc.post = postSelected
        }
    }

}
