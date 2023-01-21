//
//  String + Extencion.swift
//  Music
//
//  Created by Леонид Шелудько on 19.01.2023.
//

import Foundation

extension String {
    
    enum ValidTypes {
        case name
        case email
        case password
    }
    
    //Regex - регулярные выражения
    //строка образец с которой мы все сравниваем
    enum Regex: String {
        //Будет проверять есть ли [маленькие и БОЛЬШИЕ символы]{их колличество}(у нас укказано от 1 и дальше без огранич)
        case name = "[a-zA-Z]{1,}"
        case email = "[a-zA-Z0-9._]+@[a-zA-Z0-9]+\\.[a-zA-Z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"  //перевод: СООТВЕСТВУЕТ ЛИ
        var regex = ""
        
        switch validType {
        case .name:
            regex = Regex.name.rawValue
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
    
    
}
