# Optima-Coding-Challenge

## Requirements
- Language: Swift 4.0
- Runtime: iOS: 10.0+
- Base SDK: 11.0
- IDE: XCode: 9.0 (9A235)

## Description
This application is to complete the code challenge from Optima. The focus of this app is to get the user to log in from their google account and be able to search and view youtube videos. This app follows the current Apple standards.

## Technical Details
This app uses apple's default MVC pattern. The application starts from a splash screen created in Launch.storyboard before moving on to Main.Storyboard. The app starts with “GoogleSignInViewController” as the first view controller. In this controller, if the user has logged in before then the app silently logs them in otherwise asks the user to log in using their Google account. After the login has been successfully performed, the app moves to the “SearchCollectionViewController”.

In “SearchCollectionViewController”, the user will find a search bar where the user can type in keywords to search for videos. From the search results, the application will fetch 30 videos that can be scrolled through. If the user scrolls all the way to the bottom, the next 30 videos are fetched using the NextPageToken. 

The app uses Youtube Helped View to start playing the videos. The user will tap on the video and the video will start playing in full screen.

## References
- Code Challenge-Optima9-2017.pdf
- YouTube Data API: https://developers.google.com/youtube/v3/quickstart/ios?ver=swift
- YouTube Helper: https://developers.google.com/youtube/v3/guides/ios_youtube_helper
- IonIcons: https://github.com/ionic-team/ionicons
