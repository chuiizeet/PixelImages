//
//  HomeVC.swift
//  PixelImage
//
//  Created by imac on 9/6/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterCell"

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    
    var filter = ChromaticAberration()
    var filteredImages = [UIImage]()
    var input1 = [String]()
    var input2 = [String]()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "watson")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {

        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
//        let ciimage = CIImage(image: UIImage(named: "watson")!)
//
//        filter.inputImage = ciimage
//
//        let output = filter.outputImage!
//        let context = CIContext()
//        let ciOutputImage = context.createCGImage(output, from: ciimage!.extent)
//        imageView.image = UIImage(cgImage: ciOutputImage!)
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height/3)
        
        guard let tbheight = self.tabBarController?.tabBar.frame.height else { return }
        
        view.addSubview(collectionView)
        collectionView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: tbheight + 12, paddingRight: 0, width: 0, height: 0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RandomFiltersCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        asyncLoader()
    }
    
    func asyncLoader() {
        let group = DispatchGroup()
        group.enter()
        let dispatchQueue = DispatchQueue(label: "loadFilters", qos: .userInteractive)
        dispatchQueue.async(group: group, execute: {
            self.filterImage()
        })
        group.leave()
        group.notify(queue: DispatchQueue.main) {
            print("Complete")
        }
    }
    
    func randomValue(minV: Float, maxV: Float) -> Float {
        return Float.random(in: minV...maxV)
    }
    
    func filterImage() {
        let ciimage = CIImage(image: imageView.image!)
        for _ in 1...25 {
            let _first = CGFloat(randomValue(minV: 0, maxV: Float(Double.pi*2)))
            let _sec = CGFloat(randomValue(minV: 0, maxV: 25))
            
            filter.inputImage = ciimage
            filter.inputAngle = _first
            filter.inputRadius = _sec
            let output = filter.outputImage!
            let context = CIContext()
            let ciOutputImage = context.createCGImage(output, from: ciimage!.extent)
            let finalImage = UIImage(cgImage: ciOutputImage!)
            
            DispatchQueue.main.async {
                self.filteredImages.append(finalImage)
                
                // Valeus
                self.input1.append(_first.description)
                self.input2.append(_sec.description)

                
                self.collectionView.reloadData()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RandomFiltersCell
        
        cell.imageView.image = filteredImages[indexPath.row]
        
        // Inputs
        cell.input1 = input1[indexPath.row]
        cell.input2 = input2[indexPath.row]
        
        return cell
        
    }
    
    // MARK: - Handlers

}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = view.frame.width/2.5
        
        return CGSize(width: size, height: size * 1.5)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

