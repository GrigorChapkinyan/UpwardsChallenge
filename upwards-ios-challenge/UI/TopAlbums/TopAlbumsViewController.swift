//
//  TopAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Grigor Chapkinyan on 11/6/23.
//

import UIKit

class TopAlbumsViewController: UIViewController, UICollectionViewDataSource {
    // MARK: - Static Properties
    
    static let nibId = "TopAlbumsViewController"
    
    // MARK: - IBoutlets
    
    @IBOutlet private weak var albumsCollectionView: UICollectionView!
    
    // MARK: - Private Properties
    
    var viewModel: TopAlbumsViewModel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialConfigs()
        setupViewModel(TopAlbumsViewModel(itemsReceived: nil, errorReceived: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.refresh?()
    }
    
    func setupViewModel(_ viewModel: TopAlbumsViewModel) {
        self.viewModel = viewModel
        
        viewModel.itemsReceived = { [weak self] (_) in
            self?.albumsCollectionView.reloadData()
        }
    }
        
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let albumCell = albumsCollectionView.dequeueReusableCell(withReuseIdentifier: TopAlbumCollectionViewCell.reuseId, for: indexPath) as? TopAlbumCollectionViewCell,
              let cellViewModel = self.viewModel?.items[indexPath.row]  else {
            return TopAlbumCollectionViewCell()
        }
        
        albumCell.setup(viewModel: cellViewModel)
        
        return albumCell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    // MARK: - Private API

    private func setupInitialConfigs() {
        albumsCollectionView.register(UINib(nibName: TopAlbumCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: TopAlbumCollectionViewCell.reuseId)
        albumsCollectionView.allowsSelection = false
        albumsCollectionView.dataSource = self
        albumsCollectionView.delegate = self
        albumsCollectionView.showsHorizontalScrollIndicator = false
        albumsCollectionView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UICollectionViewDelegate

extension TopAlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionViewCellMinimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.collectionViewCellMinimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return categoryPreviewCollectionViewCellSizeFor(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return categoryPreviewCollectionViewInsetFor(section: section)
    }
    
    private func categoryPreviewCollectionViewInsetFor(section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    private func categoryPreviewCollectionViewCellSizeFor(indexPath: IndexPath) -> CGSize {
        let cellsWidth = CGFloat(floor((self.albumsCollectionView.frame.width - (Constants.collectionViewCellMinimumInteritemSpacing)) / 2))
        let cellsHeight = CGFloat(floor((self.albumsCollectionView.frame.height - (Constants.collectionViewCellMinimumLineSpacing)) / 2))
        
        return CGSize(width: cellsWidth, height: cellsHeight)
    }
}
