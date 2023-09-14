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
        case date = "date_created"
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
    static let data2: [String: Any] = [
        Message.CodingKeys.id.rawValue: "foheaoh892378743ofuhoeauhau",
        Message.CodingKeys.fromId.rawValue: "oVbS9qDAccXS0aqwHtWXvCYfGv62",
        Message.CodingKeys.content.rawValue: "When do you want to?",
        Message.CodingKeys.date.rawValue: Date()
    ]
    static let data3: [String: Any] = [
        Message.CodingKeys.id.rawValue: "foheaohofuhoea4348487uhau",
        Message.CodingKeys.fromId.rawValue: "eifjoifjoiejoijefoijfeos",
        Message.CodingKeys.content.rawValue: "How's tomorrow?",
        Message.CodingKeys.date.rawValue: Date()
    ]
    
    static let data4: [String: Any] = [
        Message.CodingKeys.id.rawValue: "foh4938747eaohofuhoeauhau",
        Message.CodingKeys.fromId.rawValue: "oVbS9qDAccXS0aqwHtWXvCYfGv62",
        Message.CodingKeys.content.rawValue: "Sure",
        Message.CodingKeys.date.rawValue: Date()
    ]
    
    static let data5: [String: Any] = [
        Message.CodingKeys.id.rawValue: "f449874987oheaohofuhoea4348487uhau",
        Message.CodingKeys.fromId.rawValue: "eifjoifjoiejoijefoijfeos",
        Message.CodingKeys.content.rawValue: "where do you want to go?",
        Message.CodingKeys.date.rawValue: Date()
    ]
    
    static let data6: [String: Any] = [
        Message.CodingKeys.id.rawValue: "foh4938747eaoho3635485fuhoeauhau",
        Message.CodingKeys.fromId.rawValue: "oVbS9qDAccXS0aqwHtWXvCYfGv62",
        Message.CodingKeys.content.rawValue: "The Loop!",
        Message.CodingKeys.date.rawValue: Date()
    ]
    static let demo = Message(data: data)
    static let demo2 = Message(data: data2)
    static let demo3 = Message(data: data3)
    static let demo4 = Message(data: data4)
    static let demo5 = Message(data: data5)
    static let demo6 = Message(data: data6)
}


struct RecentMessage: Identifiable, Hashable, Codable {
    let id: String
    let fromId: String
    let toId: String
    let date: Date
    let content: String
    let profileUrl: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case content
        case date = "date_created"
        case profileUrl = "profile_url"
        case displayName = "display_Name"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(data: [String: Any]) {
        self.id = data[RecentMessage.CodingKeys.id.rawValue] as? String ?? ""
        self.fromId = data[RecentMessage.CodingKeys.fromId.rawValue] as? String ?? ""
        self.toId = data[RecentMessage.CodingKeys.toId.rawValue] as? String ?? ""
        self.content = data[RecentMessage.CodingKeys.content.rawValue] as? String ?? ""
        let time = data[RecentMessage.CodingKeys.date.rawValue] as? Timestamp
        self.date = time?.dateValue() ?? Date()
        self.profileUrl = data[RecentMessage.CodingKeys.profileUrl.rawValue] as? String ?? ""
        self.displayName = data[RecentMessage.CodingKeys.displayName.rawValue] as? String ?? ""
       }
    
    
    static let data: [String: Any] = [
        RecentMessage.CodingKeys.id.rawValue: "eifjoifjoiejoijefoijfeos",
        RecentMessage.CodingKeys.fromId.rawValue: "oyda5lEqnnt4dqqUr8oV",
        RecentMessage.CodingKeys.content.rawValue: "When can I come over?",
        RecentMessage.CodingKeys.date.rawValue: Date(),
        RecentMessage.CodingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2Foyda5lEqnnt4dqqUr8oV%2F5-min.jpg?alt=media&token=781a7ed9-c9ff-4b89-94f9-ee1f52254f8c",
        RecentMessage.CodingKeys.displayName.rawValue: "Cinquain"
    ]
    
    static let data2: [String: Any] = [
        RecentMessage.CodingKeys.id.rawValue: "oyda5lEqnnt4dqqUr8oV",
        RecentMessage.CodingKeys.fromId.rawValue: "wHlDbRkHtUnlbX5g6PgN",
        RecentMessage.CodingKeys.content.rawValue: "When we leaving to the lounge",
        RecentMessage.CodingKeys.date.rawValue: Date(),
        RecentMessage.CodingKeys.profileUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FwHlDbRkHtUnlbX5g6PgN%2F7-min.jpg?alt=media&token=6ddfed73-025a-4d76-b0b7-ea6f458a2fd0",
        RecentMessage.CodingKeys.displayName.rawValue: "Amanda"
    ]
    
    static let demo = RecentMessage(data: data)
    static let demo2 = RecentMessage(data: data2)

}
