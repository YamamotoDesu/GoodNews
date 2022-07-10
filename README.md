# GoodNews
Building News App Using Transforming Operators

<img width="490" alt="スクリーンショット 2022-07-10 17 47 21" src="https://user-images.githubusercontent.com/47273077/178137905-2b1a4611-37b7-4ca1-8d44-9a9df63d725d.png">

## Top Headlines API 
```
GET https://newsapi.org/v2/top-headlines?country=us&apiKey=5d6dbcb935da4a46ac11dc89114af273
```
https://newsapi.org/docs/endpoints/top-headlines

<img width="491"  src="https://user-images.githubusercontent.com/47273077/178139291-2220afc2-042c-44f6-8637-70f976c61af9.png">

## ViewController
```swift
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
        
        URLRequest.load(resoource: ArticlesList.all)
            .subscribe(onNext: { [weak self] result in
                if let result = result {
                    self?.articles = result.articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        
    }
}

```

## Model
```swift
import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String?
}

```

## Extentions
```swift
import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

extension ArticlesList {
    
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=5d6dbcb935da4a46ac11dc89114af273")!
        return Resource(url: url)
    }()
}

extension URLRequest {
    
    static func load<T>(resoource: Resource<T>) -> Observable<T?> {
        
        return Observable.from([resoource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return  URLSession.shared.rx.data(request: request)
            }.map { data -> T? in
                return try? JSONDecoder().decode(T.self, from: data)
            }.asObservable()
    }
}
```
