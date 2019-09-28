import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // MARK: - Object API with Controller
    let objectController = ObjectController()
    router.get("object", use: objectController.list)
    router.get("object", Int.parameter, use: objectController.get)
    router.post("object", use: objectController.create)
    router.post("object", "update", use: objectController.update)
    router.delete("object", Int.parameter, use: objectController.delete)
    
    // MARK: - CueItem API with Controller
    let cueItemController = CueItemController()
    router.get("cueitem", use: cueItemController.list)
    router.get("cueitem", Int.parameter, use: cueItemController.get)
    router.post("cueitem", use: cueItemController.create)
    router.post("cueitem", "update", use: cueItemController.update)
    router.delete("cueitem", Int.parameter, use: cueItemController.delete)
    
    // MARK: - WorkItem API with Controller
    let workItemController = WorkItemController()
    router.get("workitem", use: workItemController.list)
    router.get("workitem", Int.parameter, use: workItemController.get)
    router.get("workitem", Int.parameter, "dependencies", use: workItemController.listDependencies)
    router.get("workitem", Int.parameter, "outputs", use: workItemController.listOutputs)
    router.get("workitem", Int.parameter, "ingredients", use: workItemController.listIngredients)
    router.get("workitem", Int.parameter, "cueitems", use: workItemController.listCueItems)
    router.post("workitem", use: workItemController.create)
    router.post("workitem", "update", use: workItemController.update)
    router.delete("workitem", Int.parameter, use: workItemController.delete)
    
    // MARK: - Job API with Controller
    let jobController = JobController()
    router.get("job", use: jobController.list)
    router.get("job", Int.parameter, use: jobController.get)
    router.get("job", Int.parameter, "workitems", use: jobController.listWorkItems)
        router.post("job", use: jobController.create)
    router.post("job", "update", use: jobController.update)
    router.delete("job", Int.parameter, use: jobController.delete)

    // MARK: - WorkItemEvent API with Controller
    let workItemEventController = WorkItemEventController()
    router.get("workitem-event", use: workItemEventController.list)
    router.get("workitem-event", Int.parameter, use: workItemEventController.get)
    router.post("workitem-event", use: workItemEventController.create)
    router.post("workitem-event", "update", use: workItemEventController.update)
    router.delete("workitem-event", Int.parameter, use: workItemEventController.delete)
    router.get("workitem-event", "reset", use: workItemEventController.reset)

    let eventWebController = EventWebController()
    router.get("workitem-event-view", use: eventWebController.list)
    router.get("workitem-event-view-zoom", Int.parameter, use: eventWebController.zoom)

    // MARK: - JobEvent API with Controller
    let jobEventController = JobEventController()
    router.get("job-event", use: jobEventController.list)
    router.get("job-event", Int.parameter, use: jobEventController.get)
    router.post("job-event", use: jobEventController.create)
    router.post("job-event", "update", use: jobEventController.update)
    router.delete("job-event", Int.parameter, use: jobEventController.delete)
    
    
    // Basic "It works" example
    router.get { request in
        return "It works!"
    }
    
    // Basic "Hello, world!" parameter example
    router.get("hello") { request in
        return "Hello, world!"
    }
    
    // MARK: - API with Controller Examples
    let testModelAPIController = TestModelController()
    // API fetch all request example
    router.get("testmodel", use: testModelAPIController.list)
    // API fetch item by ID request example
    router.get("testmodel", Int.parameter, use: testModelAPIController.getModel)
    // API create item request example
    router.post("testmodel", use: testModelAPIController.create)    
    // API update item request example
    router.post("testmodel", "update", use: testModelAPIController.update)
    // API delete item request example
    router.delete("testmodel", Int.parameter, use: testModelAPIController.delete)

    // MARK: - Web Interface Examples

    // Web present all request example
    router.get("testweb") { request -> Future<View> in
        return TestModel.query(on: request).all().flatMap { results in
            let data = ["testlist": results]
            return try request.view().render("testview", data)
        }
    }
    
    // Web form post new item example
    router.post("testweb") { request in
        return try request.content.decode(TestModel.self).flatMap { item in
            return item.save(on: request).map { _ in
                return request.redirect(to: "testweb")
            }
        }
    }
}

