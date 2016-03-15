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
    
    // MARK: Networking
    
    static let host = "http://www.echojs.com"
    
    class func fetchArticles(offset: Int = 0, sort: String = "top", completion: (articles: [NSDictionary]) -> Void) {
        print("\(host)/api/getnews/\(sort)/\(offset)/30")
        Alamofire.request(.GET, "\(host)/api/getnews/\(sort)/\(offset)/30")
            .responseJSON { response in
                guard let responseJSON = response.result.value
                    where response.result.isSuccess else {
                        print("ERROR: \(response.result.value)")
                        completion(articles: [])
                        return
                }
                completion(articles: (responseJSON as! NSDictionary) ["news"] as! [NSDictionary])
            }
    }
}
