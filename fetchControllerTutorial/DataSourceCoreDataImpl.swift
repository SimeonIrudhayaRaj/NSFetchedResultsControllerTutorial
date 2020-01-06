import CoreData

class DataSourceCoreDataImpl: NSObject, DataSource {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    
    // MARK: - Properties
    private var fetchedResultsController: NSFetchedResultsController<Cell>
    weak var observer: DataSourceObserver?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        // Setting up fetchedResultsController
        let fetchRequest = NSFetchRequest<Cell>(entityName: "Cell")
        let fetchSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        self.fetchedResultsController = NSFetchedResultsController<Cell>(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }
}

// MARK: - DataSource
extension DataSourceCoreDataImpl {
    var cells: [Cell] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    func sort(by sortType: String) {
        setUpFetchedResultsControllerForSortType(sortType)
    }
    
    func addNewCell(name: String, id: String, time: Int64) {
        let cellEntity = NSEntityDescription.entity(forEntityName: "Cell", in: context)
        let newCell = Cell(entity: cellEntity!, insertInto: context)
        newCell.name = name
        newCell.id = id
        newCell.time = time
        
        do {
            try self.context.save()
        } catch let err {
            print(err)
        }
    }
    
    func updateCellTime(id: String, newTime: Int64) {
        for cell in cells where cell.id! == id {
            cell.time = newTime
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }

            return
        }
    }
    
    func deleteCell(withID id: String) {
        for cell in cells where cell.id! == id {
            context.delete(cell)
            
            do {
                try context.save()
            } catch let err {
                print(err)
            }
            
            return
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension DataSourceCoreDataImpl: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            observer?.cellInserted(at: newIndexPath!)
        case .delete:
            observer?.cellDeleted(at: indexPath!)
        case .move:
            observer?.cellMoved(from: indexPath!, to: newIndexPath!)
        case .update:
            observer?.cellUpdated(at: indexPath!)
        @unknown default:
            fatalError()
        }
    }
}

// MARK: - Util
private extension DataSourceCoreDataImpl {
    func setUpFetchedResultsControllerForSortType(_ sortType: String) {
        let fetchRequest = NSFetchRequest<Cell>(entityName: "Cell")
        let fetchSort = NSSortDescriptor(key: sortType, ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        self.fetchedResultsController = NSFetchedResultsController<Cell>(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }
    }
}
