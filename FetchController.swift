//
//  FetchController.swift
//  fetchControllerTutorial
//
//  Created by Simeon Irudhaya Raj J on 03/01/20.
//  Copyright © 2020 Simeon Irudhaya Raj J. All rights reserved.
//

import Foundation
import CoreData
import AppKit
class FetchController: NSObject {
    //MARK: - Properties
    static let sharedInstance = FetchController()
    
    var fetchedResultsController: NSFetchedResultsController<Cell>!

    lazy var context: NSManagedObjectContext = {
        let appDel:AppDelegate = (NSApplication.shared.delegate as! AppDelegate)
        return appDel.persistentContainer.viewContext
    }()
}
