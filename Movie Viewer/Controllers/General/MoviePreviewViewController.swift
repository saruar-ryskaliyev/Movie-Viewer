//
//  MoviePreviewViewController.swift
//  Movie Viewer
//
//  Created by Saruar on 11.06.2023.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    
    
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        
        label.text = "Harry Potter"
        
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        label.text = "Best movie ever ever looool"
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addSubview(movieLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        
        view.backgroundColor = .systemBackground
        
        configureConstraints()

        // Do any additional setup after loading the view.
    }
    
    
    private func configureConstraints() {
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 85),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let movieLabelConstraints = [
            movieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            movieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(movieLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        
    }
    
    
    func configure(with model: MoviePreviewViewModel) {
        movieLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }


}
