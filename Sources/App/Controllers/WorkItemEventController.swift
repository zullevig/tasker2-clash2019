import Vapor

final class WorkItemEventController {
    // API fetch all request example
    func list(_ request: Request) throws -> Future<[WorkItemEvent]> {
        let models = WorkItemEvent.query(on: request).all()
        return models
    }
    
    // API fetch item by ID request example
    func get(_ request: Request) throws -> Future<WorkItemEvent> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = WorkItemEvent.find(modelID, on: request).unwrap(or: NotFound())
        return model
    }
    
    // API create item request example
    func create(_ request: Request) throws -> Future<WorkItemEvent> {
        let model = try request.content.decode(WorkItemEvent.self)
        return model.create(on: request)
    }
    
    // API update item request example
    func update(_ request: Request) throws -> Future<WorkItemEvent> {
        let model = try request.content.decode(WorkItemEvent.self)
        return model.update(on: request)
    }
    
    // API delete item request example
    func delete(_ request: Request) throws -> Future<WorkItemEvent> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = WorkItemEvent.find(modelID, on: request).unwrap(or: NotFound())
        return model.delete(on: request)
    }
//
//    func getImage(_ request: Request) throws -> Future<String> {
//        let modelID: Int = try request.parameters.next(Int.self)
//        let model = WorkItemEvent.find(modelID, on: request).unwrap(or: NotFound())
//        let imageString = model.map { event -> String in
//            guard let imageString = event.imageString else { return "" }
//            return "data:image/jpeg;base64,\(imageString)"
//        }
//        return imageString
//    }
}
