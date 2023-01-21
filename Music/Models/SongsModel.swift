//
//  SongsModel.swift
//  Music
//
//  Created by Леонид Шелудько on 21.01.2023.
//

import Foundation

struct SongsMpdel: Decodable {
    var results: [Song]
}

struct Song: Decodable {
    //т.к в json вначале приходит информция об альбоме, и там нет названия трека, то будет опциональным
    let trackName: String?
}
