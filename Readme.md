# HackerNews Deleter iOS App
This is a simple program that pulls HackerNews iOS articles from an API and displays the most recent articles. There are two interactions that the user can perform.

1. View one of the HackerNews articles. The user can click on any of the HackerNews articles to open a UIWebView in a modal. 
2. Delete an article from the list. A user can swipe to delete one of the HackerNews articles. Once deleted, the article will not appear again, even if the user pulls down and refreshes the feed.

## How to run
This project uses CocoaPods to manage libraries. To install the Libraries you can run `pod install` from any terminal that has CocoaPods. Since the project uses CocoaPods you must open the “ReignProject.xcworkspace” file (and not the .xcodeproj file). This project requires iOS 8.0 or above.

## Libraries
1. [Realm](https://realm.io) - Realm is a mobile database replacement for Core Data & SQLite. It makes storing local data very simple.
2. [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) - ObjectMapper makes mapping JSON data coming from an API into Realm Objects easy.
3. [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift. This is the libary used to call the HackerNews API.
4. [PureLayout](https://github.com/PureLayout/PureLayout) - This libary makes it easy to add autolayout constraints in code.
5. [Reachability](https://github.com/ashleymills/Reachability.swift) - This is to check if you have an internet connection to allow a pull to refresh


## Design Decisions
1. When deleting a post it was ambiguous whether to not show the same article until the next pull to refresh event or forever. I figured that the user would never want to see that article again, so I made it so all deleted posts were saved in Realm and when the pull to refresh event occured, it would not import or show any post that had already been deleted.
2. I opted for a modal view for the webview. This allowed for a more intuitive browsing experience when on the web. If the user clicks on a link in the webView, they will navigate to a new page in the same webview. From there, the user should be able to navigate back in the webview. This is a similar implementation to Twitter.



## Overall structure
I structured this app so that there are multiple managing classes that are responsible for different parts of the app
### Data Managers
- ConnectivityManager - This is responsible for determining if the app has a network connection
- HomeFeedManager - This manager is responsible for getting, updating, and anything having to do with the Home feed
- RealmManager - This manager is responsible for fetching and saving any items to and from the local Realm database.
- HTTPManager - This manager is responsible for all network calls.
### Views
- ViewController - This is the main homefeed
- ItemWebViewController - This is the UIViewController for the UIWebViews when the user taps on an item and has a network connection.
- ItemTableViewCell - This is the view for the UITableViewCell for the home feed.
### Models
- Item - The Item model is the Realm object that gets saved and querried.
### Other components
- RealmDateTransform - Realm doesn’t store NSDates precise enough, so I convert the incoming dates from JSON to a double to store accurately (I learned this on a previous project)
- Constants - this stores the fonts, sizes for padding, overall screen size, etc. to be referenced
