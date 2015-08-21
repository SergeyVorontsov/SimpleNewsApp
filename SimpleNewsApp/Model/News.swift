//
//  News.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import UIKit
import SwiftyJSON

class News : NSObject, NSCoding {
    var id:String
    var time:NSDate
    var title:String
    var summary:String
    var imageUrl:String
    var likeCount:Int
    var text:String

    
    override init() {
        self.id = ""
        self.time = NSDate()
        self.title = ""
        self.summary = ""
        self.imageUrl = ""
        self.likeCount = 0
        self.text = ""
        super.init()
    }
    
    init (id:String, time:NSDate, title:String, summary:String,
        imageUrl:String, likeCount:Int, text:String = ""){
        self.id = id
        self.time = time
        self.title = title
        self.summary = summary
        self.imageUrl = imageUrl
        self.likeCount = likeCount
        self.text = text
    }
    
    
    //MARK: - NSCoding
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObjectForKey("id") as? String ?? ""
        self.time = decoder.decodeObjectForKey("time") as? NSDate ?? NSDate(timeIntervalSince1970: 0)
        self.title = decoder.decodeObjectForKey("title") as? String ?? ""
        self.summary = decoder.decodeObjectForKey("summary") as? String ?? ""
        self.imageUrl = decoder.decodeObjectForKey("imageUrl") as? String ?? ""
        self.likeCount = Int(decoder.decodeIntForKey("likeCount"))
        self.text = ""
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.id,forKey: "id")
        coder.encodeObject(self.time, forKey: "time")
        coder.encodeObject(self.title, forKey: "title")
        coder.encodeObject(self.summary, forKey: "summary")
        coder.encodeObject(self.imageUrl, forKey: "imageUrl")
        coder.encodeInt(Int32(self.likeCount), forKey: "likeCount")
    }

    
}

