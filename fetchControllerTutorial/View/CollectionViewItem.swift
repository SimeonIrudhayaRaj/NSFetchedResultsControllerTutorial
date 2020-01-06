//
//  CollectionViewItem.swift
//  fetchControllerTutorial
//
//  Created by Simeon Irudhaya Raj J on 03/01/20.
//  Copyright © 2020 Simeon Irudhaya Raj J. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: NSTextField!
    @IBOutlet private weak var idLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    // MARK: - Properties
    weak var delegate: CollectionViewItemDelegate?
}

// MARK: - Exposed functions
extension CollectionViewItem {
    func render(_ viewModel: CollectionViewCellViewModel) {
        nameLabel.stringValue = viewModel.nameLabelText
        idLabel.stringValue = viewModel.idLabelText
        timeLabel.stringValue = viewModel.timeLabelText
    }
}

// MARK: - IBActions
private extension CollectionViewItem {
    @IBAction func updateTime(_ sender: Any) {
        delegate?.updateTimeButtonPressed(id: idLabel.stringValue)
    }
    
    @IBAction func delete(_ sender: Any) {
        delegate?.deleteButtonPressed(id: idLabel.stringValue)
    }
}
