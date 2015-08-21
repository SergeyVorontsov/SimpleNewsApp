//
//  NewsDetailsController.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

let kLikeChengeNotify = "likeChengeIndex"

import UIKit


/**
* Controller news details page
*/

class NewsDetailsController: UIViewController, NewsDataProviderDelegate {
    
    @IBOutlet var newsDetailsView: NewsDetailsView!
    var news:News!
    var newsDataProvider:NewsDataProvider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure NewsDataProvider
        newsDataProvider = NewsDataProvider()
        newsDataProvider.delegate = self
        newsDataProvider.fetchNewsText(news.id)
        
        self.title = news.title
        setupLikeButton()
        newsDetailsView.configure(news)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    //MARK: -
    
    func setupLikeButton() {
        let title = newsDataProvider.isLikedNews(news.id) ? "Unlike" : "Like"
        let button = UIBarButtonItem(title: title, style: .Plain, target: self, action: "likeButtonClicked")
        
        self.navigationItem.rightBarButtonItem = button
    }
    
    
    func likeButtonClicked() {
        let isLikes = newsDataProvider.isLikedNews(news.id)
        
        newsDataProvider.setLike(news.id, like: !isLikes)
        setupLikeButton()
        
        //increment/decrement news item like counter
        if isLikes {
            news.likeCount--
        } else {
            news.likeCount++
        }
        newsDetailsView.setNewsLikeCount(news.likeCount)
        NSNotificationCenter.defaultCenter().postNotificationName(
            kLikeChengeNotify,
            object: nil,
            userInfo: nil)
    }
    
    //MARK: - NewsDataProviderDelegate
    
    func newsDataProviderNewsTextDidLoad(#dataProvider: NewsDataProvider, text: String?) {
        if let newsText = text {
            newsDetailsView.newsDetailsLabel.text = newsText
        }
    }
    
}
