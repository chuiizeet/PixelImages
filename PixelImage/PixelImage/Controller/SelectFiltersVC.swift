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

    var filtersModel: FiltersModel = FiltersModel()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewComponens()
    }
    
    // MARK: - Helper Functios
    
    func setupViewComponens() {
        
        tableView.backgroundColor = .white
        tableView.separatorColor = .clear
        tableView.isEditing = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(filtersUpdated), name: NSNotification.Name(rawValue: "FiltersUpdated"), object: nil)
        
        self.navigationItem.title = "Filters"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handlerTapBtn))
        tableView.register(FilterCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filtersModel.filters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FilterCell
        
        cell.textLabel?.text = filtersModel.filters[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            filtersModel.filters.remove(at: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FiltersChanged"), object: nil)
            tableView.reloadData()
        }
        
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = filtersModel.filters[sourceIndexPath.row]
        filtersModel.filters.remove(at: sourceIndexPath.row)
        filtersModel.filters.insert(item, at: destinationIndexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FiltersChanged"), object: nil)
        tableView.reloadData()
    }
    
    // MARK: - Handlers
    
    @objc func filtersUpdated() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FiltersChanged"), object: nil)
        tableView.reloadData()
    }
    
    @objc func handlerTapBtn() {
        
        let vc = AddFiltersVC()
        vc.filtersModel = self.filtersModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
