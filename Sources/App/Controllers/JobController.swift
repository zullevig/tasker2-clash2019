import Vapor

final class JobController {
    // API fetch all request example
    func list(_ request: Request) throws -> Future<[Job]> {
        let models = Job.query(on: request).all()
        return models
    }
    
    // API fetch item by ID request example
    func get(_ request: Request) throws -> Future<Job> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = Job.find(modelID, on: request).unwrap(or: NotFound())
        return model
    }
    
    func listWorkItems(_ request: Request) throws -> Future<[WorkItem]> {
        let jobID: Int = try request.parameters.next(Int.self)
        return Job.find(jobID, on: request).flatMap(to: [WorkItem].self)  { job in
            guard let unwrappedJob = job else { throw Abort.init(HTTPStatus.notFound) }
            let workItems = try unwrappedJob.workItems.query(on: request).all()
            return workItems
        }
    }

    // API create item request example
    func create(_ request: Request) throws -> Future<Job> {
        let model = try request.content.decode(Job.self)
        return model.create(on: request)
    }
    
    // API update item request example
    func update(_ request: Request) throws -> Future<Job> {
        let model = try request.content.decode(Job.self)
        return model.update(on: request)
    }
    
    // API delete item request example
    func delete(_ request: Request) throws -> Future<Job> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = Job.find(modelID, on: request).unwrap(or: NotFound())
        return model.delete(on: request)
    }
}
