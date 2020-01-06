protocol DataSource {
    var cells: [Cell] { get }
    var observer: DataSourceObserver? { get set }
    
    func sort(by sortType: String)
    func addNewCell(name: String, id: String, time: Int64)
    func updateCellTime(id: String, newTime: Int64)
    func deleteCell(withID id: String)
}
