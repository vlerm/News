//
//  ArticlesListViewController.swift
//  News
//
//  Created by Вадим Лавор on 29.03.22.
//

import UIKit

class ArticlesListViewController: UIViewController{
    
    let tableView = UITableView()
    let networkManager = NetworkManager()
    var category: String? = nil
    var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "cell")
        title = category!
        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    func setupTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ArticlesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleCell
        cell.getImage(article: articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextView: DetailViewController = DetailViewController()
        nextView.url = articles[indexPath.row].url
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}

