//
//  CategoriesViewController.swift
//  News
//
//  Created by Вадим Лавор on 29.03.22.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    let data = ["Business", "Entertainment", "Health", "Science", "Technology", "Sports", "General"]
    let images = ["business", "entertainment", "health", "science-1", "technology", "sports", "general"]
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = .zero
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "News"
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = Font.boldFont
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setViews(){
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(collectionView)
        collectionView.widthAnchor.constraint(equalTo: self.view.layoutMarginsGuide.widthAnchor, multiplier: 1.0).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.view.layoutMarginsGuide.heightAnchor, multiplier: 1.0).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: self.view.layoutMarginsGuide.centerYAnchor).isActive = true
        collectionView.contentInset = .zero
        collectionView.delegate = self
        collectionView.dataSource = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCellId", for: indexPath)
        header.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
    
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCell: CGFloat = 1.0
        let totalSpace = spaceBetweenCell * 1.0
        if indexPath.row == data.count-1 {
            if data.count % 2  == 1 {
                return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height-totalSpace)/3.8)
            } else {
                return CGSize(width: (collectionView.frame.width-totalSpace)/2.1, height: (collectionView.frame.height-totalSpace)/3)
            }
        } else {
            return CGSize(width: (collectionView.frame.width-totalSpace)/2, height: (collectionView.frame.height-totalSpace)/3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.backgroundView = UIImageView(image: (UIImage(named: "\(images[indexPath.row])")))
        cell.title.text = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chosenCategory = data[indexPath.row]
        NetworkManager.shared.getArticles(category: chosenCategory){ result in
            switch result {
            case let .success(articles):
                let nextView: ArticlesListViewController = ArticlesListViewController()
                nextView.articles = articles
                nextView.category = self.data[indexPath.row]
                self.navigationController?.pushViewController(nextView, animated: true)
            case let .failure(error):
                print(error)
            }
        }
    }
    
}
