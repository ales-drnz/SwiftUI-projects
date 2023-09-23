//
//  User.swift
//  ToDoList
//
//  Created by Alessandro Di Ronza on 09/07/23.
//

import Foundation

struct User: Codable {
    let ID: String
    let name: String
    let email: String
    let joined: TimeInterval
}
