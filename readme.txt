	Description
	
	This project is RSS feed reader of two channels: Washington Post & Daily Mirror.
	It has developed for IOS 9.0, for iPhone devices and portrait landscape.
	Before launching this app on your Mac you must install all libraries with Cocoapods library manager. You can refer for more information here: https://cocoapods.org.
	It has written on Objective-C language with implementation MVVM (Model ViewModel View) architecture. For data binding it’s using KVO (Key Value Observing pattern), which uses Facebook KVOController framework. Data loading uses AFNetworking framework with image caching and checking network reachability. For saving feeds in local database it uses CoreData model database with MagicalRecord framework, which saves feed in background thread. Also this application uses RSS2JSON API. It allows convert RSS to JSON, that provides more easy way for parsing data with JSON Searializer (than parsing data RSS in XML). It sends an URL of RSS, api key and amount of news in feed in GET request. The views have divided on separate storyboards and using auto layouts for all screen sizes.
	This application has three screens - news feed, details of concrete news article and browser of it in the internet. In news feed screen the user can change the required channel with tapping on right button in navigation bar. If internet connection has disconnected or request error has occured, the application will inform user. Also user can search required article in news feed by prefix of title. On details screen application shows article main image, title and short description. User can increase the image by tap and after with pinch get any size of picture. By next tap the image has returned on its primary size. By clicking on right button user can browse chosen article in web on third screen.
	Also this application has located on five languages: English, Russian, German, Spanish and Japanese.
	You can see few screenshots in Screenshots project directory.

	



