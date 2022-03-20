//
//  AlbumAboutArtistCell.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 22/06/21.
//

import UIKit

class AlbumAboutArtistCell: UITableViewCell {
    
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    
    func configure(album: MusicCollection) {
        headerLabel.text = "About \(album.mainPerson)"
        aboutLabel.text = album.albumArtistDescription
    }
}
