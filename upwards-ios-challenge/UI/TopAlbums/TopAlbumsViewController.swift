//
//  TopAlbumsViewController.swift
//  upwards-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsViewController: UIViewController {
    // MARK: - Private Properties
    
    private let iTunesAPI: ITunesAPI
    private let tableView = UITableView()
    private var albums = [Album]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Initializers
    
    init(iTunesAPI: ITunesAPI) {
        self.iTunesAPI = iTunesAPI
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.TopAlbumsViewController.initFatalErrorMsg.rawValue)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.title = Constants.TopAlbumsViewController.topAlubms.localizedString()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TopAlbumTableViewCell.self, forCellReuseIdentifier: TopAlbumTableViewCell.description())
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        loadData()
    }
    
    // MARK: - Private API
    
    private func loadData() {
        Task.detached { [weak self] in
            let res = await self?.iTunesAPI.getTopAlbums()
            
            switch res {
                case .success(let data):
                    await MainActor.run { [weak self] in
                        self?.albums = data.feed.results
                    }
                case .failure(let err):
                    debugPrint(err)
                
                default:
                    break
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension TopAlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TopAlbumTableViewCell.description(), for: indexPath) as! TopAlbumTableViewCell
        cell.albumLabel.text = album.name
        cell.artistNameLabel.text = album.artistName
                
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TopAlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(albums[indexPath.row])
    }
}

// MARK: - Constants + TopAlbumsViewController

fileprivate extension Constants {
    enum TopAlbumsViewController: String, ILocalizableRawRepresentable {
        case topAlubms = "Top Albums"
        case initFatalErrorMsg = "init(coder:) has not been implemented"
    }
}
