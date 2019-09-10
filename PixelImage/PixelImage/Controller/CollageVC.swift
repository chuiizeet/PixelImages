//
//  CollageVC.swift
//  PixelImage
//
//  Created by imac on 9/8/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class CollageVC: UIViewController {
    
    // MARK: - Properties
    
    let x: PlaceHolderCollage = {
       let placeh = PlaceHolderCollage()
        return placeh
    }()
    
    let y: PlaceHolderCollage = {
        let placeh = PlaceHolderCollage()
        return placeh
    }()
    
    // MARK: - Init
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .red
        
        let canvasBg = CanvasBg(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        
        view.addSubview(canvasBg)
        canvasBg.placeHolderImages = [x,y]
        canvasBg.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height/2)
        canvasBg.center(inView: view)
    }

}
