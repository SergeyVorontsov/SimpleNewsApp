//
//  NewsTableViewController.swift
//  Simple News
//
//  Created by Sergey Vorontsov
//  Copyright (c) 2015 Sergey. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, NewsDataProviderDelegate {
    
    var newsDataProvider:NewsDataProvider!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "likeChengeNotify:",
            name: kLikeChengeNotify,
            object: nil)

        //configure refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshNews", forControlEvents: .ValueChanged)
        self.refreshControl = refreshControl
        
        //configure NewsDataProvider
        newsDataProvider = NewsDataProvider()
        newsDataProvider.delegate = self
        newsDataProvider.fetchNews(cachePolicy: .CacheThenNetwork)
        
        //configure tableView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 134
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    

    // MARK: -
    
    func refreshNews(){
        newsDataProvider.fetchNews(cachePolicy: .NetworkOnly)
    }
    
    
    func likeChengeNotify(notify:NSNotification){
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataProvider.newsCount()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        let newsItem = newsDataProvider.newsAtIndex(indexPath.row)
        
        cell.newsTitleLabel.text = newsItem.title
        cell.newsSummaryLabel.text = newsItem.summary
        cell.newsSummaryLabel.text = newsItem.summary
        cell.newsAgeLabel.text = newsItem.time.description
        cell.newsLikeCountLabel.text = "likes: \(newsItem.likeCount)"
        cell.newsAgeLabel.text = timeAgoSinceDate(newsItem.time)
        cell.setNewsImage(newsItem.imageUrl)
        return cell
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNewsDetails" {
            let newsDetailsVC = segue.destinationViewController as! NewsDetailsController
            let selectedNewsItemIndex = tableView.indexPathForSelectedRow()?.row ?? 0
            let selectedNews = self.newsDataProvider.newsAtIndex(selectedNewsItemIndex)
            
            newsDetailsVC.news = selectedNews
        }
    }

    
    //MARK: - NewsDataProviderDelegate
    func newsDataProviderNewsDidLoad(#dataProvider: NewsDataProvider) {
        if self.refreshControl?.refreshing == true {
            self.refreshControl?.endRefreshing()
        }
        self.tableView.reloadData()
    }

    
}
