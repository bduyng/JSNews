//
//  ArticleCellViewModel.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/24/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import Foundation

struct ArticleCellViewModel: ArticleCellPresentable {
    //    This would usually be instantiated with the model
    //    to be used to derive the information below
    //    but in this case, my app is pretty static
}

// MARK: TitlePresentable Conformance
extension ArticleCellViewModel {
    var titleText: String { return "Hello" }
}

// MARK: SubtitlePresentable Conformance
extension ArticleCellViewModel {
    var subtitleText: String { return "MVVM" }
}