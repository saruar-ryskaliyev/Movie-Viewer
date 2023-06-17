//
//  SearchResultsViewController.swift
//  Movie Viewer
//
//  Created by Saruar on 07.06.2023.
//

import UIKit


protocol SearchResultsViewControllerDelegate: AnyObject {
    func SearchResultsViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    public var movies: [Movie] = [Movie]()
    
    
    public let searchResultsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        

        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        
        return collectionView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
    }
    


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    
}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = movies[indexPath.row]
        
        cell.configure(with: movie.poster_path ?? "")
        
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        let movie = movies[indexPath.row]
        
        
        let movieName = movie.original_title ?? ""
    
        APICaller.shared.getMovie(with: movieName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.SearchResultsViewControllerDidTapItem(MoviePreviewViewModel(title: movieName, youtubeVideo: videoElement, titleOverview: movie.overview ?? ""))

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    
}
