//
//  LibraryItemCell.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 21/06/21.
//

import UIKit

class LibraryItemCell: UITableViewCell {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var collectionNameLabel: UILabel!
    @IBOutlet private weak var collectionDescriptionLabel: UILabel!
    
    func configure(musicCollection: MusicCollection, coverImage: UIImage?) {
        coverImageView.image = coverImage
        collectionNameLabel.text = musicCollection.title
        collectionDescriptionLabel.text = "\(musicCollection.type.title) · \(musicCollection.mainPerson)"
    }
}
