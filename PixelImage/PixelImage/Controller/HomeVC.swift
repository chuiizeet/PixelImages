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
        
        selectedFilters.filters.append(MixFilter())
        selectedFilters.filters.append(ScaleOntensityFilter(scale: 0.85))
        
        view.addSubview(imageView)
        imageView.image = filterImage().toUIImage()
        imageView.center(inView: view)
        
    }
    
    func filterImage() -> Image {
        var burger = Image(image: UIImage(named: "burger")!)
        for filter in selectedFilters.filters {
            burger = filter.apply(input: burger)
        }
        return burger
    }
    
    // MARK: - Handlers
    
    @objc func handlerTapBtn() {
        
        let vc = SelectFiltersVC(style: .plain)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
