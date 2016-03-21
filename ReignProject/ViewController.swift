//
//  ViewController.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import UIKit
import PureLayout

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var connectivityView: MBConnectivityView!
    var loadingIndicator: UIActivityIndicatorView!
    
    var feedRefreshController: UIRefreshControl = UIRefreshControl.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.registerClass(ItemTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 74.0
        
        self.view.addSubview(tableView)
        tableView.autoPinEdgeToSuperviewEdge(.Top)
        tableView.autoPinEdgeToSuperviewEdge(.Bottom)
        tableView.autoPinEdgeToSuperviewEdge(.Left)
        tableView.autoPinEdgeToSuperviewEdge(.Right)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: 20.0))
        view.backgroundColor = UIColor.init(colorLiteralRed: 255.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        self.view.addSubview(view)
        
        view.autoPinEdgeToSuperviewEdge(.Top)
        view.autoSetDimension(.Height, toSize: 20.0)
        view.autoPinEdgeToSuperviewEdge(.Left)
        view.autoPinEdgeToSuperviewEdge(.Right)
        
        connectivityView = MBConnectivityView(yVal: 20.0)
        self.view.addSubview(connectivityView)
        
        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator?.hidesWhenStopped = true
        self.view.addSubview(loadingIndicator!)
        
        
        loadingIndicator?.autoAlignAxisToSuperviewAxis(.Horizontal)
        loadingIndicator?.autoAlignAxisToSuperviewAxis(.Vertical)
        
        self.feedRefreshController.addTarget(self, action: "handlePullToRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(feedRefreshController)
        
        HomeFeedManager.getLocalFeed { () -> Void in
            self.tableView.reloadData()
        }
        
        
        //If there is nothing, we will initiate a refresh
        if (ConnectivityManager.isCurrentlyReachable() && HomeFeedManager.feedIsEmpty()){
//            self.feedRefreshController.beginRefreshing()
            loadingIndicator.startAnimating()
            HomeFeedManager.fetchFeedWithBlock({ () -> Void in
                HomeFeedManager.getLocalFeed({ () -> Void in
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData()
                    self.feedRefreshController.endRefreshing()
                })
            })
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = HomeFeedManager.itemForRow(indexPath.row)
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ItemTableViewCell
        cell.titleLabel.text = item.safeItemTitle()
        cell.subtitleLabel.text = item.safeSubtitle()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            HomeFeedManager.deleteItemAtRow(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (ConnectivityManager.isCurrentlyReachable()){
            let vc = ItemWebViewController()
            vc.webUrl = HomeFeedManager.urlForRow(indexPath.row)
            self.presentViewController(vc, animated: true, completion: nil)
        }else{
            connectivityView.animateIn(0.3, closure: { () -> Void in
                
            })
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeFeedManager.numberOfItems()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func handlePullToRefresh(refreshControl: UIRefreshControl){
        if (ConnectivityManager.isCurrentlyReachable()){
            HomeFeedManager.deleteFeed()
            self.tableView.reloadData()
            HomeFeedManager.refreshFeedWithBlock { () -> Void in
                self.tableView.reloadData()
                self.feedRefreshController.endRefreshing()
                
            }
        }else{
            connectivityView.animateIn(0.3, closure: { () -> Void in
                
            })
            self.feedRefreshController.endRefreshing()
        }
        
        
        
    }


}

