//
//  ViewController.swift
//  fetchControllerTutorial
//
//  Created by Simeon Irudhaya Raj J on 03/01/20.
//  Copyright © 2020 Simeon Irudhaya Raj J. All rights reserved.
//

import AppKit

class ViewController: NSViewController, View {
    // MARK: - Dependencies
    private let viewModel = ViewModelAssembler.createInstance()
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: NSCollectionView!
}

//MARK: - View Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        setUpCollectionView()
    }
}

// MARK: - Setup
private extension ViewController {
    func setUpCollectionView() {
        let itemNib = NSNib(nibNamed: "CollectionViewItem", bundle: .main)
        collectionView.register(itemNib, forItemWithIdentifier: NSUserInterfaceItemIdentifier("CollectionViewItem"))
    }
}

// MARK: - IBActions
private extension ViewController {
    @IBAction func sortByTimeButtonPressed(_ sender: Any) {
        viewModel.sortByTimeButtonPressed()
    }
    
    @IBAction func sortByNameButtonPressed(_ sender: Any) {
        viewModel.sortByNameButtonPressed()
    }
    
    @IBAction func addCellButtonPressed(_ sender: Any) {
        viewModel.addCellButtonPressed()
    }
}

//MARK: - CollectionView DataSource
extension ViewController: NSCollectionViewDelegate,NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.collectionViewNumberOfItems()
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath) as! CollectionViewItem
        
        let cellViewModel = viewModel.collectionViewCellViewModel(for: indexPath)
        item.render(cellViewModel)
        item.delegate = self
        
        return item
    }
}

// MARK: - View
extension ViewController {
    // CollectionView
    func collectionViewReloadData() {
        collectionView.reloadData()
    }
    
    func collectionViewInsertItems(at newIndexPaths: Set<IndexPath>) {
        collectionView.insertItems(at: newIndexPaths)
    }
    
    func collectionViewDeleteItems(at indexPaths: Set<IndexPath>) {
        collectionView.deleteItems(at: indexPaths)
    }
    
    func collectionViewMoveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        collectionView.moveItem(at: indexPath, to: newIndexPath)
    }
    
    func collectionViewReloadItems(at indexPaths: Set<IndexPath>) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func showAlertToInsertCell()  {
        let msg = NSAlert()
        msg.addButton(withTitle: "OK")
        msg.messageText = "Add Cell"
        
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = "Name"
        
        msg.accessoryView = txt
        let response: NSApplication.ModalResponse = msg.runModal()
        
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            let cellName = txt.stringValue
            viewModel.addNewCell(name: cellName)
        }
    }
}

// MARK: - CollectionViewItemDelegate
extension ViewController: CollectionViewItemDelegate {
    func updateTimeButtonPressed(id: String) {
        viewModel.updateTimeButtonPressed(id: id)
    }

    func deleteButtonPressed(id: String) {
        viewModel.deleteButtonPressed(id: id)
    }
}
