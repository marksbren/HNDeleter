//
//  ItemWebViewController.swift
//  ReignProject
//
//  Created by Mark Brenneman on 3/18/16.
//  Copyright © 2016 Mark Brenneman. All rights reserved.
//

import Foundation
import UIKit

class ItemWebViewController: UIViewController, UIWebViewDelegate, UINavigationBarDelegate {
    var webView: UIWebView!
    var webUrl: String?
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var loadingIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: Constants.screenSize.width, height: Constants.defaultNavbarHeight))
        navigationBar.tintColor = UIColor.blueColor()
        self.view.addSubview(navigationBar)
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "icnNavClose"), style: UIBarButtonItemStyle.Plain, target: self, action: "closeWebView:")
        
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = rightButton
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
    
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.screenSize.width, height: Constants.defaultLineHeight))
        toolBar.barStyle = UIBarStyle.Default
        backButton = UIBarButtonItem(image: UIImage(named: "previous"), style: UIBarButtonItemStyle.Plain, target: self, action: "navigateBack:")
        forwardButton = UIBarButtonItem(image: UIImage(named: "next"), style: UIBarButtonItemStyle.Plain, target: self, action: "navigateForward:")
        let shareButton = UIBarButtonItem(image: UIImage(named: "upload"), style: UIBarButtonItemStyle.Plain, target: self, action: "shareButtonTapped:")
        backButton.enabled = false
        forwardButton.enabled = false
        
        toolBar.setItems([backButton,forwardButton,shareButton], animated: false)
        self.view.addSubview(toolBar)
        
        
        webView = UIWebView(frame: CGRect(x: 0, y: 0.0, width: Constants.screenSize.width, height: Constants.screenSize.height))
        webView.delegate = self
        self.view.addSubview(webView)
        
        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50))
        loadingIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator?.hidesWhenStopped = true
        webView.addSubview(loadingIndicator!)
        loadingIndicator?.startAnimating()
        
        
        loadingIndicator?.autoAlignAxisToSuperviewAxis(.Horizontal)
        loadingIndicator?.autoAlignAxisToSuperviewAxis(.Vertical)
        
        navigationBar.autoPinEdgeToSuperviewEdge(.Top, withInset: 0.0)
        navigationBar.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        navigationBar.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)
        navigationBar.autoSetDimension(.Height, toSize: Constants.defaultNavbarHeight)
        
        toolBar.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0.0)
        toolBar.autoPinEdgeToSuperviewEdge(.Left, withInset: 0.0)
        toolBar.autoPinEdgeToSuperviewEdge(.Right, withInset: 0.0)
        toolBar.autoSetDimension(.Height, toSize: Constants.defaultLineHeight)
        
        webView.autoPinEdge(.Top, toEdge: .Bottom, ofView: navigationBar)
        webView.autoPinEdge(.Bottom, toEdge: .Top, ofView: toolBar)
        webView.autoPinEdgeToSuperviewEdge(.Left)
        webView.autoPinEdgeToSuperviewEdge(.Right)
        
        loadWebPage()
    }
    
    func closeWebView(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigateBack(sender: UIBarButtonItem){
        print("navigate back")
        webView.goBack()
    }
    
    func navigateForward(sender: UIBarButtonItem){
        print("navigate forward")
        webView.goForward()
    }
    
    func shareButtonTapped(sender: UIBarButtonItem){
        let currentUrl = webView.stringByEvaluatingJavaScriptFromString("window.location")
        let activityViewController = UIActivityViewController(activityItems: [currentUrl! as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
    func loadWebPage() {
        let url = NSURL(string: webUrl!)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingIndicator?.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingIndicator?.stopAnimating()
        backButton.enabled = webView.canGoBack
        forwardButton.enabled = webView.canGoForward
    

    }
}