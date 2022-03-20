//
//  DiscoverModels.swift
//  Tecnomusic
//
//  Created by Rafael Araujo on 22/09/21.
//

import UIKit

typealias MusicStyle = (image: UIImage?, name: String)

enum Discover {
    enum Section {
        case musicStyles([MusicStyle])
        case musicCollections(title: String, items: [MusicCollection])
        case forYou(callout: String, items: [MusicCollection])
        case newRelease(album: MusicCollection, music: Music, artistImage: UIImage?)
    }
}

// MARK: - Mocks
extension Discover {
    static func buildMock(service: MusicService) -> [Section] {
        let library = service.loadLibrary()
        let listenAgainItems = (0..<5).compactMap { _ in library.randomElement() }
        let playlists = library.filter { $0.type == .playlist }
        
        var sections: [Section] = [
            .musicStyles([
                (UIImage(named: "pop"), "Pop"), (UIImage(named: "edm-forro"), "EDM Forró"),
                (UIImage(named: "rnb"), "R&B"), (UIImage(named: "edm"), "EDM")
            ]),
            .musicCollections(title: "Listen Again", items: listenAgainItems),
            .forYou(callout: "Automatic Playlists", items: playlists)
        ]
        
        // new release
        let albums = library.filter { $0.type == .album }
        if let album = albums.randomElement(), let music = album.musics.randomElement() {
            let artistImage = service.getCoverImage(forItemIded: album.id)
            sections.append(.newRelease(album: album, music: music, artistImage: artistImage))
        }
        
        return sections
    }
}
