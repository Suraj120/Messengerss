//
//  FriendsCell.swift
//  Messengerss
//
//  Created by Bibhuti Anand on 8/16/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit

class FriendsCell: UICollectionViewCell {
    
    var profileImageView: UIImageView? = nil
    var dividerLineView: UIView? = nil
    var nameLabel:UILabel? = nil
    var messageLabel:UILabel? = nil
    var timeLabel:UILabel? = nil
    var hasReadImageView:UIImageView? = nil
    
    override func awakeFromNib() {
        
         profileImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 34
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        dividerLineView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            return view
        }()
       
        nameLabel = {
            let label = UILabel()
            label.text = "Friend Label"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        messageLabel = {
            let label = UILabel()
            label.text = "qwerty qwerty"
            label.font = UIFont.systemFont(ofSize: 16)
            return label
        }()
        
         timeLabel = {
            let label = UILabel()
            label.text = "12.05 pm"
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textAlignment = .right
            return label
        }()
        
        hasReadImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
      setupViews()
        setupContainerView()
        
    }
    
    func setupViews() {
        //backgroundColor = UIColor.blue
        addSubview(profileImageView!)
        addSubview(dividerLineView!)
        
        profileImageView?.image = #imageLiteral(resourceName: "mark")
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView?.translatesAutoresizingMaskIntoConstraints = false
        
        addContraintsWithFormat(format: "H:|-12-[v0(70)]", views: profileImageView!)
        addContraintsWithFormat(format: "V:|-12-[v0(70)]", views: profileImageView!)
        //addConstraint(NSLayoutConstraint(item: profileImageView!, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerYWithinMargins, multiplier: 1, constant: 0))
        
        
        addContraintsWithFormat(format: "H:|-50-[v0]|", views: dividerLineView!)
        addContraintsWithFormat(format: "V:[v0(1.5)]|", views: dividerLineView!)
        
        
    }
    
    private func setupContainerView() {
        
        let containerView = UIView()
        //containerView.backgroundColor = UIColor.red
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addContraintsWithFormat(format:"H:|-90-[v0]-5-|", views: containerView)
        addContraintsWithFormat(format: "V:|-15-[v0(50)]", views: containerView)
        
        
        //addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem:self, attribute: .centerY, multiplier: 1, constant: 0))
    

        containerView.addSubview(nameLabel!)
        containerView.addContraintsWithFormat(format: "H:|[v0]", views: nameLabel!)
        containerView.addContraintsWithFormat(format: "V:|[v0][v1(24)]", views: nameLabel!, messageLabel!)
        
        containerView.addSubview(messageLabel!)
        containerView.addContraintsWithFormat(format: "H:|[v0]-5-|", views: messageLabel!)
        
        containerView.addSubview(timeLabel!)
        containerView.addContraintsWithFormat(format: "H:[v0(80)]-12-|", views: timeLabel!)
        containerView.addContraintsWithFormat(format: "V:|[v0(20)]", views: timeLabel!)
        
        hasReadImageView?.image = #imageLiteral(resourceName: "mark")
        hasReadImageView?.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hasReadImageView!)
        containerView.addContraintsWithFormat(format: "H:[v0(20)]-12-|", views: hasReadImageView!)
        containerView.addContraintsWithFormat(format: "V:[v0(25)]|", views: hasReadImageView!)
        
    }
    
}

extension UIView {
    
    func addContraintsWithFormat(format: String, views: UIView...){
        
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}
