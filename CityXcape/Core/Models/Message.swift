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
    let timestamp: Date
    let content: String
    let location: String?
    let spotId: String?
    let profileUrl: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case content
        case timestamp
        case location
        case spotId
        case profileUrl 
        case displayName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
    
    
    init(data: [String: Any]) {
        self.id = data[Message.CodingKeys.id.rawValue] as? String ?? ""
        self.fromId = data[Message.CodingKeys.fromId.rawValue] as? String ?? ""
        self.toId = data[Message.CodingKeys.toId.rawValue] as? String ?? ""
        self.content = data[Message.CodingKeys.content.rawValue] as? String ?? ""
        let time = data[Message.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = time?.dateValue() ?? Date()
        self.profileUrl = data[Message.CodingKeys.profileUrl.rawValue] as? String ?? ""
        self.displayName = data[Message.CodingKeys.displayName.rawValue] as? String ?? ""
        self.location = data[Message.CodingKeys.location.rawValue] as? String ?? nil
        self.spotId = data[Message.CodingKeys.spotId.rawValue] as? String ?? nil
       }

    
    
    static let data: [String: Any] = [
        Message.CodingKeys.id.rawValue: "eifjoifjoiejo797744ijefoijfeos",
        Message.CodingKeys.fromId.rawValue: "oyda5lEqnnt4dqqUr8oV",
        Message.CodingKeys.content.rawValue: "What you're in town for?",
        Message.CodingKeys.timestamp.rawValue: Date(timeIntervalSinceNow: 100000),
        Message.CodingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FwHlDbRkHtUnlbX5g6PgN%2F7-min.jpg?alt=media&token=6ddfed73-025a-4d76-b0b7-ea6f458a2fd0",
        Message.CodingKeys.displayName.rawValue: "Jessica"
    ]
    
    static let data2: [String: Any] = [
        Message.CodingKeys.id.rawValue: "oyda5lEqnnt4dqqUr9799979779978oV",
        Message.CodingKeys.fromId.rawValue: "wHlDbRkHtU9888998988nlbX5g6PgN",
        Message.CodingKeys.content.rawValue: "When we leaving to the lounge",
        Message.CodingKeys.timestamp.rawValue: Date(),
        Message.CodingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2F4wUh5lWK5YHR4IczOV3j%2F1-min.jpg?alt=media&token=ba1dae5d-5e13-4a32-b79c-7f8bcbbbee5a",
        Message.CodingKeys.displayName.rawValue: "Crystal",
    ]
    
    static let data3: [String: Any] = [
        Message.CodingKeys.id.rawValue: "eifjoi00598u085085fjoiej99y98y9898oijefoijfeos",
        Message.CodingKeys.fromId.rawValue: "oyda5lE9789777878qnnt4dqqUr8oV",
        Message.CodingKeys.content.rawValue: "I'm on my way right now",
        Message.CodingKeys.timestamp.rawValue: Date(timeIntervalSinceNow: 100000),
        Message.CodingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2Fpexels-mahdi-chaghari-13634600.jpg?alt=media&token=81e87218-43fa-4cd7-80ea-c556cde704d8",
        Message.CodingKeys.displayName.rawValue: "Amanda"
    ]
    
    static let data4: [String: Any] = [
        Message.CodingKeys.id.rawValue: "eifjoifjoie-8850985899809u509joijefoijfeos",
        Message.CodingKeys.fromId.rawValue: "oyda5l87878787Eqnnt4dqqUr8oV",
        Message.CodingKeys.content.rawValue: "I'm still at work",
        Message.CodingKeys.timestamp.rawValue: Date(timeIntervalSinceNow: 100000),
        Message.CodingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FW6EUJxka1OihhJ0Iyest%2F2-min.jpg?alt=media&token=1930940d-704f-42b1-aa2b-cd8c919b0161",
        Message.CodingKeys.displayName.rawValue: "Cinquain"
    ]
    
    static let demo = Message(data: data)
    static let demo2 = Message(data: data2)
    static let demo3 = Message(data: data3)
    static let demo4 = Message(data: data4)

}
