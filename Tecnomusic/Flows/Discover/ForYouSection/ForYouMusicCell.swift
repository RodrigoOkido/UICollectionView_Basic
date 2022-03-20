//
//  ForYouMusicCell.swift
//  Tecnomusic
//
//  Created by Rodrigo Yukio Okido on 24/09/21.
//

import UIKit

class ForYouMusicCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionArtist: UILabel!
    
    
    func configure(imageName: String, name: String, artist: String) {
        collectionImage.image = UIImage(named: imageName)
        collectionName.text = name
        collectionArtist.text = artist
    }
}
