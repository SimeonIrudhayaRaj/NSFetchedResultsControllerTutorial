import Foundation

protocol DataSourceObserver: class {
    func cellInserted(at newIndexPath: IndexPath)
    func cellDeleted(at indexPath: IndexPath)
    func cellMoved(from indexPath: IndexPath, to newIndexPath: IndexPath)
    func cellUpdated(at indexPath: IndexPath)
}
