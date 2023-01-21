//
//  UserModel.swift
//  Music
//
//  Created by Леонид Шелудько on 19.01.2023.
//

import Foundation

struct User: Codable {
    let firstName: String
    let secondName: String
    let phone: String
    let email: String
    let password: String
    let age: Date
}
