//
//  ListenAgainCell.swift
//  Tecnomusic
//
//  Created by Rodrigo Yukio Okido on 23/09/21.
//

import UIKit

class ListenAgainCell: UICollectionViewCell {
    

    @IBOutlet weak var listenAgainLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var item: [MusicCollection] = []
    
    func configure(item: [MusicCollection]) {
        self.item = item
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension ListenAgainCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListenAgainMusicCell", for: indexPath) as! ListenAgainMusicCell
            
        cell.configure(imageName: item[indexPath.row].id, name: item[indexPath.row].title)
            
            return cell
            
      
    }
}

extension ListenAgainCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width-32, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
    }
    
}

