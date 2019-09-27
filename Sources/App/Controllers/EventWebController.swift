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
            let data = ["workitem-events": results]
            results.map({ (event) -> String in
                print("Image String: \(event.imageString)")
                return ""
            })
            return try request.view().render("workitem-event-view", data)
        }
    }
}
