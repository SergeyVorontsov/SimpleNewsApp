//
//  NewsInternalStorage.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation

protocol NewsInternalStorage {

    //news
    func saveNewsList(newsList:[News])
    func restoreNewsList() -> [News]?
    func saveNewsText(newsId:String, text:String)
    func restoreNewsText(newsId:String) -> String?
    
    //likes
    func saveMyLike(newsId:String, like:Bool)
    func isLikedNews(newsId:String) -> Bool
    
    //pending likes
    func savePendingLike(newsId:String, like:Bool) -> Bool
    func deletePendingLike(newsId:String) -> Bool
    func restorePendingLikes() -> [String:Bool]
    
}