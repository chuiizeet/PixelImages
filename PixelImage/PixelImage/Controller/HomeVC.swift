//
//  HomeVC.swift
//  PixelImage
//
//  Created by imac on 9/6/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - Properties
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        let image = Image(image: UIImage(named: "burger")!)
        imageView.image = image.toUIImage()
        
        view.addSubview(imageView)
        imageView.center(inView: view)
        
    }


}
