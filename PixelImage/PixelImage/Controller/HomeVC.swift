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
        
        
        let burguer = Image(image: UIImage(named: "burger")!)
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        let f1 = MixFilter()
        let i2 = f1.apply(input: burguer)
        imageView.image = i2.toUIImage()
        
        
        view.addSubview(imageView)
        imageView.center(inView: view)
        
    }


}
