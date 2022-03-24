//
//  LocationsViewController.swift
//  MyLocationApp
//
//  Created by 황신택 on 2022/03/21.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()
    @IBOutlet weak var listTableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity
        
        let sort1 = NSSortDescriptor(
            key: "date",
            ascending: true)
        let sort2 = NSSortDescriptor(key: "category",
                                     ascending: true)
        fetchRequest.sortDescriptors = [sort1, sort2]
        
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: "category",
            cacheName: "Locations")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            if let controller = segue.destination as? LocationDetailsViewController,
               let cell = sender as? UITableViewCell,
               let indexPath = listTableView.indexPath(for: cell) {
               let location = fetchedResultsController.object(at: indexPath)
                controller.managedObjectContext = managedObjectContext
                controller.locationEdit = location
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    deinit {
        fetchedResultsController.delegate = nil
    }
}


extension LocationsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationViewCell", for: indexPath) as! LocationViewCell
        let location = fetchedResultsController.object(at: indexPath)
        cell.configure(model: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let location = fetchedResultsController.object(at: indexPath)
            location.removePhotoFile()
            managedObjectContext.delete(location)
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.name.uppercased()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let labelRect = CGRect(
            x: 15,
            y: tableView.sectionHeaderHeight - 14,
            width: 300,
            height: 14)
        let label = UILabel(frame: labelRect)
        label.font = UIFont.boldSystemFont(ofSize: 11)
        
        label.text = tableView.dataSource!.tableView!(
            tableView,
            titleForHeaderInSection: section)
        
        label.textColor = UIColor(white: 1.0, alpha: 0.6)
        label.backgroundColor = UIColor.clear
        
        let separatorRect = CGRect(
            x: 15, y: tableView.sectionHeaderHeight - 0.5,
            width: tableView.bounds.size.width - 15,
            height: 0.5)
        let separator = UIView(frame: separatorRect)
        separator.backgroundColor = tableView.separatorColor
        
        let viewRect = CGRect(
            x: 0, y: 0,
            width: tableView.bounds.size.width,
            height: tableView.sectionHeaderHeight)
        let view = UIView(frame: viewRect)
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        view.addSubview(label)
        view.addSubview(separator)
        return view
    }

}


extension LocationsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listTableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (object)")
            listTableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            print("*** NSFetchedResultsChangeDelete (object)")
            listTableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            print("*** NSFetchedResultsChangeUpdate (object)")
            if let cell = listTableView.cellForRow(
                at: indexPath!) as? LocationViewCell {
                let location = controller.object(
                    at: indexPath!) as! Location
                cell.configure(model: location)
            }
            
        case .move:
            print("*** NSFetchedResultsChangeMove (object)")
            listTableView.deleteRows(at: [indexPath!], with: .fade)
            listTableView.insertRows(at: [newIndexPath!], with: .fade)
            
        @unknown default:
            print("*** NSFetchedResults unknown type")
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            print("*** NSFetchedResultsChangeInsert (section)")
            listTableView.insertSections(
                IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            listTableView.deleteSections(
                IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("*** NSFetchedResultsChangeUpdate (section)")
        case .move:
            print("*** NSFetchedResultsChangeMove (section)")
        @unknown default:
            print("*** NSFetchedResults unknown type")
        }
    }
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        print("*** controllerDidChangeContent")
        listTableView.endUpdates()
    }
}
