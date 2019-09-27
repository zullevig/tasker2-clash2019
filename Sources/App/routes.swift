import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { request in
        return "It works!"
    }
    
    // Basic "Hello, world!" parameter example
    router.get("hello") { request in
        return "Hello, world!"
    }
    
    // MARK: - API Examples
    
    // API fetch all request example
    router.get("testmodel") { request -> Future<[TestModel]> in
        let models = TestModel.query(on: request).all()
        return models
    }

    // API fetch item by ID request example
    router.get("testmodel", Int.parameter) { request -> Future<TestModel> in
        let modelID: Int = try request.parameters.next(Int.self)
        let model = TestModel.find(modelID, on: request).unwrap(or: NotFound())
        return model
    }

    // API create item request example
    router.post("testmodel") { request -> Future<TestModel> in
        let model = try request.content.decode(TestModel.self)
        return model.create(on: request)
    }
    
    // API update item request example
    router.post("testmodel", "update") { request -> Future<TestModel> in
        let model = try request.content.decode(TestModel.self)
        return model.update(on: request)
    }

    // API delete item request example
    router.delete("testmodel", Int.parameter) { request -> Future<TestModel> in
        let modelID: Int = try request.parameters.next(Int.self)
        let model = TestModel.find(modelID, on: request).unwrap(or: NotFound())
        return model.delete(on: request)
    }

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
