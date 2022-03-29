//
//  NetworkManager.swift
//  News
//
//  Created by Вадим Лавор on 29.03.22.
//

import Foundation
import UIKit

class NetworkManager {
    
    public static let shared = NetworkManager()
    let urlSession = URLSession.shared
    let baseURL = "https://newsapi.org/v2/"
    let topHeadlines = "top-headlines?country=ru&apiKey="
    let APIKey = "9416e2810d8e4db084870dd5cbf88bf4"
    
    func getArticles(category: String, _ completion: @escaping (Result<[Article]>) -> Void) {
        let articlesRequest = makeRequest(for: .category(category: category))
        let task = urlSession.dataTask(with: articlesRequest) { data, response, error in
            if let error = error {
                return completion(Result.failure(error))
            }
            guard let data = data else {
                return completion(Result.failure(EndPointError.noData))
            }
            
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print(error.localizedDescription)
            }
            
            guard let result = try? JSONDecoder().decode(ArticleList.self, from: data) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let articles = result.articles
            
            DispatchQueue.main.async {
                completion(Result.success(articles))
            }
        }
        task.resume()
    }
    
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        let stringParams = endPoint.paramsToString()
        let path = endPoint.getPath()
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(secretKey: "9416e2810d8e4db084870dd5cbf88bf4")
        return request
    }
    
    enum EndPoints {
        case articles
        case category(category: String)
        
        func getPath() -> String {
            switch self {
            case .category, .articles:
                return "top-headlines"
            }
        }
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        func getHeaders(secretKey: String) -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "X-Api-Key \(secretKey)",
                "Host": "newsapi.org"
            ]
        }
        
        func getParams() -> [String: String] {
            switch self {
            case .articles:
                return [
                    "country": "us",
                ]
                
            case .category(let category):
                return [
                    "country": "us",
                    "category": category
                ]
            }
        }
        
        func paramsToString() -> String {
            let parameterArray = getParams().map { key, value in
                return "\(key)=\(value)"
            }
            return parameterArray.joined(separator: "&")
        }
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
}
