//
//  WhosInterestedControllerViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 3/3/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import PromiseKit

class WhosInterestedController: UIViewController {
    var post : Post!
    var userIDArray: [String]?
    var usersArray: [SocialsUser] = []
    var tableView : UITableView!
    var nav : UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDArray = post.membersInterested
        setupTableView()
    }
    
    func setupTableView(){
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "user")
        view.addSubview(tableView)
    }
    
    func setupNavBar() {
        nav = navigationItem
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.title = "Interested Users"
    }
    
    func getUsers(){
        if userIDArray != nil {
            for id in userIDArray!{
                if id != "Hi" {
                    firstly {
                        return RestAPIClient.fetchUser(id: id)
                    }.done { user in
                        self.usersArray.append(user)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUsers()
        setupNavBar()
    }
}

extension WhosInterestedController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! PostTableViewCell
        let user = usersArray[indexPath.row]
        cell.awakeFromNib()
        cell.postMemberName.text = user.name!
        cell.postEventName.text = user.username!
        firstly {
            return Utils.getImage(withUrl: user.imageUrl!)
        }.done { picture in
            cell.posterImageView.image = picture
        }

        cell.isUserInteractionEnabled = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
