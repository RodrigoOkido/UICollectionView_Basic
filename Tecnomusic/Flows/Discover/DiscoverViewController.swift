//
//  DiscoverViewController.swift
//  Tecnomusic
//
//  Created by Rafael Araujo on 22/09/21.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    var service: MusicService!
    private var sections: [Discover.Section] = []
    
    static let musicStylesCellID: String = "MusicStylesCell"
    static let listenAgainCellID: String = "ListenAgainCell"
    static let forYouCellID: String = "ForYouCell"
    static let recentCellID: String = "RecentReleasedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = Discover.buildMock(service: service)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
}

extension DiscoverViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = sections[section]
        
        switch sectionModel {
        case .musicStyles(let styles):
            return styles.count / 2
        case .musicCollections:
            return 1
        case .forYou:
            return 1
        case .newRelease:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = sections[indexPath.section]
        
        switch sectionModel {
        case .musicStyles(let styles):
            let offset = indexPath.row * 2
            let items = styles[offset ..< (offset + 2)]
            
            guard let first = items.first, let last = items.last else {
                return UICollectionViewCell()
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.musicStylesCellID, for: indexPath) as! MusicStylesCell
            
            cell.configure(first: first, last: last)
            
            return cell
            
        case .musicCollections(_, let collection):
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.listenAgainCellID, for: indexPath) as! ListenAgainCell
            
            cell.configure(item: collection)
            return cell
            
        case .forYou(_, let collection):

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.forYouCellID, for: indexPath) as! ForYouCell

            cell.configure(item: collection)
            return cell

        case .newRelease(let album, let music, let image):

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.recentCellID, for: indexPath) as! RecentReleasedCell

            cell.configure(imageId: image!, nameTitle: music.title, album: album.title)
            return cell
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = sections[indexPath.section]
        
        switch sectionModel {
        case .musicStyles:
            let width = collectionView.frame.width - 16 - 16
            return CGSize(width: width, height: 50)
            
        case .musicCollections:
            return CGSize(width: collectionView.frame.width - 32, height: 227)
            
        case .forYou:
            return CGSize(width: collectionView.frame.width - 32, height: 232)
        
        case .newRelease:
            return CGSize(width: collectionView.frame.width - 32, height: 144)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = sections[section]
        
        switch sectionModel {
        case .musicStyles:
            return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
        case .musicCollections:
            return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
        case .forYou:
            return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
        case .newRelease:
            return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = sections[section]
        
        switch sectionModel {
        case .musicStyles:
            return 10
        case .musicCollections:
            return 10
        case .forYou:
            return 10
        case .newRelease:
            return 10

        }
    }
}
