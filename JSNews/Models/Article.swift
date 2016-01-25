//
//  Article.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/25/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object {
    dynamic var down = ""
    dynamic var url = ""
    dynamic var up = ""
    dynamic var ctime = ""
    dynamic var id = ""
    dynamic var title = ""
    dynamic var username = ""
    dynamic var comments = ""
}
