//
//  MovieTableViewCell.swift
//  Movie Viewer
//
//  Created by Saruar on 07.06.2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"
    
    
    private let playMovieButton: UIButton = {
        
        
       
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let moviePosterUIIMageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePosterUIIMageView)
        contentView.addSubview(movieLabel)
        contentView.addSubview(playMovieButton)
        
        applyConstraints()
    }
    
    
    private func applyConstraints() {
        let moviePosterUIIMageViewConstraints = [
            moviePosterUIIMageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterUIIMageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePosterUIIMageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            moviePosterUIIMageView.widthAnchor.constraint(equalToConstant: 100),

        ]
        
        let movieLabelConstraints = [
            movieLabel.leadingAnchor.constraint(equalTo: moviePosterUIIMageView.trailingAnchor, constant: 20),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieLabel.widthAnchor.constraint(equalToConstant: 140 )
        
        ]
        
        let playMovieButtonConstraints = [
        
            playMovieButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playMovieButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        
        ]
        
        NSLayoutConstraint.activate(moviePosterUIIMageViewConstraints)
        NSLayoutConstraint.activate(movieLabelConstraints)
        NSLayoutConstraint.activate(playMovieButtonConstraints)
    }
    
    public func configure(with model: MovieViewModel){

        

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else{
            return
        }
        
        moviePosterUIIMageView.sd_setImage(with: url, completed: nil)
        movieLabel.text = model.movieName
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
