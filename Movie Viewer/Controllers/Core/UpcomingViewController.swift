//
//  UpcomingViewController.swift
//  Movie Viewer
//
//  Created by Saruar on 05.06.2023.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    private var movies: [Movie] = [Movie]()
    
    private let upcomingTable: UITableView = {
        
       
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .systemBackground

        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        
        fetchUpcoming()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                

            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    

}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else{
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
       
        cell.configure(with: MovieViewModel(movieName: movie.original_title ?? "Unknown", posterURL: movie.poster_path ?? ""))
        
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
