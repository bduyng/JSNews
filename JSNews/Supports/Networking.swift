//
//  Networking.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/25/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class Networking: NSObject {
    class func fetchArticles(page: Int = 0) {
        Alamofire.request(.GET, "http://www.echojs.com/api/getnews/top/\(page)/30")
            .responseJSON { response in
                debugPrint(response)
        }
    }
}
