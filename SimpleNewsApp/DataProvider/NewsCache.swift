//
//  NewsCache.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import Foundation

private let NewsListKey = "NewsListKey"
private let NewsTextKey = "NewsTextKey"
private let LikesKey = "LikesKey"
private let PendingLikesKey = "PendingLikesKey"

/**
*  Storage news using NSUserDefaults
*/
class NewsCache : NewsInternalStorage {
    
    //MARK: News
    
    /**
    Save the news list
    */
    func saveNewsList(newsList:[News]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let objectsData = NSKeyedArchiver.archivedDataWithRootObject(newsList)
        
        defaults.setObject(objectsData, forKey: NewsListKey)
        defaults.synchronize()
    }
    

    /**
    Restoring the news list
    */
    func restoreNewsList() -> [News]?{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let objectsData = defaults.dataForKey(NewsListKey) {
            let news = NSKeyedUnarchiver.unarchiveObjectWithData(objectsData) as? [News]
            return news
        }
        //failed to recover news
        return nil
    }
    
    
    /**
    Save text news
    */
    func saveNewsText(newsId:String, text:String){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //getting saved dict
        var textNewsDict:[String:String] = [:]
        if let objectsData:NSData = defaults.dataForKey(NewsTextKey) {
            textNewsDict = (NSKeyedUnarchiver.unarchiveObjectWithData(objectsData) as? [String:String]) ?? [String:String]()
        }
        textNewsDict[newsId] = text
        
        //save
        let objectsData = NSKeyedArchiver.archivedDataWithRootObject(textNewsDict)
        defaults.setObject(objectsData, forKey: NewsTextKey)
        defaults.synchronize()
        
    }
    
    
    /**
    Restore text news
    */
    func restoreNewsText(newsId:String) -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let objectsData:NSData = defaults.dataForKey(NewsTextKey) {
            let textNewsDict = NSKeyedUnarchiver.unarchiveObjectWithData(objectsData) as! [String:String]
            return textNewsDict[newsId]
        }
        
        //не удалось восстановить текст новости
        return nil
    }
    
    //MARK: Likes
    
    /**
    Set like/unlike for news
    */
    func saveMyLike(newsId:String, like:Bool) {
        var likes = self.restoreLikesDict()
        
        if like {
            likes[newsId] = true
        } else {
            likes.removeValueForKey(newsId)
        }
        self.saveLikesDict(likes)
    }

    
    /**
    Returns True if the news we liked
    */
    func isLikedNews(newsId:String) -> Bool {
        let likes = self.restoreLikesDict()
        
        //if there is an element, then liked
        if let likedFlag = likes[newsId]{
            return true
        }
        return false
    }
    

    //MARK: PendingLikes
    
    
    /**
    Save pending like
    
    :returns: true if pending like stored
    */
    
    func savePendingLike(newsId:String, like:Bool) -> Bool {
        var pendingLikesDict = self.restorePendingLikes()
        var storedLikeValue = pendingLikesDict[newsId]
        
        if storedLikeValue == nil {
            //add this like as pending
            pendingLikesDict[newsId] = like
            
        } else {
            //remove pending like
            if storedLikeValue != like {
                pendingLikesDict.removeValueForKey(newsId)
            }else{
                println("Warning! Unbalanced PendingLike add/remove")
            }
        }
        return self.savePendingLikesDict(pendingLikesDict)
    }
    
    
    /**
    Delete penfing like
    
    :returns: true if like deleted
    */
    func deletePendingLike(newsId:String) -> Bool {
        var likesDict = self.restorePendingLikes()
        
        if likesDict[newsId] != nil {
            likesDict.removeValueForKey(newsId)
            return self.savePendingLikesDict(likesDict)
        }
        return false
    }
    
    
    /**
    Restore pending likes dictionary
    key - news id, value - is liked (Bool)
    
    :returns: pending likes dictionary
    */
    func restorePendingLikes() -> [String:Bool]{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let objectsData:NSData = defaults.dataForKey(PendingLikesKey),
            let likesDict = NSKeyedUnarchiver.unarchiveObjectWithData(objectsData) as? [String:Bool] {
                return likesDict
        }else{
            return [String:Bool]()
        }
    }
    
    


}

//MARK: Private
private extension NewsCache {
    
    /**
    Save likes
    
    :param: likes [String:Bool] (news id : liked)
    */
    private func saveLikesDict(likes:[String:Bool]) -> Void {
        let defaults = NSUserDefaults.standardUserDefaults()
        let objectsData = NSKeyedArchiver.archivedDataWithRootObject(likes)
        
        defaults.setObject(objectsData, forKey: LikesKey)
        defaults.synchronize()
    }
    
    
    /**
    Restore likes
    
    :returns: [String:Bool] (news id : liked)
    */
    private func restoreLikesDict() -> [String:Bool] {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let objectsData:NSData = defaults.dataForKey(LikesKey) {
            let likesDict = NSKeyedUnarchiver.unarchiveObjectWithData(objectsData) as? [String:Bool]
            return likesDict!
        }
        return [String:Bool]()
    }

    
    /**
    Save pending likes dictionary
    
    :param: pendingLikes pending likes dictionary. key - news id, value - is liked (Bool)
    
    :returns: true if saved
    */
    private func savePendingLikesDict(pendingLikes:[String:Bool]) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        //save
        let objectsData = NSKeyedArchiver.archivedDataWithRootObject(pendingLikes)
        defaults.setObject(objectsData, forKey: PendingLikesKey)
        return defaults.synchronize()
    }
    
    
}

