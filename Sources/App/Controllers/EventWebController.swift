//
//  EventWebController.swift
//  App
//
//  Created by Zachary Ullevig on 9/26/19.
//

import Vapor

final class EventWebController {
    func list(_ request: Request) throws -> Future<View> {
        return WorkItemEvent.query(on: request).all().flatMap { results in
            var webData = results.map({ (event) -> WorkItemEventWeb in
                return WorkItemEventWeb(from: event)
            })
            webData.sort { $0.timestamp > $1.timestamp }
            let data = ["workitem-events": webData]
            return try request.view().render("workitem-event-view", data)
        }
    }

    func zoom(_ request: Request) throws -> Future<View> {
        let modelID: Int = try request.parameters.next(Int.self)
        let model = WorkItemEvent.find(modelID, on: request).map { (event) -> WorkItemEventWeb in
            return WorkItemEventWeb(from: event!)
        }
        let data = ["workitem-event": model]
        return try request.view().render("workitem-event-view-zoom", data)
    }
}
