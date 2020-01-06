class ViewModelAssembler {
    static func createInstance() -> ViewModel {
        let dataSource: DataSource = DataSourceCoreDataImplAssembler.createInstance()
        return ViewModel(dataSource: dataSource)
    }
}
