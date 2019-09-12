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
    var filtersHaveChanged = false
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
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
        
//        view.addSubview(imageView)
//        imageView.image = filterImage().toUIImage()
//        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 650)
//        imageView.center(inView: view)
        
        let ciimage = CIImage(image: UIImage(named: "watson")!)
        let filter = TransverseChromaticAberration()
        
        filter.inputImage = ciimage
        filter.inputBlur = 20
        filter.inputSamples = 3
        filter.inputFalloff = 0.5
        
        let output = filter.outputImage!
        let context = CIContext()
        let ciOutputImage = context.createCGImage(output, from: ciimage!.extent)
        imageView.image = UIImage(cgImage: ciOutputImage!)
        view.addSubview(imageView)
        imageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 650)
        imageView.center(inView: view)
        
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
    
    @objc func handlerTapBtn() {
        
        let vc = SelectFiltersVC(style: .plain)
        vc.filtersModel = selectedFilters
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
