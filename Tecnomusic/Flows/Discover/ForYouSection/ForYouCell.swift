//
//  ForYouCell.swift
//  Tecnomusic
//
//  Created by Rodrigo Yukio Okido on 23/09/21.
//

import UIKit

class ForYouCell: UICollectionViewCell {
    
    
    @IBOutlet weak var forYouLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var automaticPlaylistLabel: UILabel!
    
    var item: [MusicCollection] = []
    
    func configure(item: [MusicCollection]) {
        self.item = item
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


extension ForYouCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForYouMusicCell", for: indexPath) as! ForYouMusicCell
            
        cell.configure(imageName: item[indexPath.row].id, name: item[indexPath.row].title, artist: item[indexPath.row].mainPerson)
            
            return cell
            
      
    }
}

extension ForYouCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width-32, height: 232)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
    }
    
}
