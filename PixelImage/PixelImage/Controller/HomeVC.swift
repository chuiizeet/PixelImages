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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handlerTapBtn))
        
        selectedFilters.filters.append(InvertFilter())
//        selectedFilters.filters.append(MixFilter())
//        selectedFilters.filters.append(ScaleOntensityFilter(scale: 0.85))
        
        view.addSubview(imageView)
        imageView.image = filterImage().toUIImage()
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
    
    @objc func handlerTapBtn() {
        
        let vc = SelectFiltersVC(style: .plain)
        vc.filtersModel = selectedFilters
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
