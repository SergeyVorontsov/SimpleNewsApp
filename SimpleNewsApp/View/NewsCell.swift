//
//  NewsCell.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsAgeLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSummaryLabel: UILabel!
    @IBOutlet weak var newsLikeCountLabel: UILabel!

    /**
    Set image to newsImageView and cache with SDWebImage
    
    :param: imageUrl image path
    */
    func setNewsImage(imageUrl:String) {
        newsImageView.sd_setImageWithURL(NSURL(string: imageUrl))
    }
    

}
