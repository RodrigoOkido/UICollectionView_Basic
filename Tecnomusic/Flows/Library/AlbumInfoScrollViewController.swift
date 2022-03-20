//
//  AlbumInfoScrollViewController.swift
//  Tecnomusic
//
//  Created by Rafael Araujo on 22/09/21.
//

import Foundation

import UIKit

class AlbumInfoScrollViewController: UIViewController, UIScrollViewDelegate {
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var albumTitleLabel: UILabel!
    @IBOutlet private var artistLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var aboutAlbumLabel: UILabel!
    @IBOutlet private var aboutArtistHeaderLabel: UILabel!
    @IBOutlet private var aboutArtistLabel: UILabel!
    
    var service: MusicService!
    var album: MusicCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(service != nil, "You should provide an instance of the service for this controller.")
        assert(album.type == .album, "This controller only supports presenting album infos.")
        
        configureUI()
        
        scrollView.delegate = self
    }
    
    private func configureUI() {
        coverImageView.image = service.getCoverImage(forItemIded: album.id)
        albumTitleLabel.text = album.title
        artistLabel.text = album.mainPerson
        
        let musicCount = album.musics.count
        let totalTime = album.musics.map(\.length).reduce(0, +)
        let duration = Self.durationFormatter.string(from: totalTime) ?? ""
        durationLabel.text = "\(musicCount) \(musicCount == 1 ? "song" : "songs"), \(duration)"
        
        releaseDateLabel.text = "Released in \(Self.dateFormatter.string(from: album.referenceDate))"
        
        aboutAlbumLabel.text = album.albumDescription
        aboutArtistHeaderLabel.text = "About \(album.mainPerson)"
        aboutArtistLabel.text = album.albumArtistDescription
    }
    
    // MARK: Actions
    
    @IBAction private func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
