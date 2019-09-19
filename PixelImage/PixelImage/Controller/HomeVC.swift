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
    
    var selectedFilters: FiltersModel = FiltersModel()
    var filter = ChromaticAberration()
    var filtersHaveChanged = false
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let radiusSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 25
//        slider.addTarget(self, action: #selector(handlerRadius), for: .valueChanged)
        return slider
    }()
    
    let angleSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = Float((Double.pi * 2))
//        slider.addTarget(self, action: #selector(handlerAngle), for: .valueChanged)
        return slider
    }()
    
    // MARK: - Init
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if filtersHaveChanged {
            imageView.image = filterImage().toUIImage()
            filtersHaveChanged = false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handlerTapBtn))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Apply", style: .done, target: self, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filtersChanged), name: NSNotification.Name(rawValue: "FiltersChanged"), object: nil)
        
        let ciimage = CIImage(image: UIImage(named: "watson")!)
        
        filter.inputImage = ciimage
        
        let output = filter.outputImage!
        let context = CIContext()
        let ciOutputImage = context.createCGImage(output, from: ciimage!.extent)
        imageView.image = UIImage(cgImage: ciOutputImage!)
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 650)
        imageView.centerX(inView: view)
        
//        view.addSubview(radiusSlider)
//        radiusSlider.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)
//
//        view.addSubview(angleSlider)
//        angleSlider.anchor(top: radiusSlider.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 0)

        
    }
    
    func filterImage() -> Image {
        var burger = Image(image: UIImage(named: "watson")!)
        for filter in selectedFilters.filters {
            burger = filter.apply(input: burger)
        }
        return burger
    }
    
    // MARK: - Handlers
    
    @objc func filtersChanged() {
        filtersHaveChanged = true
    }
    
//    @objc func handlerRadius(_ sender: UISlider) {
//        let ciimage = CIImage(image: UIImage(named: "watson")!)
//
//        filter.inputRadius = CGFloat(sender.value)
//        let output = filter.outputImage!
//        let context = CIContext()
//        let ciOutputImage = context.createCGImage(output, from: ciimage!.extent)
//        imageView.image = UIImage(cgImage: ciOutputImage!)
//        view.layoutIfNeeded()
//    }
//
//    @objc func handlerAngle(_ sender: UISlider) {
//        let ciimage = CIImage(image: UIImage(named: "watson")!)
//
//        filter.inputAngle = CGFloat(sender.value)
//        let output = filter.outputImage!
//        let context = CIContext()
//        let ciOutputImage = context.createCGImage(output, from: ciimage!.extent)
//        imageView.image = UIImage(cgImage: ciOutputImage!)
//        view.layoutIfNeeded()
//    }
    
    @objc func handlerTapBtn() {
        
        let vc = SelectFiltersVC(style: .plain)
        vc.filtersModel = selectedFilters
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
