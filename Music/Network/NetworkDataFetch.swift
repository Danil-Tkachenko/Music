//
//  NetworkDataFetch.swift
//  Music
//
//  Created by Леонид Шелудько on 20.01.2023.
//

import Foundation

class NetworkDataFetch {
    
    static let share = NetworkDataFetch()
    
    private init() {}
    
    //Обращаемся по url и получаем какой то ответ(responce)
    //Получаем либо AlbumModel?, либо Error?
    func fetchAlbum(urlString: String, responce: @escaping (AlbumModel?, Error?) -> Void) {
        //Обраащаемся к предидущему методу
        NetworkRequest.shared.reguestData(urlString: urlString) { result in
            //В result приходят 2 состояния - .success   .failure
            
            switch result {
            case .success(let data):
                do {
                    //Данные которые мы получаем пытаемся распарсить
                    let alboms = try JSONDecoder().decode(AlbumModel.self, from: data)
                    responce(alboms, nil) //nil второй потому что данные пришли и распарсились см.(AlbumModel?, Error?)
                } catch let jsonError {
                    //если код попадает сюда, значит мы не праильно пармися
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requsting data: \(error.localizedDescription)")
                responce(nil, error) //nil первый потому что ошибка см.(AlbumModel?, Error?)
            }
        }
    }
    
    
    func fetchSongs(urlString: String, responce: @escaping (SongsMpdel?, Error?) -> Void) {
        //Обраащаемся к предидущему методу
        NetworkRequest.shared.reguestData(urlString: urlString) { result in
            //В result приходят 2 состояния - .success   .failure
            
            switch result {
            case .success(let data):
                do {
                    //Данные которые мы получаем пытаемся распарсить
                    let alboms = try JSONDecoder().decode(SongsMpdel.self, from: data)
                    responce(alboms, nil) //nil второй потому что данные пришли и распарсились см.(AlbumModel?, Error?)
                } catch let jsonError {
                    //если код попадает сюда, значит мы не праильно пармися
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requsting data: \(error.localizedDescription)")
                responce(nil, error) //nil первый потому что ошибка см.(AlbumModel?, Error?)
            }
        }
    }
}
