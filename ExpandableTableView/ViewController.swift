//
//  ViewController.swift
//  ExpandableTableView
//
//  Created by Abouzar Moradian on 9/13/24.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    var items : [CellModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createItemCells()
        registerCell()
        tableView.dataSource = self
        
        tableView.layer.borderWidth = 2.0
        tableView.layer.borderColor = UIColor.blue.cgColor
        
       
           }

    @IBAction func expandCollapsButton(_ sender: UIButton) {
        
        if tableViewHeightContraint.constant == 200 {
            tableViewHeightContraint.constant = 600
        }else{
            tableViewHeightContraint.constant = 200
        }
        
    }
    
    func registerCell(){
        
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identfier)
    }
    
    func createItemCells(){
        
        let itemCell = CellModel(title: "item 1", detail: "the details of item 1 which might consist of any specificities", expanded: false)
        
        for _ in 0..<10{
            items.append(itemCell)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identfier, for: indexPath) as! ItemCell
        
        let model = items[indexPath.row]
        cell.cellModel = model
        cell.delegate = self
        
        return cell
    }

    
    
}


extension ViewController: ExpandableTableViewCellDelegate {

    func expandableTableViewCell(_ tableViewCell: UITableViewCell, expanded: Bool) {
        // Somehow take note of which cells that are currently expanded,
        // so that the UITableView remembers if it needs to update its cells.

        guard let indexPath = tableView.indexPath(for: tableViewCell) else {
            return
        }
        
        items[indexPath.row].expanded = expanded

        
    }
}

