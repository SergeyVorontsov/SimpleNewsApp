# Simple news

Simple iOS application to demonstrate a few ways to interact with cloud service [Parse][].

1. Using Parse SDK
2. Using REST API Parse. (with [Alomofire][] and [SwiftyJSON][])
3. Using [RestKit][]

## Features

- news list and news details page
- like news
- trivial cache
- offline likes syncing

## Requirements

- iOS 8.0+
- Xcode 6.4


## Getting Started

1. `git clone https://github.com/SergeyVorontsov/SimpleNewsApp.git`
2. `cd SimpleNewsApp`
3. `pod install`
4. Open `SimpleNewsApp.xcworkspace` in Xcode
5. Compile and run the app

## Getting Started (Using your Parse application)

1) Create new Parse app

- Create new Parse app [here](https://www.parse.com/apps/new)
- Import two Parse classes with sample data.
  Tap **import** button in your Parse Core panel (`https://www.parse.com/apps/[YOUR_PARSE_APP_NAME]/collections`) and import [Article.json](SampleData/Article.json) , [ArticleDetails.json](SampleData/ArticleDetails.json)

2) Download the repository

```
git clone https://github.com/SergeyVorontsov/SimpleNewsApp.git
cd SimpleNewsApp
```

3)  Install the dependencies in project

```
pod install
```

4) Open `SimpleNewsApp.xcworkspace` in Xcode

5) Set Parse API keys [here](https://www.parse.com/account/keys) in `AppSettings.swift` file

```swift
class AppSettings {
    static let parseApplicationId = "YOUR_PARSE_APPLICATION_ID"
    static let parseClientKey = "YOUR_PARSE_APPLICATION_CLIENT_KEY"
    static let parseApiKey = "YOUR_PARSE_APPLICATION_REST_API_KEY"
    //...
}
```

6) Compile and run the app

## Configure news service
The way interact with the server is determined in method *didFinishLaunchingWithOptions* in class *AppDelegate*.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //...
        AppSettings.defaultSetting = AppSettings(
          newsService: NewsServiceParse(),
          newsInternalStorage: NewsCache()
        )

        return true
    }
```

The possible values for ***newsService*** parameter:

- instance of **NewsServiceParse** (by default)
- instance of **NewsServiceREST**
- instance of **NewsServiceRestKit**



[Parse]:https://www.parse.com
[Alomofire]:https://github.com/Alamofire/Alamofire
[SwiftyJSON]:https://github.com/SwiftyJSON/SwiftyJSON
[RestKit]:https://github.com/RestKit/RestKit
