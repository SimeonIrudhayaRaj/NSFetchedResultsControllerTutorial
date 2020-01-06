import Foundation

class ViewModel {
    // MARK: - Dependencies
    private var dataSource: DataSource
    
    // MARK: - Properties
    weak var view: View?
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.dataSource.observer = self
    }
}

// MARK: - Exposed functions
extension ViewModel {
    func sortByTimeButtonPressed() {
        dataSource.sort(by: "time")
        view?.collectionViewReloadData()
    }
    
    func sortByNameButtonPressed() {
        dataSource.sort(by: "name")
        view?.collectionViewReloadData()
    }
    
    func addCellButtonPressed() {
        view?.showAlertToInsertCell()
    }
    
    func addNewCell(name: String) {
        let id = String(dataSource.cells.count + 1)
        let time = Int64(Date().timeIntervalSince1970) * 1_000
        dataSource.addNewCell(
            name: name,
            id: id,
            time: time
        )
    }
    
    func collectionViewNumberOfItems() -> Int {
        dataSource.cells.count
    }
    
    func collectionViewCellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModel {
        let cell = dataSource.cells[indexPath.item]
        return CollectionViewCellViewModel(
            idLabelText: cell.id!,
            nameLabelText: cell.name!
        )
    }
    
    func updateTimeButtonPressed(id: String) {
        let newTime = Int64(Date().timeIntervalSince1970) * 1_000
        dataSource.updateCellTime(id: id, newTime: newTime)
    }

    func deleteButtonPressed(id: String) {
        dataSource.deleteCell(withID: id)
    }
}

// MARK: - DataSourceObserver
extension ViewModel: DataSourceObserver {
    func cellInserted(at newIndexPath: IndexPath) {
        view?.collectionViewInsertItems(at: Set<IndexPath>([newIndexPath]))
    }
    
    func cellDeleted(at indexPath: IndexPath) {
        view?.collectionViewDeleteItems(at: Set<IndexPath>([indexPath]))
    }
    
    func cellMoved(from indexPath: IndexPath, to newIndexPath: IndexPath) {
        view?.collectionViewMoveItem(at: indexPath, to: newIndexPath)
    }
    
    func cellUpdated(at indexPath: IndexPath) {
        view?.collectionViewReloadItems(at: Set<IndexPath>([indexPath]))
    }
}
