//
//  CategoryPickerViewController.swift
//  MyLocationApp
//
//  Created by 황신택 on 2022/03/12.
//

import UIKit


class CategoryPickerViewController: UITableViewController {
    var selectedCategoryName = ""
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
        "Park"
    ]
    
    var selectedIndexPath = IndexPath()
    
    //    // MARK: - Navigation
    //    override func prepare(
    //        for segue: UIStoryboardSegue,
    //        sender: Any?
    //    ) {
    //        if segue.identifier == "PickedCategory" {
    //            print("access picker")
    //            let cell = sender as! UITableViewCell
    //            if let indexPath = tableView.indexPath(for: cell) {
    //                selectedCategoryName = categories[indexPath.row]
    //            }
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        for i in 0..<categories.count {
            if categories[i] == selectedCategoryName {
                selectedIndexPath = IndexPath(row: i, section: 0)
                break
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let categoryName = categories[indexPath.row]
        
        cell.textLabel?.text = categoryName
        
        if categoryName == selectedCategoryName {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryName = categories[indexPath.row]
        if indexPath.row != selectedIndexPath.row {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                
                NotificationCenter.default.post(name: .addCategoryName, object: nil, userInfo: ["name": categoryName])
        
                navigationController?.popViewController(animated: true)
            }
            
            if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
                oldCell.accessoryType = .none
            }
            selectedIndexPath = indexPath
        }
    }
}



extension Notification.Name {
    static let addCategoryName = Notification.Name("addCategoryName")
    static let editCategory = Notification.Name("editCategory")
}
