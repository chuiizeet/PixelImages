//
//  CanvasBg.swift
//  PixelImage
//
//  Created by imac on 9/10/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class CanvasBg: UIView {
    
    // MARK: - Properties
    
    var placeHolderImages: [PlaceHolderCollage]? {
        didSet {
            if self.placeHolderImages != nil {
                
                for (k,placeH) in self.placeHolderImages!.enumerated() {
                    addSubview(placeH)
                    
                    if k == 0 {
                        placeH.frame = CGRect(x: 0, y: 0, width: frame.width/2, height: frame.height).inset(by: UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9))
                    } else {
                        placeH.frame = CGRect(x: frame.width/2, y: 0, width: frame.width/2, height: frame.height).inset(by: UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9))
                    }
                }
                
            } else {
                print("Empty")
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
