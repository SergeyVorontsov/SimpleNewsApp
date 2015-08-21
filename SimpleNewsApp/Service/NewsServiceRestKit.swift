//
//  NewsServiceRestKit.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation
import AFNetworking
import RestKit


/// Service to communicate with Parse through RestKit
class NewsServiceRestKit: NewsService {
    
    /// RestKit object manager
    private let objectManager:RKObjectManager!
    private let httpClient:AFHTTPClient!
    
    init(){
        
        // initialize AFNetworking HTTPClient
        let baseURL = NSURL(string: AppSettings.parseServerHost)
        httpClient = AFHTTPClient(baseURL: baseURL)
        httpClient.setDefaultHeader("X-Parse-Application-Id", value: AppSettings.parseApplicationId)
        httpClient.setDefaultHeader("X-Parse-REST-API-Key", value: AppSettings.parseApiKey)
        httpClient.parameterEncoding = AFJSONParameterEncoding
        
        // initialize RestKit
        objectManager = RKObjectManager(HTTPClient: httpClient)
        
        // configure RestKit
        configureResponseDescriptors()
    }
    
    
    //news
    func getNews(callback: ([News]? , NSError?) -> Void ) {
        RKObjectManager.sharedManager().getObjectsAtPath(AppSettings.parseNewsPathPattern, parameters: nil,
            success:{ operation, mappingResult in
                let news = mappingResult.array() as? [News]
                callback(news,nil)
            },
            failure:{ operation, error in
                callback(nil,error)
            }
        )

    }
    
    
    func getNewsText(newsId:String, callback: (String? , NSError?) -> Void ) {
        let news = News(id: newsId)
        let parameters = ["include": "details"]
        
        RKObjectManager.sharedManager().getObject(news, path: nil, parameters: parameters,
            success: { (operation, result) -> Void in
                if let news = result.firstObject as? News {
                    callback(news.text,nil)
                } else {
                    callback(nil,nil)
                }
            },
            failure: { (operation, error) -> Void in
                callback(nil,error)
            }
        )
    }
    
    //likes
    func putLikeForNews(newsId:String, like:Bool, callback: (Bool, NSError?) -> Void ) {
        let likeIncrementAmount = like ? 1 : -1
        let parameters = ["likeCount":["__op":"Increment","amount":likeIncrementAmount]]
        let path = AppSettings.parseNewsPathPattern + "/\(newsId)"
        
        httpClient.putPath(path, parameters: parameters,
            success: { (operation, result) -> Void in
                callback(true, nil)
            },
            failure: { (operation, error) -> Void in
                callback(false, error)
            }
        )
    }
    

    //MARK: - Private
    private func configureResponseDescriptors(){
        let successStatusCodes = RKStatusCodeIndexSetForClass(.Successful)
        
        // News mapping
        let newsMapping = News.mapping()
        
        // register news mappings with the provider using a response descriptor
        let ListResponseDescriptor = RKResponseDescriptor(mapping: newsMapping, method: .GET, pathPattern: AppSettings.parseNewsPathPattern, keyPath: "results", statusCodes: successStatusCodes)
        objectManager.addResponseDescriptor(ListResponseDescriptor)
        
        
        // register mappings and routing for get news object with news id
        let objectResponseDescriptor = RKResponseDescriptor(mapping: newsMapping, method: .GET, pathPattern: AppSettings.parseNewsPathPattern + "/:id", keyPath: nil, statusCodes: successStatusCodes)
        objectManager.addResponseDescriptor(objectResponseDescriptor)
        
        objectManager.router.routeSet.addRoute(RKRoute(withClass: News.self, pathPattern: AppSettings.parseNewsPathPattern + "/:id", method: .GET))
        
    }
}

