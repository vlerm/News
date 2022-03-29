//
//  ArticleCell.swift
//  News
//
//  Created by Вадим Лавор on 29.03.22.
//

import Foundation
import UIKit
import Kingfisher

class ArticleCell: UITableViewCell {
    
    var articleImage: UIImageView = {
        var articleImage = UIImageView()
        articleImage.layer.cornerRadius = 10
        articleImage.clipsToBounds = true
        return articleImage
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .black
        title.font = Font.headingFont
        return title
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        contentView.addSubview(articleImage)
        setupImage()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage() {
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        articleImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        articleImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        articleImage.widthAnchor.constraint(equalTo: articleImage.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    func getImage(article: Article) {
        title.text = article.title!
        if let imageURL = article.urlToImage {
            articleImage.kf.setImage(with: URL(string: imageURL), completionHandler:  { result in
                switch result {
                case .success:
                    self.title.trailingAnchor.constraint(equalTo: self.articleImage.leadingAnchor).isActive = true
                case .failure:
                    self.title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
                }
            })
        }
    }
    
    func setupTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        title.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
}

