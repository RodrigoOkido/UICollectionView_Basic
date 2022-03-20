//
//  AlbumAboutHeaderCell.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 22/06/21.
//

import UIKit

class AlbumAboutHeaderCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var albumTitleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var aboutLabel: UILabel!
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        return df
    }()
    
    static var durationFormatter: DateComponentsFormatter = {
        let dcf = DateComponentsFormatter()
        dcf.unitsStyle = .abbreviated
        return dcf
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.setCustomSpacing(8, after: artistLabel)
        stackView.setCustomSpacing(0, after: durationLabel)
        stackView.setCustomSpacing(20, after: releaseDateLabel)
    }
    
    func configure(album: MusicCollection, coverImage: UIImage?) {
        coverImageView.image = coverImage
        albumTitleLabel.text = album.title
        artistLabel.text = album.mainPerson
        
        let musicCount = album.musics.count
        let totalTime = album.musics.map(\.length).reduce(0, +)
        let duration = Self.durationFormatter.string(from: totalTime) ?? ""
        durationLabel.text = "\(musicCount) \(musicCount == 1 ? "song" : "songs"), \(duration)"
        
        releaseDateLabel.text = "Released in \(Self.dateFormatter.string(from: album.referenceDate))"
        aboutLabel.text = album.albumDescription
    }
}
