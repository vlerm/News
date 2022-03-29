//
//  Article.swift
//  News
//
//  Created by Вадим Лавор on 29.03.22.
//

import Foundation

public struct Article: Codable {
    
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let content: String?
    
}

public struct ArticleList: Codable {
    
    public var articles: [Article]
    
}

struct Source: Codable {
    
    public let id: String?
    public let name: String?
    
}
