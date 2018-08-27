//
//  ChatLogControllers.swift
//  Messengerss
//
//  Created by Bhavani on 20/08/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "chatCell"

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    //@IBOutlet weak var collectionView: UICollectionView!
    var bottomContraint:NSLayoutConstraint?
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            //            messages = friend?.messages?.allObjects as? [Message]
            //            messages = messages?.sorted(by: {$0.date?.compare($1.date!) == .orderedAscending})
        }
    }
    
    // var messages: [Message]?
    
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
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(displayP3Red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
        
    }()
    
    
    
    
    @objc func handleSend() {
        print("handle text")
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let message = FriendsViewController.createMessageWithText(text:inputTextField.text!, friend: friend!, minutes: 0, context: context, isSender: true) as? Message
        do {
            try context.save()
            //            message?.append(message!)
            //            let lastItem = Message!.count - 1
            //            let insertionIndexPath = IndexPath(item: lastItem, section: 0)
            //            collectionView?.insertItems(at: [insertionIndexPath])
            //            collectionView?.scrollToItem(at: insertionIndexPath, at: .bottom, animated: true)
            inputTextField.text = nil
        } catch {
            print("error in saving context\(error.localizedDescription)")
        }
        
    }
    
    var bottomConstraints: NSLayoutConstraint?
    
    @objc func simulate() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        FriendsViewController.createMessageWithText(text:"dis is a pseudo message!!!", friend: friend!, minutes: 1, context: context, isSender: false) as? Message
        do {
            try context.save()
            
            //            messages?.append(message!)
            //
            //            messages = messages?.sorted(by: {$0.date!.compare($1.date!) == .orderedAscending})
            //
            //            if let item = messages?.index(of: message!) {
            //                let receivingIndexPath = IndexPath(item: item, section: 0)
            //                collectionView?.insertItems(at: [receivingIndexPath])
            //            }
            
        } catch {
            print("error in saving context\(error.localizedDescription)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
            print(fetchedResultsController.sections?[0].numberOfObjects ?? "")
        } catch {
            print("error in fetching results \(error.localizedDescription)")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        // self.collectionView!.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.delegate = self
        collectionView?.dataSource = self
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
                    
                    let lastItemIndex = (self.collectionView?.numberOfItems(inSection: 0))! - 1
                    //                    let indexPath = IndexPath(item: lastItemIndex, section: 0)
                    self.collectionView?.scrollToItem(at: IndexPath(item: lastItemIndex, section: 0), at: .bottom , animated: true)
                    // TODO: Need to fix thi later
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
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            print(count)
            return count
        }else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatLogMessageCell
        
        let message = fetchedResultsController.object(at: indexPath) as! Message
        
        cell.messageTextView?.text = message.text
        
        if let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            
            cell.profileImageView?.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250.0, height: 100.0)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! ]
            let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25.0) ]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: myAttribute, context: nil)
            
            
            if !message.isSender {
                
                cell.messageTextView?.frame = CGRect(x: 40.0, y: 0.0, width:estimatedFrame.width + 45, height: estimatedFrame.height + 5 )
                cell.textBubbleView?.frame = CGRect(x:40.0, y: 0.0, width: estimatedFrame.width + 45, height: estimatedFrame.height + 5 )
                cell.profileImageView?.isHidden = false
                cell.messageTextView?.adjustsFontForContentSizeCategory = true
                
            } else {
                
                cell.messageTextView?.frame = CGRect(x: view.frame.width - estimatedFrame.width, y: 0.0, width:estimatedFrame.width, height: estimatedFrame.height + 0 )
                cell.messageTextView?.textColor = UIColor(white: 0.95, alpha: 1)
                
                cell.textBubbleView?.frame = CGRect(x:view.frame.width - estimatedFrame.width - 5, y: 0.0, width: estimatedFrame.width, height: estimatedFrame.height + 0 )
                cell.textBubbleView?.backgroundColor = UIColor(displayP3Red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.profileImageView?.isHidden = true
                
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchedResultsController.object(at: indexPath) as! Message
        
        if let messageText = message.text {
            
            let size = CGSize(width: 250.0, height: 100.0)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            //let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! ]
            let myAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25.0) ]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: myAttribute, context: nil)
            
            return CGSize(width: view.frame.width , height: estimatedFrame.height+40)
            
        }
        
        return CGSize(width: view.frame.width, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
    }
    
    //MARK : NSFetchedResultsController Delegates
    
    var blockOperations = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            
            // blockoperation.
            
            collectionView?.insertItems(at: [newIndexPath!])
            collectionView?.scrollToItem(at: newIndexPath!, at: .bottom, animated: true)
        }
        
//        if type == .insert {
//            // blockoperation.
//            blockOperations.append(BlockOperation(block: {
//                self.collectionView?.insertItems(at: [newIndexPath!])
//                 self.collectionView?.scrollToItem(at: newIndexPath!, at: .bottom, animated: true)
//            }))
//
//        }
        
        
    }
    
    
}
