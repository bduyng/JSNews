//
//  ArticleTableViewCell.swift
//  JSNews
//
//  Created by Duy Bao Nguyen on 1/17/16.
//  Copyright © 2016 Duy Bao Nguyen. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func configure(withViewModel model: ArticleViewModel) {
        // configure the UI components
        title.text = model.title
        title.font = UIFont.systemFontOfSize(ArticleCellConstants.TextSize.title, weight: UIFontWeightMedium)
        
        subtitle.text = model.subtitle
        subtitle.font = UIFont.systemFontOfSize(ArticleCellConstants.TextSize.subtitle, weight: UIFontWeightLight)
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
