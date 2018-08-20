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
        collectionView?.backgroundColor = UIColor.cyan
        
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
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100.0)
    }
  

}
