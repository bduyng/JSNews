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
        self.subtitle = [
            "\u{25B2} " + article.up,
            article.username,
            article.ctime.fromNow()
        ].joinWithSeparator("  \u{2022}  ")
    }
}