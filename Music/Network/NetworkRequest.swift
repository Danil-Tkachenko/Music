//
//  NetworkRequest.swift
//  Music
//
//  Created by Леонид Шелудько on 20.01.2023.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    private init() {}
    
    //Создаём функцию которая нам должна вернуть какой то completion
    
    //Result<Data, Error> - y Result есть два состояние .failure и .success и получем либо - error, либо - data
    func reguestData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
         //Пробуем получть url из строки
        guard let url = URL(string: urlString) else { return }
        
        //Делем запрос
        URLSession.shared.dataTask(with: url) { data, response, error in
            //работаем в асинхронном режиме???
            DispatchQueue.main.async {
                //Если приходит ошибка 1) передаём в completion - error 2) выходим из метода
                if let error = error {
                    completion(.failure(error))
                    return
                }
                //Если ошибки нет - пытемся передть данные(data) через completion
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        //выполнить запрос
        .resume()
    }
}
