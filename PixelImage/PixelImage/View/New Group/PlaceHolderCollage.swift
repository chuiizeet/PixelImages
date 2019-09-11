//
//  PlaceHolderCollage.swift
//  PixelImage
//
//  Created by imac on 9/10/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class PlaceHolderCollage: UIView {

    // MARK: - Properties
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "watson")
        iv.contentMode = UIView.ContentMode.scaleAspectFill
        return iv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        backgroundColor = .clear
        layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
