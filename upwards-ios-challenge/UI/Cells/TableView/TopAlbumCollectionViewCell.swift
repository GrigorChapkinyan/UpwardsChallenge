//
//  TopAlbumCollectionViewCell.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/6/23.
//

import UIKit

class TopAlbumCollectionViewCell: UICollectionViewCell {
    // MARK: - Static Properties
    
    static let reuseId = "TopAlbumCollectionViewCell"
    static let nibName = "TopAlbumCollectionViewCell"
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var singerNameLabel: UILabel!
    @IBOutlet private weak var albumNameLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var viewModel: TopAlbumCellViewModel?

    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = true
        iconImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = 15
    }
    
    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        refresh(with: viewModel)
    }

    func setup(viewModel: TopAlbumCellViewModel) {
        self.viewModel = viewModel
        refresh(with: viewModel)
    }
    
    // MARK: - Private API

    private func refresh(with viewModel: TopAlbumCellViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        self.singerNameLabel.text = viewModel.singerName
        self.albumNameLabel.text = viewModel.albumName
        
        if  let urlPath = viewModel.iconUrlPath,
            let imageUrl = URL(string: urlPath) {
            Utils().downloadImage(from: imageUrl, completion: { [weak self] image in
                self?.iconImageView?.image = image
            })
        }
    }
}
