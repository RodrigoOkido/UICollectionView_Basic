//
//  MusicCollectionDetailsViewController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 21/06/21.
//

import UIKit

class MusicCollectionDetailsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyStateContainerView: UIView!
    @IBOutlet private weak var emptyStateImageFrameView: UIView!
    @IBOutlet private weak var emptyStateTitleLabel: UILabel!
    @IBOutlet private weak var emptyStateDescriptionLabel: UILabel!
    @IBOutlet private weak var emptyStateCreatedDateLabel: UILabel!
    @IBOutlet private weak var miniPlayerView: MiniPlayerView!
    
    var service: MusicService!
    var musicCollection: MusicCollection!
    
    // [scroll] segue name
//    static let albumInfoSegueID: String = "AlbumInfo"
    static let albumInfoSegueID: String = "AlbumInfo-Scroll"
    static let playerSegueID: String = "Player"
    static let libraryCollectionHeaderCellID: String = "LibraryCollectionHeader"
    static let musicCellID: String = "MusicCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(musicCollection != nil, "You should pass a collection to be displayed by this controller.")
        
        navigationItem.title = musicCollection.title
        
        if musicCollection.type == .album {
            let action = UIAction { _ in
                self.performSegue(withIdentifier: Self.albumInfoSegueID, sender: nil)
            }
            
            let infoItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "info.circle"), primaryAction: action, menu: nil)
            navigationItem.rightBarButtonItem = infoItem
        }
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "MusicCell", bundle: .main), forCellReuseIdentifier: Self.musicCellID)
        tableView.dataSource = self
        tableView.delegate = self
        
        if musicCollection.supportsEdition {
            // configure expecting we need to present an empty state
            emptyStateImageFrameView.layer.borderWidth = 1
            emptyStateImageFrameView.layer.borderColor = UIColor(named: "disabled")?.cgColor
            emptyStateImageFrameView.layer.cornerRadius = 8
            emptyStateTitleLabel.text = musicCollection.title
            emptyStateDescriptionLabel.text = "\(musicCollection.type.title) by \(musicCollection.mainPerson)"
            
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            emptyStateCreatedDateLabel.text = "Created \(formatter.string(from: musicCollection.referenceDate))"
        }
        
        miniPlayerView.service = service
        miniPlayerView.updateState()
        
        updateEmptyState()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Self.albumInfoSegueID {
            // [scroll] view controller type
//            let destination = segue.destination as? AlbumInfoViewController
            let destination = segue.destination as? AlbumInfoScrollViewController
            destination?.album = musicCollection
            destination?.service = service
        } else if segue.identifier == Self.playerSegueID {
            let destination = segue.destination as? PlayerViewController
            destination?.service = service
            destination?.presentationController?.delegate = self
        }
    }
    
    // MARK: -
    
    @IBAction private func didTapMiniPlayer(_ sender: UITapGestureRecognizer) {
        if service.queue.nowPlaying != nil {
            performSegue(withIdentifier: Self.playerSegueID, sender: nil)
        }
    }
    
    private func removeFromPlaylist(musicAt index: Int) {
        let music = musicCollection.musics[index]
        service.removeMusic(music, from: musicCollection)
        musicCollection = service.getCollection(id: musicCollection.id)
        
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index + 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        tableView.isHidden = musicCollection.musics.isEmpty
        emptyStateContainerView.isHidden = !musicCollection.musics.isEmpty
    }
}

// MARK: - UITableViewDataSource
extension MusicCollectionDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicCollection.musics.count + 1 // +1 for header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.libraryCollectionHeaderCellID, for: indexPath) as! LibraryCollectionHeaderCell
            
            let collectionCoverImage = service.getCoverImage(forItemIded: musicCollection.id)
            cell.configure(musicCollection: musicCollection, coverImage: collectionCoverImage)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.musicCellID, for: indexPath) as! MusicCell
            
            let music = musicCollection.musics[indexPath.row - 1]
            let musicCoverImage = service.getCoverImage(forItemIded: music.id)
            let musicIsFavorite = service.favoriteMusics.contains(music)
            cell.configure(music: music, coverImage: musicCoverImage, isFavorite: musicIsFavorite)
            cell.delegate = self
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MusicCollectionDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row != 0 else { return }
        
        let music = musicCollection.musics[indexPath.row - 1]
        service.startPlaying(collection: musicCollection, at: music)
        
        performSegue(withIdentifier: Self.playerSegueID, sender: nil)
        miniPlayerView.updateState()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard musicCollection.supportsEdition, indexPath.row != 0 else {
            return nil
        }
        
        let removeFromPlaylistAction = UIContextualAction(style: .destructive, title: "Remove") { _, _, completion in
            self.removeFromPlaylist(musicAt: indexPath.row - 1)
            completion(true)
        }
        
        removeFromPlaylistAction.image = UIImage(systemName: "trash.fill")
        removeFromPlaylistAction.backgroundColor = UIColor(named: "red")
        
        let configuration = UISwipeActionsConfiguration(actions: [removeFromPlaylistAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - MusicCellDelegate
extension MusicCollectionDetailsViewController: MusicCellDelegate {
    func toggleFavorite(music: Music) {
        let isFavorite = service.favoriteMusics.contains(music)
        service.toggleFavorite(music: music, isFavorite: !isFavorite)
        tableView.reloadData()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension MusicCollectionDetailsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        tableView.reloadData()
    }
}
