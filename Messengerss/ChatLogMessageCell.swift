//
//  ChatLogMessageCell.swift
//  Messengerss
//
//  Created by Bhavani on 20/08/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit

class ChatLogMessageCell: UICollectionViewCell {

    var messageTextView:UITextView? = nil
    var textBubbleView:UIView? = nil
    var profileImageView:UIImageView? = nil
    
    
    @IBOutlet weak var textLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageTextView = {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 15)
            //textView.textAlignment = .justified
//            textView.text = "Sample message!!!"
            textView.backgroundColor = UIColor.clear
            textView.adjustsFontForContentSizeCategory = true
            textView.autoresizesSubviews = true
        
            textView.isEditable = false
            textView.isSelectable = false
            textView.isScrollEnabled = false
            return textView
        }()
        
        textBubbleView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.95, alpha: 1)
            view.layer.cornerRadius = 15
            view.layer.masksToBounds = true
            return view
        }()
        
        profileImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 15
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        
        setupViews()
       
    }
    
    func setupViews() {
        
        backgroundColor = UIColor.clear
        
        addSubview(textBubbleView!)
        addSubview(messageTextView!)
        addSubview(profileImageView!)
        
        addContraintsWithFormat(format: "H:|-5-[v0(30)]", views: profileImageView!)
        addContraintsWithFormat(format: "V:|-5-[v0(30)]", views: profileImageView!)
        profileImageView?.backgroundColor = UIColor.red
        
       // messageTextView?.translatesAutoresizingMaskIntoConstraints = false
//        addContraintsWithFormat(format: "H:|[v0]|", views: messageTextView!)
//        addContraintsWithFormat(format: "V:|[v0]|", views: messageTextView!)
        
    }

}


