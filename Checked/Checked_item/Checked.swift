//
//  ToDoListItem.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import Foundation

struct Checked: Codable, Identifiable {
    let id: String
    var title: String
    var notes: String
    var dueDate: TimeInterval
    let createdDate: TimeInterval
    var isDone: Bool
    var isPinned: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
    
    mutating func setPinned(_ state: Bool) {
        isPinned = state
    }
}

