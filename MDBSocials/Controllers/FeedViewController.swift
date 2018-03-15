//
//  FeedViewController.swift
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

class FeedViewController: UIViewController, UITabBarControllerDelegate {

    var mainTabBarVC : MainTabBarController!
    var postTableView: UITableView!
    var posts: [Post] = []
    var auth = Auth.auth()
    var postsRef: DatabaseReference = Database.database().reference().child("Posts")
    var storage: StorageReference = Storage.storage().reference()
    var navBar: UINavigationBar!
    var postSelected : Post!
    
    override func viewWillAppear(_ animated: Bool) {
        loadAllPosts()
        setupNavBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadAllPosts), name: NSNotification.Name(rawValue: "newPost"), object: nil)
        mainTabBarVC = tabBarController as! MainTabBarController
        setupNavBar()
        setupTableView()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        edgesForExtendedLayout = []
        var feedLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        feedLabel.text = "Your Feed"
        feedLabel.textAlignment = .center
        view.addSubview(feedLabel)
        mainTabBarVC.nav.titleView = feedLabel;
        mainTabBarVC.nav.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        mainTabBarVC.nav.rightBarButtonItem = UIBarButtonItem(title: "Add Social", style: .plain, target: self, action: #selector(newSocialClicked))
    }
    
    @objc func logOut() {
        UserAuthHelper.logOut {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func newSocialClicked() {
        mainTabBarVC.performSegue(withIdentifier: "toNewSocial", sender: self)
    }
    
    func setupTableView() {
        edgesForExtendedLayout = []
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height - mainTabBarVC.tabBar.frame.size.height - 20)
        postTableView = UITableView(frame: frame)
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "post")
        postTableView.delegate = self
        postTableView.dataSource = self
        view.addSubview(postTableView)
    }
    @objc func loadAllPosts() {
        firstly {
            return RestAPIClient.fetchPosts()
        }.done { posts in
            var posts = posts.sorted(by: {$0.date! < $1.date!})
            var i = posts.count - 1
            while i >= 0 {
                if posts[i].date!.timeIntervalSinceNow < 0.0 {
                    posts.remove(at: i)
                }
                i = i-1
            }
            self.posts.removeAll()
            self.posts = posts
            self.postTableView.reloadData()
        }
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! PostTableViewCell
        let postInCell = posts[indexPath.row]
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! PostTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainTabBarVC.postSelected = posts[indexPath.row]
        mainTabBarVC.performSegue(withIdentifier: "showDetailView", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;
    }
    
}

