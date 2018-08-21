//
//  ChatLogControllers.swift
//  Messengerss
//
//  Created by Bhavani on 20/08/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit

private let reuseIdentifier = "chatCell"

class ChatLogControllers: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by: {$0.date?.compare($1.date!) == .orderedAscending})
        }
    }
    
    var messages: [Message]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.collectionView!.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let count = messages?.count {
            print(count)
            return count
        }else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatLogMessageCell
        
        cell.messageTextView?.text = messages?[indexPath.item].text
        
        if let messageText = messages?[indexPath.item].text, let profileImageName = messages?[indexPath.item].friend?.profileImageName {
            
            cell.profileImageView?.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250.0, height: 100.0)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! ]
            let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25.0) ]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: myAttribute, context: nil)
            
            cell.messageTextView?.frame = CGRect(x: 40.0, y: 0.0, width:estimatedFrame.width, height: estimatedFrame.height + 40 )
            cell.textBubbleView?.frame = CGRect(x:40.0, y: 0.0, width: estimatedFrame.width, height: estimatedFrame.height + 40 )
            
            
        }
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages?[indexPath.item].text {
            
            let size = CGSize(width: 250.0, height: 100.0)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! ]
            let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25.0) ]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: myAttribute, context: nil)
            
           return CGSize(width: view.frame.width , height: estimatedFrame.height+50)
            
        }
        
        return CGSize(width: view.frame.width, height: 100.0)
    }
  

}
