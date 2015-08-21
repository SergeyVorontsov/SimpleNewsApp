//
//  AppSettings.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation

class AppSettings {
    
    //copy keys from https://www.parse.com/account/keys
    static let parseApplicationId = "YrPZkd9Tf4pscswvWNd2APVResR8KXHpghfcFVbS"
    static let parseClientKey = "41Y9HufiB1MQvQq38ADSqPlreNqUu3trgqjYBEzz"
    static let parseApiKey = "YOUR_PARSE_APPLICATION_REST_API_KEY"

    static let parseServerHost = "https://api.parse.com"
    static let parseApiPathPrefix = "/1/classes"
    static let parseNewsClassName = "Article"

    static let parseNewsPathPattern = "\(parseApiPathPrefix)/\(parseNewsClassName)"
    static let parseNewsPath = "\(parseServerHost)\(parseApiPathPrefix)/\(parseNewsClassName)"

    var newsService:NewsService
    var newsInternalStorage:NewsInternalStorage
    
    static var defaultSetting:AppSettings!
    
    init(newsService:NewsService, newsInternalStorage:NewsInternalStorage){
        self.newsService = newsService
        self.newsInternalStorage = newsInternalStorage

        if AppSettings.defaultSetting == nil {
            AppSettings.defaultSetting = self
        }
    }
    
}
