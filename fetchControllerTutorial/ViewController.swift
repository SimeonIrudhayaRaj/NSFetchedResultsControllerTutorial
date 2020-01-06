//
//  ViewController.swift
//  fetchControllerTutorial
//
//  Created by Simeon Irudhaya Raj J on 03/01/20.
//  Copyright © 2020 Simeon Irudhaya Raj J. All rights reserved.
//

import Cocoa


class ViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    //MARK: - Properites
    let fetchControllerClass = FetchController.sharedInstance
    var fetchedResultsController : NSFetchedResultsController<Cell>!
    var context: NSManagedObjectContext!
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = NSNib(nibNamed: "CollectionViewItem", bundle: .main)
        collectionView.register(item, forItemWithIdentifier: NSUserInterfaceItemIdentifier("CollectionViewItem"))
//        collectionView.register(CollectionViewItem, forItemWithIdentifier: "CollectionViewItem")
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchControllerSetup(sortType: "name")
        
    }

 //MARK: - IBActions
    
  

    @IBAction func timeSort(_ sender: Any) {
        fetchControllerSetup(sortType: "time")
    }
    
    @IBAction func nameSort(_ sender: Any) {
        fetchControllerSetup(sortType: "name")
    }
    
    @IBAction func add(_ sender: Any) {
        getName()
                
    }
    
    
    func getName()  {
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")
        msg.messageText = "Add Cell"
        
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = "Name"
        
        msg.accessoryView = txt
        let response: NSApplication.ModalResponse = msg.runModal()
        
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            let entity = NSEntityDescription.entity(forEntityName: "Cell", in: context)
            let newCell = Cell(entity: entity!, insertInto: context)
            newCell.name = txt.stringValue
            newCell.id = "\((fetchControllerClass.fetchedResultsController.sections?[0].numberOfObjects)! + 1 )"
            newCell.time = Int64(Date().timeIntervalSince1970) * 1_000
            do {
                try self.context.save()
            } catch let err {
                print(err)
            }
        }
        
    }
}

//MARK: - CollectionView DataSource
extension ViewController: NSCollectionViewDelegate,NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchControllerClass.fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        if let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath) as? CollectionViewItem {
            let cell = fetchControllerClass.fetchedResultsController.object(at: indexPath)
                   guard let cellName = cell.name,
                    let cellId = cell.id else {
                       return item
                   }
            item.nameLabel.stringValue = cellName
            item.idLabel.stringValue = cellId
            return item
        }
       
//        item.nameLabel.stringValue = cellName
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        return item
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        }
    }
}

//MARK: - Setup
extension ViewController {
    func fetchControllerSetup(sortType: String) {
        
        context = fetchControllerClass.context
        let fetchRequest = NSFetchRequest<Cell>(entityName: "Cell")
        let fetchSort = NSSortDescriptor(key: sortType, ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        fetchControllerClass.fetchedResultsController = NSFetchedResultsController<Cell>(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchControllerClass.fetchedResultsController.delegate = self
        do {
            try fetchControllerClass.fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
        collectionView.reloadData()
    }
}

