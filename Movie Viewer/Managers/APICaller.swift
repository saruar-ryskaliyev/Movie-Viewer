//
//  APICaller.swift
//  Movie Viewer
//
//  Created by Saruar on 06.06.2023.
//

import Foundation

struct Constants {
    static let API_KEY = "f8275688183e4f9528be9de3593ee97f"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyCnyHojDJXJTBHoIFDw1nQrAWI9XlgzWAg"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}


enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            } catch{
                completion(.failure(error))
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
    func getTrendingTvs(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else{return}
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))

            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getDiscoverMovie(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        
        task.resume()
    }
    
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return}
        
        
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            
            guard let data = data, error == nil else{
                return
            }
            
            
            do{
                
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                
                completion(.success(results.items[0]))
                
            }catch {
                completion(.failure(APIError.failedToGetData))
            }
            
            
            
        }
        
        task.resume()
        
    }
    
}
