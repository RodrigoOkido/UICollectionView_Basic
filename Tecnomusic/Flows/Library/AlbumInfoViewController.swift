//
//  AlbumInfoViewController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 21/06/21.
//

import UIKit

class AlbumInfoViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var service: MusicService!
    var album: MusicCollection!
    
    static let albumAboutHeaderCellID: String = "AlbumAboutHeader"
    static let albumAboutArtistCellID: String = "AlbumAboutArtist"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(service != nil, "You should provide an instance of the service for this controller.")
        assert(album.type == .album, "This controller only supports presenting album infos.")
        
        tableView.dataSource = self
    }
    
    // MARK: Actions
    
    @IBAction private func didTapCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AlbumInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.albumAboutHeaderCellID, for: indexPath) as! AlbumAboutHeaderCell
            
            let coverImage = service.getCoverImage(forItemIded: album.id)
            cell.configure(album: album, coverImage: coverImage)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Self.albumAboutArtistCellID, for: indexPath) as! AlbumAboutArtistCell
            cell.configure(album: album)
            return cell
        }
    }
}
