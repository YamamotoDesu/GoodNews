//
//  URLRequest+Extentions.swift
//  GoodNews
//
//  Created by 山本響 on 2022/07/10.
//

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
