//
//  DataPersistenceManager.swift
//  Movie Viewer
//
//  Created by Saruar on 16.06.2023.
//

import UIKit
import CoreData


class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
    }
    
    
    func downloadMovieWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        let item = MovieItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.media_type = model.media_type
        item.realese_data = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = Int64(model.vote_average)
        
        
        do{
            try context.save()
            completion(.success(()))
        } catch{
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    
    func fetchingMoviesFromDataBase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do{
            let movies = try context.fetch(request)
            completion(.success(movies))
            
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
        
    }
    
    
    
    func deleteMovieWith(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DataBaseError.failedToSaveData))
        }
        
    }
    
        
}
