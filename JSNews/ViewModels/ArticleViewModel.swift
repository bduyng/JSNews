//
//  ArticleCellViewModel.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/24/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation

struct ArticleViewModel {
    let title: String
    let subtitle: String
    
    init(article: Article) {
        self.title = article.title
        self.subtitle = article.username
    }
}