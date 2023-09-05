//
//  Message.swift
//  CityXcape
//
//  Created by James Allan on 9/5/23.
//

import Foundation
import FirebaseFirestore


struct Message: Identifiable, Hashable, Codable {
    let id: String
    let fromId: String
    let toId: String
    let content: String
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case content
        case date
    }
    
    init(data: [String: Any]) {
        self.id = data[Message.CodingKeys.id.rawValue] as? String ?? ""
        self.fromId = data[Message.CodingKeys.fromId.rawValue] as? String ?? ""
        self.toId = data[Message.CodingKeys.toId.rawValue] as? String ?? ""
        self.content = data[Message.CodingKeys.content.rawValue] as? String ?? ""
        let timestamp = data[Message.CodingKeys.date.rawValue] as? Timestamp
        self.date = timestamp?.dateValue() ?? Date()
    }
    
    static let data: [String: Any] = [
        Message.CodingKeys.id.rawValue: "foheaohofuhoeauhau",
        Message.CodingKeys.fromId.rawValue: "eifjoifjoiejoijefoijfeos",
        Message.CodingKeys.content.rawValue: "When we leaving to the lounge",
        Message.CodingKeys.date.rawValue: Date()
    ]
    
    static let demo = Message(data: data)
}
