//
//  SelectFiltersVC.swift
//  PixelImage
//
//  Created by imac on 9/7/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FiltersCell"

class SelectFiltersVC: UITableViewController {
    
    // MARK: - Properties
    
    let dummyData = ["Filter 1", "Filter 2"]
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponens()
    }
    
    // MARK: - Helper Functios
    
    func setupViewComponens() {
        
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        tableView.register(FilterCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dummyData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FilterCell
        
        cell.textLabel?.text = dummyData[indexPath.row]
        
        return cell
        
    }


}
