//
//  FavoritesViewController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 21/06/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var emptyStateIconImageView: UIImageView!
    @IBOutlet private weak var emptyStateTitleLabel: UILabel!
    @IBOutlet private weak var emptyStateDescriptionLabel: UILabel!
    @IBOutlet private weak var miniPlayerView: MiniPlayerView!
    
    @IBOutlet private weak var emptyStateCenterConstraint: NSLayoutConstraint!
    
    var service: MusicService!
    
    private var allFavorites: [Music] {
        service.favoriteMusics
    }
    
    private var visibleFavorites: [Music] = []
    private var searchQuery: String {
        navigationItem.searchController?.searchBar.text?.lowercased() ?? ""
    }
    
    static let playerSegueID: String = "Player"
    static let musicCellID: String = "MusicCell"
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        
        tableView.register(UINib(nibName: "MusicCell", bundle: .main), forCellReuseIdentifier: Self.musicCellID)
        tableView.dataSource = self
        tableView.delegate = self
        
        // search
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // keyboard
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // mini player
        miniPlayerView.service = service
        miniPlayerView.updateState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
        miniPlayerView.updateState()
    }
    
    // MARK: UI state
    
    private func updateUI() {
        let newVisible: [Music]
        if searchQuery.isEmpty {
            newVisible = allFavorites
        } else {
            newVisible = allFavorites.filter {
                $0.title.lowercased().contains(searchQuery)
                    || $0.artist.lowercased().contains(searchQuery)
            }
        }
        
        guard newVisible != visibleFavorites else {
            return
        }
        
        visibleFavorites = newVisible
        updateEmptyState()
        tableView.reloadData()
    }
    
    private func updateEmptyState() {
        tableView.isHidden = visibleFavorites.isEmpty
        emptyStateView.isHidden = !visibleFavorites.isEmpty
        
        if searchQuery.isEmpty {
            emptyStateIconImageView.isHidden = false
            emptyStateTitleLabel.isHidden = false
            emptyStateDescriptionLabel.text = "Save the musics you like and\ncome back here to access them."
        } else {
            emptyStateIconImageView.isHidden = true
            emptyStateTitleLabel.isHidden = true
            emptyStateDescriptionLabel.text = "No results\nTry with a different search query."
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Self.playerSegueID {
            let destination = segue.destination as? PlayerViewController
            destination?.service = service
            destination?.presentationController?.delegate = self
        }
    }
    
    @IBAction private func didTapMiniPlayer(_ sender: UITapGestureRecognizer) {
        if service.queue.nowPlaying != nil {
            performSegue(withIdentifier: Self.playerSegueID, sender: nil)
        }
    }
    
    // MARK: Keyboard
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        let frameEnd = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue ?? NSValue(cgRect: .zero)
        
        let tableViewFrame = view.convert(tableView.frame, to: UIApplication.shared.windows.first)
        let intersection = tableViewFrame.intersection(frameEnd.cgRectValue)
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: intersection.height, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        emptyStateCenterConstraint.constant = insets.bottom / 2
        
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.musicCellID, for: indexPath) as! MusicCell
        
        let music = visibleFavorites[indexPath.row]
        let coverImage = service.getCoverImage(forItemIded: music.id)
        cell.configure(music: music, coverImage: coverImage, isFavorite: true)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let music = visibleFavorites[indexPath.row]
        
        // two options
        
        // 1: play just the selected music (good to see an empty queue)
        service.startPlaying(music: music)
        
        // 2: play all favorite musics as a collection (will also add suggestions to the queue)
//        let favoritesCollection = MusicCollection(
//            id: "favorites",
//            title: "Favorites",
//            mainPerson: "You",
//            referenceDate: Date(),
//            musics: service.favoriteMusics,
//            type: .playlist,
//            albumDescription: nil,
//            albumArtistDescription: nil)
//        service.startPlaying(collection: favoritesCollection, at: music)
        
        performSegue(withIdentifier: Self.playerSegueID, sender: nil)
    }
}

// MARK: - MusicCellDelegate
extension FavoritesViewController: MusicCellDelegate {
    func toggleFavorite(music: Music) {
        service.toggleFavorite(music: music, isFavorite: false)
        updateUI()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension FavoritesViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        updateUI()
        miniPlayerView.updateState()
    }
}

// MARK: - UISearchResultsUpdating
extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateUI()
    }
}
