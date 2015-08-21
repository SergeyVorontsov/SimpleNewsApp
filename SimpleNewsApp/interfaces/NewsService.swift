//
//  NewsService.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation

protocol NewsService {
    
    //news
    func getNews(callback: ([News]? , NSError?) -> Void )
    func getNewsText(newsId:String, callback: (String? , NSError?) -> Void )
    
    //likes
    func putLikeForNews(newsId:String, like:Bool, callback: (Bool, NSError?) -> Void )
    
}