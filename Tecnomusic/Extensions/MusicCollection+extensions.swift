//
//  MusicCollection+extensions.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 21/06/21.
//

import Foundation

extension MusicCollection.MusicCollectionType {
    
    var title: String {
        switch self {
        case .album:
            return "Album"
        case .playlist:
            return "Playlist"
        }
    }
}
