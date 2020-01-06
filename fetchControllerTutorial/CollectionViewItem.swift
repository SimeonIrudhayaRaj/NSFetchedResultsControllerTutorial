//
//  CollectionViewItem.swift
//  fetchControllerTutorial
//
//  Created by Simeon Irudhaya Raj J on 03/01/20.
//  Copyright © 2020 Simeon Irudhaya Raj J. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var nameLabel: NSTextField!
    
    @IBOutlet weak var idLabel: NSTextField!
    @IBOutlet weak var time: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func updateTime(_ sender: Any) {
        let newTime = Int64(Date().timeIntervalSince1970) * 1_000
        let context = FetchController.sharedInstance.context
        let fetchRequest = NSFetchRequest<Cell>(entityName: "Cell")
        fetchRequest.predicate = NSPredicate(format: "id == %@", idLabel.stringValue)
        do {
            guard let cell = try context.fetch(fetchRequest).first else { fatalError() }
            cell.time = newTime
            
            try context.save()
        } catch let err {
            print(err)
        }
        
    }
    
    @IBAction func delete(_ sender: Any) {
        let context = FetchController.sharedInstance.context
        let fetchedResultsController: NSFetchedResultsController<Cell>
        let fetchRequest = NSFetchRequest<Cell>(entityName: "Cell")
        let fetchSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        fetchRequest.predicate = NSPredicate(format: "id == %@", idLabel.stringValue)
        fetchedResultsController = NSFetchedResultsController<Cell>(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        for object in fetchedResultsController.fetchedObjects ?? [] {
            context.delete(object)
        }
    }
}
