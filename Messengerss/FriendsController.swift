//
//  ViewController.swift
//  Messengerss
//
//  Created by Bibhuti Anand on 8/16/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit
import CoreData

class FriendsViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
//    var messages: [Message]?
    
    var friend: Friend?
    var blockOperations = [BlockOperation]()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Friend> = {
        
        let fetchRequest = NSFetchRequest<Friend>(entityName: "Friend")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        
        fetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         navigationController?.navigationItem.title = "Recents"
          navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Mark", style: .plain, target: self, action:#selector (addMark))
         //collectionView?.backgroundColor = UIColor.red
        collectionView?.alwaysBounceVertical = true
        setupData()
        do{
            try fetchedResultsController.performFetch()

        } catch {
            print("error in fetching friend entity \(error.localizedDescription)")
        }
      
    }
    
    @objc func addMark() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        
        FriendsViewController.createMessageWithText(text: "Hello. My name is Mark.Nice to meet u!!!", friend: mark, minutes: 0, context: context)
        
        let bill = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        bill.name = "billy"
        bill.profileImageName = ""
        
        FriendsViewController.createMessageWithText(text: "Hello Windows!!!", friend: bill, minutes: 0, context: context)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects{
            return count
        }else {
            return 0
        }
        
    }

    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            
            blockOperations.append(BlockOperation(block: {
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
            
        }
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView?.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
            
        }) { (completed ) in
            let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MessageCell
        
        let friend = fetchedResultsController.object(at: indexPath) as! Friend
        
        cell.message = friend.lastMessage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogController
         let friend = fetchedResultsController.object(at: indexPath) as! Friend
        
        controller.friend = friend
        
        navigationController?.pushViewController(controller, animated: true)
    }
}











