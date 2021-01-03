//
//  NetworkManager.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 24.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private enum ApiUrl {
        static let search =
        "https://itunes.apple.com/search?term=%@&media=music"
        static let album =
        "https://itunes.apple.com/lookup?id=%@&entity=song&limit=200"
    }
    
    func fetchData<T>(search text: String,
                      completion: @escaping(Result<[T]?, Error>) -> Void) {
        
    }
    
    func fetchSearchData(search text: String,
                         completion: @escaping(Result<[Track]?, Error>) -> Void) {
        
        let urlString = String(format: ApiUrl.search, text)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let albums = try JSONDecoder().decode(SearchModel<Track>.self,
                                                      from: data)
                completion(.success(albums.results))
            } catch let error {
                //completion Error
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImageData(from url: URL,
                        completion: @escaping(Data, URLResponse) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                //Completion with Result failure
                print(error.localizedDescription)
                return
            }
            guard let data = data, let response = response else {
                //completiom with Result failure
                print(error?.localizedDescription ?? "No error description")
                return }
            completion(data, response)
        }.resume()
    }
}
