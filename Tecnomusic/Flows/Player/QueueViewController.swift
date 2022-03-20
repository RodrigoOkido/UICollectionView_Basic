//
//  QueueViewController.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 23/06/21.
//

import UIKit

protocol QueueViewControllerDelegate: AnyObject {
    func willDismiss()
}

class QueueViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    static var musicCellID: String = "MusicCell"
    
    weak var delegate: QueueViewControllerDelegate?
    var service: MusicService!
    
    private var queue: Queue {
        service.queue
    }
    
    typealias SectionModel = (title: String, musics: [Music])
    private var sections: [SectionModel] {
        var sections: [SectionModel] = []
        
        if let nowPlaying = queue.nowPlaying {
            sections.append(("Now Playing", [nowPlaying]))
        }
        
        if let collection = queue.collection, !queue.nextInCollection.isEmpty {
            sections.append(("Next in \(collection.title)", queue.nextInCollection))
        }
        
        if !queue.nextSuggested.isEmpty {
            sections.append(("Next: Suggested", queue.nextSuggested))
        }
        
        return sections
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(service != nil, "You should pass a service for this controller.")
        
        presentationController?.delegate = self
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 52
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "MusicCell", bundle: .main), forCellReuseIdentifier: Self.musicCellID)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction private func didTapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.willDismiss()
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension QueueViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.musicCellID, for: indexPath) as! MusicCell
        
        let music = sections[indexPath.section].musics[indexPath.row]
        let coverImage = service.getCoverImage(forItemIded: music.id)
        let isFavorite = service.favoriteMusics.contains(music)
        cell.configure(music: music, coverImage: coverImage, isFavorite: isFavorite)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension QueueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = QueueHeaderView()
        view.configure(title: sections[section].title)
        return view
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // we don't support removing the current music from the queue
        if queue.nowPlaying != nil, indexPath.section == 0, indexPath.row == 0 {
            return nil
        }
        
        let music = sections[indexPath.section].musics[indexPath.row]
        
        let removeFromQueueAction = UIContextualAction(style: .destructive, title: "Remove") { _, _, completion in
            self.service.removeFromQueue(music: music)
            self.tableView.reloadData()
            completion(true)
        }
        
        removeFromQueueAction.image = UIImage(systemName: "trash.fill")
        removeFromQueueAction.backgroundColor = UIColor(named: "red")
        
        let configuration = UISwipeActionsConfiguration(actions: [removeFromQueueAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - MusicCellDelegate
extension QueueViewController: MusicCellDelegate {
    func toggleFavorite(music: Music) {
        let isFavorite = service.favoriteMusics.contains(music)
        service.toggleFavorite(music: music, isFavorite: !isFavorite)
        
        tableView.reloadData()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension QueueViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        delegate?.willDismiss()
    }
}
