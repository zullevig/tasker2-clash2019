//
//  Models.swift
//  Tasker
//
//  Created by Steve Sparks on 9/25/19.
//  Copyright © 2019 Big Nerd Ranch. All rights reserved.
//

import Foundation

enum TaskError: Error {
    case illegalState
}

enum CompletionCondition: Int, Codable {
    case affirm
    case qrCodeRead
    case nfcTagRead
    case objectRecognized
    
    static let `default` = affirm
}

// state machine for an item of work.
enum WorkState: Int, Codable {
    case unknown
    case notReady // dependencies not met
    case ready
    case inProgress
    case completed
    case cancelled
}


indirect enum WorkItemDuration: Codable {
    case unknown
    
    // "rise for one hour"
    // It's okay to let it rise for 50 minutes or even zero if you want lousy bread.
    case softMinimumTime(TimeInterval)
    
    // "let cure 24 hours"
    // this time must be made to expire.
    case hardMinimumTime(TimeInterval)
    
    // "let ferment 30-60 days"
    // one minimum, one maximum
    case window(WorkItemDuration, WorkItemDuration)
    
    // "pizza dough is good for 3 days"
    case softMaximumTime(TimeInterval)
    
    // "cat must be fed every day"
    case hardMaximumTime(TimeInterval)
    
    // No time limit. "Once plate is in place, tighten the bolt."
    case completionConditionMet
    
    enum CodingKeys: String, CodingKey {
        case type, value, otherValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .unknown:
            break
        case .softMinimumTime(let val):
            try container.encode("softMinimumTime", forKey: .type)
            try container.encode(val, forKey: .value)
        case .hardMinimumTime(let val):
            try container.encode("hardMinimumTime", forKey: .type)
            try container.encode(val, forKey: .value)
        case .window(let val1, let val2):
            try container.encode("window", forKey: .type)
            try container.encode(val1, forKey: .value)
            try container.encode(val2, forKey: .otherValue)
        case .softMaximumTime(let val):
            try container.encode("softMaximumTime", forKey: .type)
            try container.encode(val, forKey: .value)
        case .hardMaximumTime(let val):
            try container.encode("hardMaximumTime", forKey: .type)
            try container.encode(val, forKey: .value)
        case .completionConditionMet:
            try container.encode("completionConditionMet", forKey: .type)
            try container.encode(0, forKey: .value)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typ = try container.decode(String.self, forKey: .type)
        switch typ {
        case "softMinimumTime":
            let val = try container.decode(TimeInterval.self, forKey: .value)
            self = .softMinimumTime(val)
        case "hardMinimumTime":
            let val = try container.decode(TimeInterval.self, forKey: .value)
            self = .hardMinimumTime(val)
        case "softMaximumTime":
            let val = try container.decode(TimeInterval.self, forKey: .value)
            self = .softMaximumTime(val)
        case "hardMaximumTime":
            let val = try container.decode(TimeInterval.self, forKey: .value)
            self = .hardMaximumTime(val)
        case "completionConditionMet":
            self = .completionConditionMet
        case "window":
            let val1 = try container.decode(WorkItemDuration.self, forKey: .value)
            let val2 = try container.decode(WorkItemDuration.self, forKey: .value)
            self = .window(val1, val2)
        default:
            self = .unknown //preconditionFailure("Never meant a thing to me")
        }
    }
}

final class Object: Codable {
    var id: Int?
    var workItemIngredientID: Int?
    var workItemOutputID: Int?
    var name: String
    var uniqueIdentifier: UUID
    init(_ name: String, _ uuid: UUID = UUID()) {
        self.name = name
        self.uniqueIdentifier = uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case id, workItemIngredientID, workItemOutputID, name, uniqueIdentifier
    }
}

final class CueItem: Codable {
    enum DataType: Int, Codable {
        case nfcData
        case qrData
        case utf8String
        case arObject
        case unknown
    }
    
    var id: Int?
    var workItemID: Int?
    var data: Data?
    var type: DataType = .unknown
    
    enum CodingKeys: String, CodingKey {
        case id, workItemID, data, type
    }
}

final class WorkItem: Codable {
    var id: Int?
    var jobID: Int?
    var workItemID: Int?
    var description: String
    var detailedInstruction: String
    var completionCondition: CompletionCondition
    
    var duration: WorkItemDuration
    var state: WorkState = .unknown
    
    enum CodingKeys: String, CodingKey {
        case id, jobID, workItemID, description, detailedInstruction, completionCondition, duration, state
    }
    
    init(description: String, detailedInstruction: String, dependencies: [WorkItem] = [], completionCondition: CompletionCondition = .default) {
        self.description = description
        self.detailedInstruction = detailedInstruction
        self.completionCondition = completionCondition
        self.duration = .completionConditionMet
        let unmet = dependencies.filter { $0.state != .completed }
        self.state = unmet.isEmpty ? .ready : .notReady
    }
}

struct Job: Codable {
    var id: Int?
    var description: String
    var detailedInstruction: String
    
    enum CodingKeys: String, CodingKey {
        case id, description, detailedInstruction
    }
}

struct WorkItemEvent: Codable {
    var id: Int?
    var workItemId: Int
    var timestamp: TimeInterval
    var image: Data?
    var completionDetails: String
    var imageString: String?
    
    enum CodingKeys: String, CodingKey {
        case id, workItemId, timestamp, image, imageString, completionDetails
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int?.self, forKey: .id)
//        workItemId = try container.decode(Int.self, forKey: .workItemId)
//        timestamp = try container.decode(TimeInterval.self, forKey: .timestamp)
//        completionDetails = try container.decode(String.self, forKey: .completionDetails)
//
//        image = try? container.decode(Data.self, forKey: .image)
//        if let image = image {
//            imageString = image.base64EncodedString()
//        }
//        else {
//            imageString = nil
//        }
//    }
}

struct JobEvent: Codable {
    var id: Int?
    var jobId: Int
    var workItemIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, jobId, workItemIds
    }
}
