//
//  LibraryCollectionHeaderCell.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 22/06/21.
//

import UIKit

class LibraryCollectionHeaderCell: UITableViewCell {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var collectionTitleLabel: UILabel!
    @IBOutlet private weak var collectionSubtitleLabel: UILabel!
    @IBOutlet private weak var numberOfSongsLabel: UILabel!
    @IBOutlet private weak var referenceDateLabel: UILabel!
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        return df
    }()
    
    func configure(musicCollection: MusicCollection, coverImage: UIImage?) {
        coverImageView.image = coverImage
        collectionTitleLabel.text = musicCollection.title
        collectionSubtitleLabel.text = "\(musicCollection.type.title) by \(musicCollection.mainPerson)"
        
        let musicCount = musicCollection.musics.count
        numberOfSongsLabel.text = "\(musicCount) \(musicCount == 1 ? "song" : "songs")"
        
        let refDateLabel = musicCollection.type == .album ? "Released" : "Created"
        referenceDateLabel.text = "\(refDateLabel) \(Self.dateFormatter.string(from: musicCollection.referenceDate))"
    }
}
