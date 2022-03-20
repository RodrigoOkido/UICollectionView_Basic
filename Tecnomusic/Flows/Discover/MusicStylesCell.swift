//
//  MusicStylesCell.swift
//  Tecnomusic
//
//  Created by Rafael Araujo on 22/09/21.
//

import UIKit

class MusicStylesCell: UICollectionViewCell {
    
    @IBOutlet private weak var firstStyleContainerView: UIView!
    @IBOutlet private weak var firstStyleImageView: UIImageView!
    @IBOutlet private weak var firstStyleLabel: UILabel!
    @IBOutlet private weak var lastStyleContainerView: UIView!
    @IBOutlet private weak var lastStyleImageView: UIImageView!
    @IBOutlet private weak var lastStyleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let borderColor = UIColor(named: "light-gray")
        
        firstStyleContainerView.layer.cornerRadius = 4
        firstStyleContainerView.layer.borderWidth = 1
        firstStyleContainerView.layer.borderColor = borderColor?.cgColor
        firstStyleContainerView.layer.masksToBounds = true
        
        lastStyleContainerView.layer.cornerRadius = 4
        lastStyleContainerView.layer.borderWidth = 1
        lastStyleContainerView.layer.borderColor = borderColor?.cgColor
        lastStyleContainerView.layer.masksToBounds = true
    }
    
    func configure(first: MusicStyle, last: MusicStyle) {
        firstStyleImageView.image = first.image
        firstStyleLabel.text = first.name
        
        lastStyleImageView.image = last.image
        lastStyleLabel.text = last.name
    }
    
}
