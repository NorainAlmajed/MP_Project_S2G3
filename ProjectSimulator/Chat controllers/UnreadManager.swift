//
//  UnreadManager.swift
//  ProjectSimulator
//
//  Created by zainab mahdi on 27/12/2025.
//

import Foundation

struct UnreadManager {

    static func increase(chatID: String) {
        let key = "unreadCount_\(chatID)"
        let current = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(current + 1, forKey: key)
    }

    static func reset(chatID: String) {
        UserDefaults.standard.set(0, forKey: "unreadCount_\(chatID)")
    }

    static func get(chatID: String) -> Int {
        UserDefaults.standard.integer(forKey: "unreadCount_\(chatID)")
    }
}
