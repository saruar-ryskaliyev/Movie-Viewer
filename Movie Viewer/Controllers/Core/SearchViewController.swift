//
//  SearchViewController.swift
//  Movie Viewer
//
//  Created by Saruar on 05.06.2023.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    private var movies: [Movie] = [Movie]()
    
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        return table
        
    }()
    
    private let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultsViewController())
        search.searchBar.placeholder = "Search for a movie or a tv show"
        search.searchBar.searchBarStyle = .minimal
        
        return search
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchDiscover()
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        searchController.searchResultsUpdater = self

     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    
    }
    
    

    private func fetchDiscover(){
        APICaller.shared.getDiscoverMovie { result in
            switch result{
            case .success(let movies):
                self.movies = movies
                
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        
        cell.configure(with: MovieViewModel(movieName: movie.original_title  ?? "Unknown", posterURL: movie.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.original_title else {
            return
        }
        
        APICaller.shared.getMovie(with: movieName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                
                DispatchQueue.main.async {
                    
                    let vc = MoviePreviewViewController()
                    vc.configure(with: MoviePreviewViewModel(title: movieName, youtubeVideo: videoElement, titleOverview: movie.overview ?? ""))

            
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

         
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    } 
    
}


extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {

    
    

    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        

        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
                return
            }
         
        resultController.delegate = self

        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    resultController.movies = movies
                    resultController.searchResultsCollectionView.reloadData()
    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        }

        
    }
    
    
    func SearchResultsViewControllerDidTapItem(_ viewModel: MoviePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
}

