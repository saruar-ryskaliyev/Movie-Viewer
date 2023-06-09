//
//  DownloadsViewController.swift
//  Movie Viewer
//
//  Created by Saruar on 05.06.2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    
    private var movies: [MovieItem] = [MovieItem]()
    
    private let downloadedTable: UITableView = {
        
       
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadedTable)
        
        view.backgroundColor = .systemBackground
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        downloadedTable.reloadData()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingMoviesFromDataBase { [weak self] result in
            switch result{
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }


}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
                
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case.delete:
           
            DataPersistenceManager.shared.deleteMovieWith(model: movies[indexPath.row]) { [weak self] result in
                switch result{
                case .success():
                    print("Delete")
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
            self.movies.remove(at: indexPath.row)
            downloadedTable.deleteRows(at: [indexPath], with: .fade)

        default:
            break;
        }
    }
    
}
