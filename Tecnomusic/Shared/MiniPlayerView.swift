//
//  MiniPlayerView.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 23/06/21.
//

import UIKit

class MiniPlayerView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "MiniPlayerView", bundle: .main)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(contentView)
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        self.contentView = contentView
    }
    
    var service: MusicService!
    
    func updateState() {
        if let music = service.queue.nowPlaying {
            coverImageView.image = service.getCoverImage(forItemIded: music.id)
            coverImageView.isHighlighted = false
            coverImageView.contentMode = .scaleAspectFill
            
            titleLabel.text = music.title
            artistLabel.text = music.artist
            playPauseButton.isEnabled = true
        } else {
            coverImageView.isHighlighted = true
            coverImageView.contentMode = .center
            
            titleLabel.text = "—"
            artistLabel.text = "—"
            playPauseButton.isSelected = false
            playPauseButton.isEnabled = false
        }
    }
    
    @IBAction private func didTapPlayPause(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
