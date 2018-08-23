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
    
    var bottomContraint:NSLayoutConstraint?
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by: {$0.date?.compare($1.date!) == .orderedAscending})
        }
    }
    
    var messages: [Message]?
    
    let messageInputContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let inputTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(displayP3Red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    var bottomConstraints: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.collectionView!.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        view.addSubview(messageInputContainerView)
        view.addContraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addContraintsWithFormat(format: "V:[v0(55)]", views: messageInputContainerView)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        bottomConstraints = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraints!)
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            print("keyboardFrame: \(keyboardFrame)")
            
            let isKeyboardShowing = (notification.name == NSNotification.Name.UIKeyboardWillShow)
            
            bottomConstraints?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom , animated: true)
                }
             
            })
        }
        
    }
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addContraintsWithFormat(format: "H:|-8-[v0]|", views: inputTextField)
        messageInputContainerView.addContraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        
        messageInputContainerView.addContraintsWithFormat(format: "H:[v0(60)]|", views: sendButton)
        messageInputContainerView.addContraintsWithFormat(format: "V:|[v0]|", views: sendButton)

        messageInputContainerView.addContraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addContraintsWithFormat(format: "V:|[v0(0.5)]|", views: topBorderView)
        
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
        
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            
            cell.profileImageView?.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250.0, height: 100.0)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! ]
            let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25.0) ]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: myAttribute, context: nil)
            
            
            if !message.isSender {
               
                cell.messageTextView?.frame = CGRect(x: 40.0, y: 0.0, width:estimatedFrame.width + 25, height: estimatedFrame.height + 30 )
                cell.textBubbleView?.frame = CGRect(x:40.0, y: 0.0, width: estimatedFrame.width + 25, height: estimatedFrame.height + 10 )
                cell.profileImageView?.isHidden = false
                cell.messageTextView?.adjustsFontForContentSizeCategory = true
                
            } else {
                
                cell.messageTextView?.frame = CGRect(x: view.frame.width - estimatedFrame.width, y: 0.0, width:estimatedFrame.width, height: estimatedFrame.height + 5 )
                cell.messageTextView?.textColor = UIColor(white: 0.95, alpha: 1)
                
                cell.textBubbleView?.frame = CGRect(x:view.frame.width - estimatedFrame.width - 2, y: 0.0, width: estimatedFrame.width, height: estimatedFrame.height + 5 )
                cell.textBubbleView?.backgroundColor = UIColor(displayP3Red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.profileImageView?.isHidden = true
                
            }
            
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
            
           return CGSize(width: view.frame.width , height: estimatedFrame.height+10)
            
        }
        
        return CGSize(width: view.frame.width, height: 100.0)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }

}
