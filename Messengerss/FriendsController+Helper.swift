//
//  FriendsController+Helper.swift
//  Messengerss
//
//  Created by Bibhuti Anand on 8/19/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit
import CoreData

//class Friend: NSObject {
//
//    var name:String?
//    var profileImageName:String?
//
//}
//
//class Message: NSObject {
//
//    var text: String?
//    var date: Date?
//
//    var friend: Friend?
//}

enum profileImage {
    case mark
    case steve
    case logo
    case flag
    
    var image: UIImage {
        switch self {
        case .mark: return UIImage(named: "mark")!
        case .steve: return UIImage(named: "arrow.png")!
        case .logo: return UIImage(named: "logo.png")!
        case .flag: return UIImage(named: "flag.png")!
        }
    }
}

extension FriendsViewController {
    
    func clearData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            let entityNames = ["Friend", "Message"]
            for entityName in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                for object in objects! {
                    context.delete(object)
                }
            }
            
            
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    
    func setupData() {
    
        clearData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "mark"
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = "Hello. My name is Mark.Nice to meet u!!!"
        message.date = Date()
        message.friend = mark
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "trump"
        
        createMessageWithText(text: "Good Morning", friend: steve, minutes: 3, context: context)
        createMessageWithText(text: "How r u", friend: steve, minutes: 2, context: context)
        createMessageWithText(text: "If u don't have an iPhone u don't have an iPhone", friend: steve, minutes: 1, context: context)
        createMessageWithText(text: "You are fired!!!", friend: donald, minutes: 5, context: context)
        
        do{
            try context.save()
        }catch {
            print("error in saving context \(error)")
        }
        loadData()
        //messages = [message,messageSteve]
    }
    
    private func createMessageWithText(text:String, friend:Friend, minutes:Double, context:NSManagedObjectContext){
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = Date().addingTimeInterval(-minutes*60)
        message.friend = friend
    }
    
    func loadData() {
     
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if let friends = fetchFriend(){
            
            messages = [Message]()
            
            for friend in friends{
                print(friend.name!)
               
                let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key:"date", ascending:false)]
                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                fetchRequest.fetchLimit = 1
                do {
                    let fetchedMessages = try (context.fetch(fetchRequest)) as? [Message]
                    messages?.append(contentsOf: fetchedMessages!)
                } catch {
                    print("error in fetching request \(error.localizedDescription)")
                }
                
            }
            
            messages = messages?.sorted(by: {$0.date?.compare($1.date!) == .orderedDescending})
        }
        
    }
    
    private func fetchFriend() -> [Friend]? {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<Friend>(entityName: "Friend")
        do{
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}







