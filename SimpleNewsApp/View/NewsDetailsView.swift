//
//  NewsDetailsView.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import UIKit
import SDWebImage

/**
*  Deatails news page
*/
class NewsDetailsView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsLikeCountLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsDetailsLabel: UILabel!
    
    
    func configure(news:News) {
        let dateString = NSDateFormatter.localizedStringFromDate(news.time,
            dateStyle: NSDateFormatterStyle.FullStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        newsDateLabel.text = dateString
        newsTitleLabel.text = news.title
        newsImageView.sd_setImageWithURL(NSURL(string: news.imageUrl))
        self.setNewsLikeCount(news.likeCount)
    }
    
    func setNewsLikeCount(count:Int) {
        newsLikeCountLabel.text = "likes: \(count)"
    }
    
}
