//
//  UserDeaultsManager.swift
//  Music
//
//  Created by Леонид Шелудько on 19.01.2023.
//

import Foundation

class DataBase {
    
    static let shared = DataBase()
    
    enum SettingKeys: String {
        case users
        case activeUser
    }
    
    let defaults = UserDefaults.standard
    let userKey = SettingKeys.users.rawValue
    let activeUserKey = SettingKeys.activeUser.rawValue
    
    
    var users: [User] {
        get {
            //2) Декодируем информацию (расшифровываем)
            if let data = defaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        }
        set {
            //1) Закодируем информацию о пользователе
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }
    
    func saveUser(firstName: String, secondName: String, phone: String, email: String, pasword: String, age: Date) {
        
        let user = User(firstName: firstName, secondName: secondName, phone: phone, email: email, password: pasword, age: age)
        users.insert(user, at: 0) //insert - вставить в массив под индексом 0
    }
    
    var activeUsers: User? {
        get {
            //2) Декодируем информацию (расшифровываем)
            if let data = defaults.value(forKey: activeUserKey) as? Data {
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        set {
            //1) Закодируем информацию о пользователе
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: activeUserKey)
            }
        }
    }
    
    //Каждый раз будем перезаписывать юзера, чтобы запомнить введеные данные
    func saveActiveUser(user: User) {
        activeUsers = user
    }
}
