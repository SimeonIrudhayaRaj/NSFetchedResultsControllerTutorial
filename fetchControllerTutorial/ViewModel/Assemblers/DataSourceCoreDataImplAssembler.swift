class DataSourceCoreDataImplAssembler {
    static func createInstance() -> DataSourceCoreDataImpl {
        return DataSourceCoreDataImpl(
            context: CoreDataService.shared.persistentContainer.viewContext
        )
    }
}
