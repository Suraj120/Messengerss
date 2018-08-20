//
//  CustomTabBarController.swift
//  Messengerss
//
//  Created by Bibhuti Anand on 8/20/18.
//  Copyright © 2018 SurajKumar. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let friendsController = storyboard.instantiateViewController(withIdentifier: "FriendsViewController")
        let recentMessageNavController = UINavigationController(rootViewController: friendsController)
        recentMessageNavController.tabBarItem.title = "Recents"
        recentMessageNavController.tabBarItem.image = UIImage(named: "recents")   
        viewControllers = [recentMessageNavController]
    }

}
