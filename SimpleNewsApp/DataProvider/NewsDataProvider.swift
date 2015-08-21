//
//  NewsDataProvider.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import UIKit
import Foundation

enum CachePolicy {
    case CacheOnly
    case CacheThenNetwork
    case NetworkOnly
    
    func containsCache() -> Bool {
        return (self == CacheOnly || self == CacheThenNetwork)
    }
    
    func containsNetwork() -> Bool {
        return (self == CacheThenNetwork || self == NetworkOnly)
    }
    
}

@objc protocol NewsDataProviderDelegate {
    optional func newsDataProviderNewsDidLoad(#dataProvider:NewsDataProvider) -> Void
    optional func newsDataProviderNewsTextDidLoad(#dataProvider:NewsDataProvider, text:String?) -> Void
}


class NewsDataProvider : NSObject {
    
    var delegate: NewsDataProviderDelegate?
    private var news:[News] = [News]()
    private var newsService: NewsService
    private var internalStorage: NewsInternalStorage
    private var pendingLikes:PendingLikes
    
    
    override convenience init() {
        self.init(newsService: AppSettings.defaultSetting.newsService,
            internalStorage: AppSettings.defaultSetting.newsInternalStorage)
    }
    
    init(newsService: NewsService, internalStorage: NewsInternalStorage) {
        self.newsService = newsService
        self.internalStorage = internalStorage
        self.pendingLikes = PendingLikes(internalStorage: internalStorage,
                newsService: newsService)
        
        super.init()
        pendingLikes.resolvePendingLikes()
    }
    
    //MARK: -
    
    func newsCount() -> Int {
        return news.count
    }
    
    
    func newsAtIndex(index:Int) -> News {
        assert(index >= 0 && index < news.count, "Index out of bounds")
        return news[index]
    }
    
    
    /**
    Getting news. after the is invoked delegate method  - newsDataProviderNewsDidLoad
    
    :param: cachePolicy CachePolicy. Default - CacheThenNetwork
    */
    func fetchNews(cachePolicy:CachePolicy = .CacheThenNetwork) -> Void {
        
        //If first need to get from the cache
        if cachePolicy.containsCache() {
            self.setRestoredNews()
            self.delegate?.newsDataProviderNewsDidLoad?(dataProvider: self)
        }
        
        //If need to receive by network
        if cachePolicy.containsNetwork() {
            self.getAndStoreNews{ (error) in
                self.setRestoredNews()
                self.delegate?.newsDataProviderNewsDidLoad?(dataProvider: self)
            }
        }
    }
    

    /**
    Getting news text by id. After the is invoked delegate method
    newsDataProviderNewsTextDidLoad
    
    :param: newsId      news id
    :param: cachePolicy CachePolicy. Default - CacheThenNetwork
    */
    func fetchNewsText(newsId:String, cachePolicy:CachePolicy = .CacheThenNetwork) -> Void {
        
        //If first need to get from the cache
        if cachePolicy.containsCache() {
            let newsText = internalStorage.restoreNewsText(newsId)
            self.delegate?.newsDataProviderNewsTextDidLoad?(dataProvider: self, text: newsText)
        }
        
        //If need to receive by network
        if cachePolicy.containsNetwork() {
            newsService.getNewsText(newsId){
                (newsText, error) in
                if let text = newsText where error == nil {
                    self.internalStorage.saveNewsText(newsId, text: text)
                }
                self.delegate?.newsDataProviderNewsTextDidLoad?(dataProvider: self, text: newsText)
            }
        }
    }
    
    
    //MARK: -
    
    /**
    Returns True if the news we liked
    */
    func isLikedNews(newsId:String) -> Bool {
        return internalStorage.isLikedNews(newsId)
    }
    
    
    /**
    Set like/unlike for news
    
    :param: newsId news id
    :param: like   liked
    */
    func setLike(newsId:String, like:Bool) {
        internalStorage.saveMyLike(newsId, like: like)
        newsService.putLikeForNews(newsId, like:like){
            (result, error) in
            if result == false {
                self.pendingLikes.addPendingLike(newsId: newsId, like: like)
            }
        }
    }

    
}



//MARK: -
private extension NewsDataProvider {
    
    /**
    Assign a variable ** news ** data from the local store
    */
    private func setRestoredNews(){
        if let newsList = self.restoreNewsList() {
            self.news = newsList
        }
    }
    
    /**
    Get a stored news list
    */
    private func restoreNewsList() -> [News]? {
        let newsList = internalStorage.restoreNewsList()
        
        //add if needed, likes are not sended to the server
        if newsList != nil {
            let aPendingLikes = pendingLikes.getPendingLikes()
            for newsItem in newsList! {
                if let like = aPendingLikes[newsItem.id] {
                    let countLikes = like ? 1 : -1
                    newsItem.likeCount += countLikes
                }
            }
        }
        return newsList
    }
    
    
    /**
    Get news from the server and written in the local store
    */
    private func getAndStoreNews(callback:(NSError?)->Void) {
        newsService.getNews {
            (newsList, error) in
            if error != nil {
                callback(error)
                return
            }
            //Local saving
            if newsList != nil {
                self.internalStorage.saveNewsList(newsList!)
            }
            callback(nil)
        }
    }
    

}


