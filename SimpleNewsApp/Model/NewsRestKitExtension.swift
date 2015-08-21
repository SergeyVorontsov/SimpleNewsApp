//
//  NewsRestKitExtension.swift
//  SimpleNewsApp
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey Vorontsov. All rights reserved.
//

import Foundation
import RestKit

// MARK: - extension for restKit
extension News {
    
    /// Mapping for RestKit ResponseDescriptor
    class func mapping() -> RKObjectMapping {
        let newsMapping = RKObjectMapping(forClass: News.self)
        
        newsMapping.addAttributeMappingsFromDictionary(
            [
                "time.iso" 		: "time",
                "objectId" 		: "id",
                "title" 		: "title",
                "summary" 		: "summary",
                "imageUrl" 		: "imageUrl",
                "likeCount" 	: "likeCount",
                "details.text" 	: "text"
            ])
        
        return newsMapping
    }
    
    
    convenience init(id:String) {
        self.init()
        self.id = id
    }
    
}