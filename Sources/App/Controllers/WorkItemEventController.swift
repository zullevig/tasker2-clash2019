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
    
    func reset(_ request: Request) throws -> Future<HTTPStatus> {
        return WorkItemEvent.query(on: request).delete().map {
            return .ok
        }
    }
}
