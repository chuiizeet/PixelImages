//
//  ResizeVC.swift
//  PixelImage
//
//  Created by imac on 9/8/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ResizeVC: UIViewController {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "watson")
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.frame.size = CGSize(width: view.frame.width/2, height: view.frame.width/2)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width/2, height: view.frame.height/2)
        imageView.center(inView: view)
        
        let maskView = UIImageView()
        maskView.image = UIImage(named: "star")
        maskView.frame = imageView.bounds
        imageView.mask = maskView
 
    }
    
}
