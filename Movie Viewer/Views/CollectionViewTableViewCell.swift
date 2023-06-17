//
//  CollectionViewTableViewCell.swift
//  Movie Viewer
//
//  Created by Saruar on 05.06.2023.
//

import UIKit



protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MoviePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = [Movie]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    
    public func configure(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    private func downloadTitleAt(indexPath: IndexPath){
        
        DataPersistenceManager.shared.downloadMovieWith(model: movies[indexPath.row]) { result in
            switch result{
            case.success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = movies[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        
        cell.configure(with: model)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: movieName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                //print(videoElement.id)
        
                
                guard let movieOverview = movie.overview else {
                    return
                }
                
                let viewModel = MoviePreviewViewModel(title: movieName, youtubeVideo: videoElement, titleOverview: movieOverview)
                
                guard let strongSelf = self else {
                    return
                }
                
                self?.delegate?.CollectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
                let config = UIContextMenuConfiguration(
                    identifier: nil,
                    previewProvider: nil) { _ in
                        let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                            self.downloadTitleAt(indexPath: indexPaths[0])
                        }
                        return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
                    }
        
                return config
    }
    
    
}
