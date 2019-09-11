//
//  MainTabBVC.swift
//  PixelImage
//
//  Created by imac on 9/8/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class MainTabBVC: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

       setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        
        let filterImage = UIImage(named: "filter")!
        let resizeImage = UIImage(named: "resize")!
        let collageImage = UIImage(named: "collage")!
        
        let filtersVC = constructNavController(title: "Filters", unselectedImage: filterImage, selectedImage: filterImage, rootViewController: HomeVC())
        
        let resizeVC = constructNavController(title: "Resize", unselectedImage: resizeImage, selectedImage: resizeImage, rootViewController: ResizeVC())
        
        let collageVC = constructNavController(title: "Collage", unselectedImage: collageImage, selectedImage: collageImage, rootViewController: CollageVC())
        
        // View controller add
        viewControllers = [filtersVC, resizeVC, collageVC]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
        tabBar.backgroundColor = .white
        
    }
    

    
    /// Construct navigation bar
    func constructNavController(title: String, unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        // Construct nav controller
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.barTintColor = .white
        navController.tabBarItem.title = title
        
        tabBar.tintColor = .red
        return navController
        
    }

}
