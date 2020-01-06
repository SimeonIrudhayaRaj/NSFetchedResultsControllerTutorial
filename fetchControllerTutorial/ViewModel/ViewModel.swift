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
        let id = UUID().uuidString
        let time = currentTime
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
            nameLabelText: cell.name!,
            timeLabelText: getCellTimeLabelText(from: cell)
        )
    }
    
    func updateTimeButtonPressed(id: String) {
        let newTime = currentTime
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

// MARK: - Util
private extension ViewModel {
    var currentTime: Int64 {
        Int64(Date().timeIntervalSince1970)
    }
    
    func getCellTimeLabelText(from cell: Cell) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval("\(cell.time)")!))
    }
}
