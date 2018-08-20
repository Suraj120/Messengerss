//
//  ChatLogController.swift
//  Messengerss
//
//  Created by Bibhuti Anand on 8/19/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import Foundation
import UIKit

class ChatLogController: UICollectionViewController {
    
    
    var friend: Friend? {
        didSet{
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.red
        //collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: "cellId")
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            print(count)
             return count
            } else {
            return 0
        }
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatLogMessageCell
        return cell
    }
}

//class ChatLogMessageCell: UICollectionViewCell {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupViews() {
//        backgroundColor = UIColor.red
//    }
//}




