//
//  TabBarController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 25/06/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service: MusicService
        
        do {
            service = try MusicService()
        } catch {
            fatalError("Failed to instantiate MusicService: \(error)")
        }
        
        for controller in viewControllers ?? [] {
            let navController = controller as? UINavigationController
            
            if let discover = navController?.topViewController as? DiscoverViewController {
                discover.service = service
            } else if let library = navController?.topViewController as? LibraryViewController {
                library.service = service
            } else if let favorites = navController?.topViewController as? FavoritesViewController {
                favorites.service = service
            }
        }
    }
}
