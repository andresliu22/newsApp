//
//  APICaller.swift
//  NewsApp
//
//  Created by Andres Liu on 8/6/21.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants {
        static let newsURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=eda6154a62744b7bbad849130a7f7b6f")
    }
    
    public func getNews(completion: @escaping (Result<[Article], Error>) -> Void){
        
        guard let url = Constants.newsURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    //print("\(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
    
}


// Models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
