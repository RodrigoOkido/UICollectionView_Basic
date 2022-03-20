//
//  ListenAgainMusicCell.swift
//  Tecnomusic
//
//  Created by Rodrigo Yukio Okido on 24/09/21.
//

import UIKit

class ListenAgainMusicCell: UICollectionViewCell {
 
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var collectionName: UILabel!
    
    func configure(imageName: String, name: String) {
        albumImage.image = UIImage(named: imageName)
        collectionName.text = name
    }
    
}
