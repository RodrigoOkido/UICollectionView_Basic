//
//  MusicCell.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 22/06/21.
//

import UIKit

protocol MusicCellDelegate: AnyObject {
    func toggleFavorite(music: Music)
}

class MusicCell: UITableViewCell {
    
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var musicNameLabel: UILabel!
    @IBOutlet private weak var musicArtistLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    weak var delegate: MusicCellDelegate?
    private var music: Music?
    
    func configure(music: Music, coverImage: UIImage?, isFavorite: Bool) {
        self.music = music
        
        coverImageView.image = coverImage
        musicNameLabel.text = music.title
        musicArtistLabel.text = music.artist
        favoriteButton.isSelected = isFavorite
    }
    
    @IBAction private func didTapFavoriteButton(_ sender: UIButton) {
        if let music = self.music {
            delegate?.toggleFavorite(music: music)
        }
    }
}
