//
//  AddFiltersVC.swift
//  PixelImage
//
//  Created by imac on 9/7/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FiltersCell"

class AddFiltersVC: UITableViewController {
    
    // MARK: - Properties
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewComponents()

    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        
        view.backgroundColor = .white
        tableView.register(FilterCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = allFilters[indexPath.row].name
        return cell
    }


}
