FundUP
===================

Mobile app for FBLA Mobile App Design, will be displayed for judges at the Wisconsin SLC Event.

Introduction
-------------
FundUP is a mobile crowdfunding app made to help users fund their trip to Nationals by selling used/old items. The app includes full posting and commenting support so users can interact with others within the app itself natively.

Features
-------------

 - Authentication (Over SSL)
 - Login, Register, and Reset password pages
 - Fully supported Image and Text Posting
 - Username creation
 - Profile page containing logout and user posts
 - Full UI
 - Artwork (Logo, appicon, etc)
 - Full Slide-To-Refresh support on posts
 - Details page for each post displaying extra info
 - Image caching to save on data usage
 - Take Photo/Library Option when posting
 - Commenting support for each post
 
Requirements
-------------
 - An iOS device/simulator running iOS 10.0 or higher
 - Xcode 8.2 or higher
 - An active Internet connection

Installation
-------------
 **In order to install this application a Mac running Xcode will be needed.**
	 1. Open the archive and click on `fblamobileapp.xcworkspace`
	 2.  Once the project is loaded, select a device from the drop-down near the top-left corner (This can be a simulator or a real device)
	 3. Once a device is selected, press the icon that is very similar to a play button to run the project.
	 4. If running on an actual device, make sure to accept any prompts so the app builds correctly. You also may need to go to Settings -> General -> Profile & Device Management -> Look under 'Developer Apps' -> Accept FundUP
	  **Note:** If running on a device, make sure it is unlocked before it is plugged in.

Software Used
-------------

 - Xcode - IDE used to develop iOS applications
 - Swift - A fairly new programming language used within iOS applications
 - Firebase: A highly scabable realtime database used for FundUP's backend
 - Kingfisher: An image caching add-in used to save data usage within FundUP

When developing FundUP, I used Xcode by Apple as my IDE (Integrated Development Enviornment) and I also used the lastest version of Swift (Version 3.0.2 at publish date) as my programming language. I used Pods to easily install Firebase to connect to my backend and Kingfisher to cache images within the app.

Sources
-------------

When I first approched doing this FBLA event, I knew that Swift would be a great language to program in. However, I didn't have a great amount of knowledge with Swift and the backend I planned on using (Firebase), so I referred to some of the tutorials from the YouTube user 'TheSwiftUniverse' on gettings started with Swift and Firebase. I also used StackOverflow to look through some already-answered topics to better understand how to use Realtime Database in Swift.

Troubleshooting
-------------

 - App isn't loading any posts or is throwing errors about the 'connection'
 A: Your device isn't connected to the Internet or your connection is weak. Try switching networks, move closer to the Internet source, or connect to the Internet.
 
  - Why can't I use the camera?
  A: If you receive an error while trying to launch the camera then either your device doesn't have a camera or your camera isn't working. If your camera has stopped functioning, please call Apple to repair your device.
  
  - Why can't I delete my post/comment?
  A: The deletion of posts/comments is done automatically by a moderator of FundUP after a listing has been completed. If you'd like to have a comment/post removed before the listing is completed, please contact gabe@zimbri.cc so it can be done as soon as possible.
  
Copyright
-------------
FundUP was built with XCode, CocoaPods, Firebase, and KingFisher. All code included in FundUP was specifically made for the app itself.

 - XCode: Copyright © 2017 Apple Inc. All rights reserved.
 - CocoaPods: Copyright © 2017 CocoaPods. CocoaPods is icensed under the MIT license.
 - Firebase: Copyright © 2017 Alphabet Inc. All rights reserved.
 - KingFisher: Copyright © 2017 Wei Wang (@onevcat). KingFisher is icensed under the MIT license.
