import Vapor

final class JobEventController {
    // API fetch all request example
    func list(_ request: Request) throws -> Future<[JobEvent]> {
        let models = JobEvent.query(on: request).all()
        return models
    }
    
    // API fetch item by ID request example
    func get(_ request: Request) throws -> Future<JobEvent> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = JobEvent.find(modelID, on: request).unwrap(or: NotFound())
        return model
    }
    
    // API create item request example
    func create(_ request: Request) throws -> Future<JobEvent> {
        let model = try request.content.decode(JobEvent.self)
        return model.create(on: request)
    }
    
    // API update item request example
    func update(_ request: Request) throws -> Future<JobEvent> {
        let model = try request.content.decode(JobEvent.self)
        return model.update(on: request)
    }
    
    // API delete item request example
    func delete(_ request: Request) throws -> Future<JobEvent> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = JobEvent.find(modelID, on: request).unwrap(or: NotFound())
        return model.delete(on: request)
    }
}
