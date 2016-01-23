//
//  ArticleTableViewCell.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit


// Title protocol
protocol TitlePresentable {
    var titleText: String { get }
}

// Subtitle protocol
protocol SubtitlePresentable {
    var subtitleText: String { get }
}

typealias ArticleCellPresentable = protocol <TitlePresentable, SubtitlePresentable>

class ArticleTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    private var delegate: ArticleCellPresentable?
    
    // configure with something that conforms to the composed protocol
    func configure(withPresenter presenter: ArticleCellPresentable) {
        delegate = presenter
        
        // configure the UI components
        title.text = presenter.titleText
        subtitle.text = presenter.subtitleText
    }
    
    static var nib: UINib? {
        return UINib(nibName: String(ArticleTableViewCell.self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
