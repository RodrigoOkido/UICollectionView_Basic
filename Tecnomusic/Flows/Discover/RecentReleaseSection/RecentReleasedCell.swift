//
//  RecentReleasedCell.swift
//  Tecnomusic
//
//  Created by Rodrigo Yukio Okido on 23/09/21.
//

import UIKit

class RecentReleasedCell: UICollectionViewCell {
    
    @IBOutlet weak var imageArtist: UIImageView!
    @IBOutlet weak var recentlyReleasedLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var image: UIImage = UIImage()
    var name: String = ""
    var album: String = ""
    
    func configure(imageId: UIImage, nameTitle:String, album: String) {
        self.image = imageId
        self.name = nameTitle
        self.album = album
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imageArtist.layer.masksToBounds = false
        imageArtist.layer.cornerRadius = imageArtist.frame.height/2
        imageArtist.clipsToBounds = true
    }
}

extension RecentReleasedCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentReleasedMusicCell", for: indexPath) as! RecentReleasedMusicCell
            
        cell.configure(imageName: "7vN82vd1Vq44fjlhjfvHJp", name: "Nothing", artist: "ANTI (Deluxe)")
            
            return cell
            
      
    }
}

extension RecentReleasedCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width-32, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 24, left: 16, bottom: 12, right: 16)
    }
    
}

