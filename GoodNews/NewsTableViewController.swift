//
//  NewsTableViewController.swift
//  GoodNews
//
//  Created by 山本響 on 2022/07/09.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .orange
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        populateNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArticleTableViewCell does not exist")
        }
        
        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.descriptionLabel.text = self.articles[indexPath.row].description
        
        return cell
    }
    
    private func populateNews() {
        
//        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=5d6dbcb935da4a46ac11dc89114af273")!
//        
//        let resource = Resource<ArticlesList>(url: url)
//        
        URLRequest.load(resoource: ArticlesList.all)
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.articles = result.articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        
//        Observable.just(url)
//            .flatMap { url -> Observable<Data> in
//                let request = URLRequest(url: url)
//                return URLSession.shared.rx.data(request: request)
//            }.map { data -> [Article]? in
//                return try? JSONDecoder().decode(ArticlesList.self, from: data).articles
//            }.subscribe(onNext: { [weak self] articles in
//                if let articles = articles {
//                    self?.articles = articles
//                    DispatchQueue.main.async {
//                        self?.tableView.reloadData()
//                    }
//                }
//            }).disposed(by: disposeBag)
        
    }
}
