//
//  QueueHeaderView.swift
//  Tecnomusic
//
//  Created by Rafael Victor Ruwer Araujo on 23/06/21.
//

import UIKit

class QueueHeaderView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "QueueHeaderView", bundle: .main)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        addSubview(contentView)
        
        // two options to make contentView as big as self
        
        // 1: autoresizing mask
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        // 2: constraints
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.topAnchor.constraint(equalTo: topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ])
        
        self.contentView = contentView
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
