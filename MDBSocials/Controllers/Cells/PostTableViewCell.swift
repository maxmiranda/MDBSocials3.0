//
//  PostTableViewCell.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/22/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    var posterImageView: UIImageView!
    var postMemberName: UILabel!
    var postEventName: UILabel!
    var postNumberInterested : UILabel!
    var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView = UIImageView(frame: CGRect(x: 50, y: 20, width: 80, height: 80))
        posterImageView.contentMode = .scaleAspectFit
        
        postImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: 200))
        postImageView.contentMode = .scaleAspectFit
        
        postEventName = UILabel(frame: CGRect(x: 250, y: 110, width: 100, height: 30))
        postEventName.backgroundColor = .white
        postEventName.textAlignment = .center
        postEventName.font = UIFont(name: "Hiragino Sans", size: 16)
        postEventName.layer.cornerRadius = 5.0
        
        postMemberName = UILabel(frame: CGRect(x: 250, y: 150, width: 100, height: 30))
        postMemberName.backgroundColor = .white
        postMemberName.textAlignment = .center
        postMemberName.font = UIFont(name: "Hiragino Sans", size: 13)
        postMemberName.layer.cornerRadius = 5.0
        
        postNumberInterested = UILabel(frame: CGRect(x: 250, y: 20, width: 80, height: 40))
        postNumberInterested.backgroundColor = .white
        postNumberInterested.layer.cornerRadius = 20.0
        postNumberInterested.textAlignment = .center
        postNumberInterested.font = UIFont(name: "Hiragino Sans", size: 10)
        postNumberInterested.layer.cornerRadius = 5.0
        
        contentView.addSubview(postImageView!)
        contentView.addSubview(posterImageView!)
        contentView.addSubview(postMemberName)
        contentView.addSubview(postEventName)
        contentView.addSubview(postNumberInterested)
    }

}
