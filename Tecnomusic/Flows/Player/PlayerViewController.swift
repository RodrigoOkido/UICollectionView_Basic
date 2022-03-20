//
//  PlayerViewController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 22/06/21.
//

import UIKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    static var queueSegueID: String = "Queue"
    
    var service: MusicService!
    private var queue: Queue {
        service.queue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(service != nil, "You should pass a service for this controller.")
        
        configureUI()
    }
    
    private func configureUI() {
        guard let music = queue.nowPlaying else { return }
        
        coverImageView.image = service.getCoverImage(forItemIded: music.id)
        titleLabel.text = music.title
        artistLabel.text = music.artist
        favoriteButton.isSelected = service.favoriteMusics.contains(music)
        updateCurrentTimeLabel()
        durationLabel.text = Self.durationFormatter.string(from: music.length)
    }
    
    // MARK: Time formatting
    
    static var durationFormatter: DateComponentsFormatter = {
        let dcf = DateComponentsFormatter()
        dcf.unitsStyle = .positional
        dcf.allowedUnits = [.hour, .minute, .second]
        return dcf
    }()
    
    static var lessThanOneMinuteDurationFormatter: DateComponentsFormatter = {
        let dcf = DateComponentsFormatter()
        dcf.unitsStyle = .positional
        dcf.allowedUnits = [.minute, .second]
        dcf.zeroFormattingBehavior = .pad
        return dcf
    }()
    
    private func updateCurrentTimeLabel() {
        guard let music = queue.nowPlaying else { return }
        
        let seconds = music.length * Double(seekSlider.value)
        let formatter = seconds < 60 ? Self.lessThanOneMinuteDurationFormatter : Self.durationFormatter
        let timeText = formatter.string(from: seconds) ?? "0:00"
        currentTimeLabel.text = timeText.hasPrefix("00") ? String(timeText.dropFirst()) : timeText
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Self.queueSegueID {
            let destination = segue.destination as? QueueViewController
            destination?.service = service
            destination?.delegate = self
        }
    }
    
    // MARK: Actions
    
    @IBAction private func didTapQueueButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Self.queueSegueID, sender: nil)
    }
    
    @IBAction private func didTapFavoriteButton(_ sender: UIButton) {
        if let music = queue.nowPlaying {
            sender.isSelected.toggle()
            service.toggleFavorite(music: music, isFavorite: sender.isSelected)
        }
    }
    
    @IBAction private func didSeek(_ sender: UISlider) {
        updateCurrentTimeLabel()
    }
    
    @IBAction private func didTapPlayPauseButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

// MARK: - QueueViewControllerDelegate
extension PlayerViewController: QueueViewControllerDelegate {
    func willDismiss() {
        configureUI()
    }
}
