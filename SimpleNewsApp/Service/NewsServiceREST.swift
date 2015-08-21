//
//  NewsServiceREST.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


/// Service to communicate with the Parse
class NewsServiceREST : NewsService {

    /**
    Getting a news list
    
    :param: callback ([News]? , NSError?) -> Void
    */
    func getNews(callback: ([News]? , NSError?) -> Void ) {
        let request = Alamofire.request(.GET, AppSettings.parseNewsPath, headers: HttpHeaders())
        
        request.responseJSON {
            (_,_, json , error) in
            if let json = json as? [String:AnyObject] where error == nil {
                var newsList = [News]()
                let jsonArray = JSON(json)["results"].arrayValue
                for jsonElement in jsonArray {
                    if let news = self.newsFromJson(jsonElement){
                        newsList.append(news)
                    }
                }
                callback(newsList,nil)
            }else{
                callback(nil, NSError())
            }
        }
    }
    
    
    /**
    Getting text news with id News
    
    :param: newsId news id
    :param: callback (String? , NSError?) -> Void
    */
    func getNewsText(newsId:String, callback: (String? , NSError?) -> Void){
        let urlString = AppSettings.parseNewsPath + "/\(newsId)"
        let detailsFieldName = "details"
        let parameters = ["include": detailsFieldName]
        let request = Alamofire.request(.GET, urlString, parameters: parameters, headers: HttpHeaders())
        
        request.responseJSON {
            (_,_, json , error ) in
            if let json = json as? [String:AnyObject]  where error == nil {
                let newsText = JSON(json)[detailsFieldName]["text"].string
                callback(newsText,nil)
            }else{
                callback(nil, NSError())
            }
        }
    }

    
    /**
    Add / Remove like
    
    :param: newsId news id
    :param: like If **true** like. If **false** ullike.  Default like = true
    :param: callback success, NSError or nil
    */
    func putLikeForNews(newsId:String, like:Bool = true, callback: (Bool, NSError?) -> Void ){
        let urlString = AppSettings.parseNewsPath + "/\(newsId)"
        let likeIncrementAmount = like ? 1 : -1
        let parameters = ["likeCount" : ["__op":"Increment","amount":likeIncrementAmount]]
        let request = Alamofire.request(.PUT, urlString, parameters: parameters, encoding: .JSON,
            headers: HttpHeaders())
        
        request.responseJSON { (_,_,result,error) in
            let success = (error == nil)
            callback(success, error)
        }
    }


}

//MARK: - Helper
private extension NewsServiceREST {

    /**
    HTTP headers used in queries to Parse. Firstly for authorization.
    
    :returns: HTTP headers [String:String]
    */
    private func HttpHeaders() -> [String:String] {
        let headers = [
            "Content-Type": "application/json",
            "X-Parse-Application-Id": AppSettings.parseApplicationId,
            "X-Parse-REST-API-Key": AppSettings.parseApiKey
        ]
        return headers
    }

}

// MARK: - JSON -> News
private extension NewsServiceREST {
    
    /**
    Creates an object from JSON News
    
    :param: json JSON containing news
    
    :returns: News
    */
    private func newsFromJson(json:JSON) -> News? {
        
        //validate json
        //if invalid  - return nil instead news
        if isValidNewsJson(json) == false{
            return nil
        }
        
        //conversion date from Parse format to NSDate
        var date:NSDate?
        if let timeStr = json["time"]["iso"].string {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sZ"
            date = dateFormatter.dateFromString(timeStr)
        }
        
        let time = date ?? NSDate()
        let id = json["objectId"].stringValue
        let title = json["title"].stringValue
        let summary = json["summary"].stringValue
        let imageUrl = json["imageUrl"].stringValue
        let likeCount = json["likeCount"].intValue
        
        let news = News(id: id, time: time, title: title, summary: summary,
            imageUrl: imageUrl, likeCount: likeCount)
        return news
    }
    
    
    /**
    Checks mandatory data in JSON News
    
    :returns: true - is valid
    */
    func isValidNewsJson(json:JSON) -> Bool{
        var valid = true
        
        //Checks news date
        let timeStr = json["time"]["iso"].string
        if timeStr == nil {
            valid = false
        }
        return valid
    }

    
}

