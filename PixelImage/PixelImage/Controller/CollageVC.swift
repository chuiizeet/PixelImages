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
    
    var canvasBg: CanvasBg!
    var positions: [CGRect]?
    
    let x: PlaceHolderCollage = {
       let placeh = PlaceHolderCollage()
        return placeh
    }()
    
    let y: PlaceHolderCollage = {
        let placeh = PlaceHolderCollage()
        return placeh
    }()
    
    // HARDCODEBOYZZZZZ
    
    lazy var btn1: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .magenta
        btn.addTarget(self, action: #selector(handlerBtn1), for: .touchUpInside)
        return btn
    }()
    lazy var btn2: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .magenta
        btn.addTarget(self, action: #selector(handlerBtn2), for: .touchUpInside)
        return btn
    }()
    lazy var btn3: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .magenta
        btn.addTarget(self, action: #selector(handlerBtn3), for: .touchUpInside)
        return btn
    }()
    lazy var btn4: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .magenta
        btn.addTarget(self, action: #selector(handlerBtn4), for: .touchUpInside)
        return btn
    }()

    
    // MARK: - Init
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        
        canvasBg = CanvasBg(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        
        view.addSubview(canvasBg)
        canvasBg.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.height/2)
        canvasBg.center(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [btn1, btn2, btn3, btn4])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 8
        
        view.addSubview(stack)
        stack.anchor(top: nil, left: view.leftAnchor, bottom: canvasBg.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 50)
        
        
    }
    
    // MARK: - Handlers
    
    @objc func handlerBtn1() {
        
        let currentFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let firstPosition = CGRect(x: 0, y: 0, width: currentFrame.width/2, height: currentFrame.height/2).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let secPosition = CGRect(x: currentFrame.width/2, y: 0, width: currentFrame.width/2, height: currentFrame.height/2).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.positions = [firstPosition, secPosition]
        canvasBg.placheHolderPositions = positions
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        
        
    }
    
    @objc func handlerBtn2() {
        
        let currentFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let firstPosition = CGRect(x: 0, y: 0, width: currentFrame.width, height: currentFrame.height/4).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let secPosition = CGRect(x: 0, y: view.frame.height/4, width: currentFrame.width, height: currentFrame.height/4).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.positions = [firstPosition, secPosition]
        canvasBg.placheHolderPositions = positions
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
    }
    
    @objc func handlerBtn3() {
        
        let currentFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        
        let firstPosition = CGRect(x: 0, y: 0, width: currentFrame.width, height: currentFrame.height/3).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let secPosition = CGRect(x: 0, y: view.frame.height/3, width: currentFrame.width, height: currentFrame.height/3).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let tPosition = CGRect(x: 0, y: view.frame.height/6, width: currentFrame.width, height: currentFrame.height/3).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.positions = [firstPosition, secPosition, tPosition]
        canvasBg.placheHolderPositions = positions
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
    }
    
    @objc func handlerBtn4() {
        
        let currentFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        
        let firstPosition = CGRect(x: 0, y: 0, width: currentFrame.width/2, height: currentFrame.height/2).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let secPosition = CGRect(x: currentFrame.width/2, y: 0, width: currentFrame.width/2, height: currentFrame.height/2).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let tPosition = CGRect(x: 0, y: view.frame.height/4, width: currentFrame.width, height: currentFrame.height/2).inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.positions = [firstPosition, secPosition, tPosition]
        canvasBg.placheHolderPositions = positions
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
    }
    

}
