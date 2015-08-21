//
//  NewsServiceParse.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation
import Parse


class NewsServiceParse : NewsService {
    
    init(){
        Parse.setApplicationId(AppSettings.parseApplicationId,
            clientKey: AppSettings.parseClientKey)
    }
    
    
    //news
    func getNews(callback: ([News]? , NSError?) -> Void ){
        let requets = PFQuery(className: AppSettings.parseNewsClassName)
        
        requets.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects as? [PFObject] where error == nil {
                var newsList = [News]()
                for object in objects {
                    if let news = self.newsFromPFObject(object){
                        newsList.append(news)
                    }
                }
                callback(newsList,nil)
            }else{
                callback(nil, NSError())
            }
        }
    }
    
    
    func getNewsText(newsId:String, callback: (String? , NSError?) -> Void ){
        let requets = PFQuery(className: AppSettings.parseNewsClassName)
        
        requets.includeKey("details")
        requets.whereKey("objectId", equalTo: newsId)
        requets.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if let object = object,
                let details  = object.objectForKey("details") as? PFObject
                where error == nil {
                    let text  = details.objectForKey("text") as? String
                    callback(text,nil)
            }else{
                callback(nil, NSError())
            }
        }
    }
    
    
    //likes
    func putLikeForNews(newsId:String, like:Bool, callback: (Bool, NSError?) -> Void ){
        let likeIncrementAmount = like ? 1 : -1
        let news = PFObject(withoutDataWithClassName: AppSettings.parseNewsClassName, objectId: newsId)
        
        news.incrementKey("likeCount", byAmount: NSNumber(integer: likeIncrementAmount))
        news.saveInBackgroundWithBlock { (result, error) -> Void in
            callback(result, error)
        }
    }
    

}

// MARK: - PFObject -> News
private extension NewsServiceParse {
    
    /**
    Creates an object from JSON News
    
    :param: object PFObject news class
    
    :returns: News
    */
    private func newsFromPFObject(object:PFObject) -> News? {
        
        //if invalid  - return nil instead news
        if isValidParseObject(object) == false{
            return nil
        }
        
        let time = object.objectForKey("time") as! NSDate
        let id = object.objectId!
        let title = object.objectForKey("title") as! String
        let summary = object.objectForKey("summary") as! String
        let imageUrl = object.objectForKey("imageUrl") as! String
        let likeCountNumber = object.objectForKey("likeCount") as! NSNumber
        let likeCount = likeCountNumber.integerValue
        
        let news = News(id: id, time: time, title: title, summary: summary,
            imageUrl: imageUrl, likeCount: likeCount)
        return news
    }
    
    /**
    Checks mandatory data in PFObject for News
    
    :returns: true - is valid
    */
    func isValidParseObject(object:PFObject) -> Bool{
        
        func containsValue(key:String, className:String) -> Bool {
            if let object: AnyObject  = object.objectForKey(key) {
                if let aClass: AnyClass? = NSClassFromString(className) {
                    let result  = object.isKindOfClass(NSClassFromString(className))
                    return result
                }
            }
            return false
        }
        
        
        let fields = [
            ["key":"time", 		"type":"NSDate"],
            ["key":"title", 	"type":"NSString"],
            ["key":"summary", 	"type":"NSString"],
            ["key":"imageUrl", 	"type":"NSString"],
            ["key":"likeCount", "type":"NSNumber"]
        ]
        for field in fields {
            if containsValue(field["key"]!, field["type"]!) == false {
                return false
            }
        }
        return true
    }

}
