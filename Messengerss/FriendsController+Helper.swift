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
        
        createSteveMessages(context: context)
        
        let donald = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        donald.name = "Donald Trump"
        donald.profileImageName = "trump"
        
        let gandhi = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        gandhi.name = "Mahatma Gandhi"
        gandhi.profileImageName = "gandhi"
        
       
        
        createMessageWithText(text: "You are fired!!!", friend: donald, minutes: 5, context: context)
        createMessageWithText(text: "Love, peace and joy", friend: gandhi, minutes: 60*24, context: context)
       
    
        do{
            try context.save()
        }catch {
            print("error in saving context \(error)")
        }
        loadData()
        //messages = [message,messageSteve]
    }
    
    private func createSteveMessages(context: NSManagedObjectContext) {
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        createMessageWithText(text: "Good Morning", friend: steve, minutes: 3, context: context)
        createMessageWithText(text: "How are you? Do want to buy an apple device? If u don't have an iPhone u don't have an iPhone.", friend: steve, minutes: 2, context: context)
        createMessageWithText(text: "Technology is nothing. What's important is that you have a faith in people, that they're basically good and smart, and if you give them tools, they'll do wonderful things with them.", friend: steve, minutes: 1, context: context)
        
        //Response
        
         createMessageWithText(text: "Yeah... totally lokking to buy an iphone.", friend: steve, minutes: 0, context: context, isSender: true)
        
        
        
    }
    
    
    private func createMessageWithText(text:String, friend:Friend, minutes:Double, context:NSManagedObjectContext, isSender:Bool = false){
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = Date().addingTimeInterval(-minutes*60)
        message.friend = friend
        message.isSender = NSNumber(value: isSender) as! Bool
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







