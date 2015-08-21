//
//  PendingLikes.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//


import Foundation


class PendingLikes {

    private var internalStorage: NewsInternalStorage
    private var newsService: NewsService
    
    init(internalStorage: NewsInternalStorage, newsService: NewsService){
        self.internalStorage = internalStorage
        self.newsService = newsService
    }
    
    
    /**
    Add pending like
    
    :param: newsId news id
    :param: like   like value
    
    :returns: true if pending like saved
    */
    func addPendingLike(#newsId:String, like:Bool) -> Bool {
        return internalStorage.savePendingLike(newsId, like: like)
    }
    
    
    /**
    Delete pending like
    
    :param: newsId news id
    
    :returns: true if pending like deleted
    */
    func deletePendingLike(#newsId:String) -> Bool {
        return internalStorage.deletePendingLike(newsId)
    }
    
    
    /**
    Getting a pending likes
    
    :returns: Dict with pending likes
    
    key - news id, value - to increase likes counter
    */
    func getPendingLikes() -> [String:Bool] {
        return internalStorage.restorePendingLikes()
    }
    
    /**
    Attempt to send "unsent" likes.
    Like sent to the server is removed from the control.
    */
    func resolvePendingLikes(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let pendingLikesDict = self.getPendingLikes()
            for (newsId, like) in pendingLikesDict {
                self.newsService.putLikeForNews(newsId, like: like) {
                    (result, error) -> Void in
                    if result && error == nil {
                        self.deletePendingLike(newsId: newsId)
                    }
                }
            }
        }
    }
    

}