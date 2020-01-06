import Foundation

protocol View: class {
    // CollectionView
    func collectionViewReloadData()
    func collectionViewInsertItems(at newIndexPaths: Set<IndexPath>)
    func collectionViewDeleteItems(at indexPaths: Set<IndexPath>)
    func collectionViewMoveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)
    func collectionViewReloadItems(at indexPaths: Set<IndexPath>)
    
    func showAlertToInsertCell()
}
