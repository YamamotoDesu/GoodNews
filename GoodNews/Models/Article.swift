//
//  Article.swift
//  GoodNews
//
//  Created by 山本響 on 2022/07/10.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String?
}
