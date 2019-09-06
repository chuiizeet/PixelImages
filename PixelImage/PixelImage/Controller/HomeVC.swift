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
        let i2 = image.transfromPixels(transformFunc: halfIntense)
        imageView.image = i2.toUIImage()
        
        view.addSubview(imageView)
        imageView.center(inView: view)
        
    }
    
    func halfIntense(p: RGBAPixel) -> RGBAPixel {
        var p2 = p
        
        p2.red = p.red / 2
        p2.green = p.green / 2
        p2.blue = p.blue / 2
        
        return p2
    }


}
