//
//  Guest.swift
//  Reunionly
//
//  Created by Terrence Pledger on 1/6/25.
//


import Foundation

struct Guest: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var mealPreference: String
    var type: String
    
    init(name: String, mealPreference: String, type: String) {
        self.name = name
        self.mealPreference = mealPreference
        self.type = type
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let mealPreference = dictionary["mealPreference"] as? String,
              let type = dictionary["type"] as? String else {
            return nil
        }
        self.name = name
        self.mealPreference = mealPreference
        self.type = type
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "mealPreference": mealPreference,
            "type": type
        ]
    }
}

