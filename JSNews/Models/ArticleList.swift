//
//  List.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/25/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class ArticleList: Object {
    dynamic var name = ""
    let articles = List<Article>()
}
