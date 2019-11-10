//
//  RandomFiltersCell.swift
//  PixelImage
//
//  Created by imac on 10/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class RandomFiltersCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var filerImage: UIImage? {
        didSet {
            if filerImage != nil {
                imageView.image = filerImage
            }
        }
    }
    
    var input1: String?
    var input2: String?
    var input3: String?
    var input4: String?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
        
    // MARK: - Properties
    
    func setupViewComponents() {
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handlerTap))
        addGestureRecognizer(gesture)
        
    }
    
    // MARK: - Handlers
    
    @objc func handlerTap() {
        print("1: \(input1 ?? " ") 2: \(input2 ?? " ") 3: \(input3 ?? " ") 4: \(input4 ?? " ")")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
