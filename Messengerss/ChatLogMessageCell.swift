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
    
    @IBOutlet weak var textLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.red
        
        messageTextView = {
            let textView = UITextView()
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.text = "Sample message!!!"
            return textView
        }()
        
        setupViews()
       
    }
    
    func setupViews() {
        
        addSubview(messageTextView!)
        messageTextView?.translatesAutoresizingMaskIntoConstraints = false
        addContraintsWithFormat(format: "H:|[v0]|", views: messageTextView!)
        addContraintsWithFormat(format: "V:|[v0]|", views: messageTextView!)
        
    }

}


