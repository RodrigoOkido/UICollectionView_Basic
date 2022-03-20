//
//  LibraryViewController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 21/06/21.
//

import UIKit

class LibraryViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var miniPlayerView: MiniPlayerView!
    
    var service: MusicService!
    private var collections: [MusicCollection] {
        service.loadLibrary()
    }
    
    static var musicCollectionDetailsSegueID: String = "MusicCollectionDetails"
    static var playerSegueID: String = "Player"
    static let libraryItemCellID: String = "LibraryItem"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 10
        
        tableView.dataSource = self
        tableView.delegate = self
        
        miniPlayerView.service = service
        miniPlayerView.updateState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        miniPlayerView.updateState()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Self.musicCollectionDetailsSegueID, let collection = sender as? MusicCollection {
            let destination = segue.destination as? MusicCollectionDetailsViewController
            destination?.musicCollection = collection
            destination?.service = service
        } else if segue.identifier == Self.playerSegueID {
            let destination = segue.destination as? PlayerViewController
            destination?.service = service
        }
    }
    
    @IBAction private func didTapMiniPlayer(_ sender: UITapGestureRecognizer) {
        if service.queue.nowPlaying != nil {
            performSegue(withIdentifier: Self.playerSegueID, sender: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collection = collections[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.libraryItemCellID, for: indexPath) as! LibraryItemCell
        cell.configure(musicCollection: collection, coverImage: service.getCoverImage(forItemIded: collection.id))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = collections[indexPath.row]
        performSegue(withIdentifier: Self.musicCollectionDetailsSegueID, sender: collection)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
