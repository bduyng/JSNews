//
//  ArticleListViewModel.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/25/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class ArticleListViewModel {
    weak var delegate:ArticleListViewModelDelegate?
    
    var articles = [Article]()
    let pageSize = 30
    
    func fetchArticles(sort: String = "top") {
        Networking.fetchArticles(articles.count, sort: sort, completion: {responseArticles in
            for article in responseArticles {
                
                let articleModel = Article()
                articleModel.title = article.valueForKey("title") as! String
                articleModel.down = article.valueForKey("down") as! String
                articleModel.url = article.valueForKey("url") as! String
                articleModel.up = article.valueForKey("up") as! String
                articleModel.ctime = article.valueForKey("ctime") as! String
                articleModel.id = article.valueForKey("id") as! String
                articleModel.title = article.valueForKey("title") as! String
                articleModel.username = article.valueForKey("username") as! String
                articleModel.comments = article.valueForKey("comments") as! String
                
                // change url if the url is in the form text://
                // https://github.com/antirez/lamernews/blob/master/app.rb#L1655
                if articleModel.url.lowercaseString.indexOf("text://") == 0 {
                    articleModel.url = [Networking.host, "news", articleModel.id].joinWithSeparator("/")
                }
                
                self.articles.append(articleModel)
            }
            
            self.delegate?.didFetchedArticles(self.articles)
        })
    }
    
    func getSavedArticles() {
        let predicate = NSPredicate(format: "vtime!=nil")
        let realm = try! Realm()
        self.articles = Array(realm.objects(Article).filter(predicate).sorted("vtime", ascending: false))
    }
}

protocol ArticleListViewModelDelegate: class {
    func didFetchedArticles(articles: [Article])
}