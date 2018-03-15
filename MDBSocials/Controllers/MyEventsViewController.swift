//
//  MyEventsViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 3/2/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import PromiseKit

class MyEventsViewController: UIViewController, UITabBarControllerDelegate {

    var eventsTableView: UITableView!
    var mainTabBarVC : MainTabBarController!
    var myEventsLabel : UILabel!
    var postsInterested : [Post]! = []
    var currentUser : SocialsUser!
    var postSelected : Post!
    
    override func viewWillAppear(_ animated: Bool) {
        loadAllEvents()
        setupNavBar()
    }
    override func viewDidLoad() {
        mainTabBarVC = tabBarController as! MainTabBarController
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadAllEvents), name: NSNotification.Name(rawValue: "newPost"), object: nil)
        loadLayout()
        setupNavBar()
    }
    
    func setupNavBar() {
        myEventsLabel = UILabel(frame: CGRect(x: view.frame.width/4, y: 0, width: view.frame.width/2, height: 40))
        myEventsLabel.text = "My Events"
        myEventsLabel.font = UIFont(name: "Lato-Regular", size: 26)
        myEventsLabel.textAlignment = .center
        view.addSubview(myEventsLabel)
        mainTabBarVC.nav.titleView = myEventsLabel;
        print("didAppear")
        mainTabBarVC.nav.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func loadLayout() {
        eventsTableView = UITableView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.minY, width: view.frame.width, height: view.frame.height))
        eventsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        eventsTableView.delegate = self as! UITableViewDelegate
        eventsTableView.dataSource = self as! UITableViewDataSource
        eventsTableView.rowHeight = 200
        view.addSubview(eventsTableView)
    }
    override func viewWillDisappear(_ animated: Bool) {
        myEventsLabel.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadAllEvents() {
        if let currUser = Auth.auth().currentUser {
            let uid = currUser.uid
            firstly {
                return RestAPIClient.fetchUser(id: uid)
            }.done { currentUser in
                firstly {
                    return RestAPIClient.fetchPosts()
                }.done { posts in
                    self.postsInterested.removeAll()
                    if currentUser.stringsPostsInterested != nil {
                        for post in posts {
                            if (currentUser.stringsPostsInterested?.contains(post.id!))! {
                                self.postsInterested.append(post)
                            }
                        }
                    self.eventsTableView.reloadData()
                    }
                }
            }
        }
    }

}

extension MyEventsViewController: UITableViewDataSource, UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsInterested.count
    }
    
    // Setting up cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PostTableViewCell
        let postInCell = postsInterested[indexPath.row]
        cell.postEventName.text = postInCell.text
        cell.postMemberName.text = postInCell.poster
        cell.postNumberInterested.text = "\(postInCell.numInterested!) interested"
        
        firstly {
            return Utils.getImage(withUrl: postInCell.imageUrl!)
        }.done { img in 
            cell.postImageView?.image = img
        }
        
        firstly {
            return RestAPIClient.fetchUser(id: postInCell.posterId!)
        }.done { user in
            firstly {
                return Utils.getImage(withUrl: user.imageUrl!)
            }.done { img in
                cell.posterImageView?.image = img
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabBarVC.postSelected = postsInterested[indexPath.row]
        mainTabBarVC.performSegue(withIdentifier: "showDetailView", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;
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

