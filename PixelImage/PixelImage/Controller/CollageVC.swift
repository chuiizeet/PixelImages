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
    
    lazy var canvasBg: CanvasBg = {
        let canvas = CanvasBg()
        return canvas
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
        
        view.addSubview(canvasBg)
        canvasBg.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height/2)
        canvasBg.center(inView: view)
    }

}
