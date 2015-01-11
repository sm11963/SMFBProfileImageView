# SMFBProfileImageView

[![CI Status](https://travis-ci.org/sm11963/SMFBProfileImageView.svg?branch=master&style=flat)](https://travis-ci.org/Sam Miller/SMFBProfileImageView)
[![Version](https://img.shields.io/cocoapods/v/SMFBProfileImageView.svg?style=flat)](http://cocoadocs.org/docsets/SMFBProfileImageView)
[![License](https://img.shields.io/cocoapods/l/SMFBProfileImageView.svg?style=flat)](http://cocoadocs.org/docsets/SMFBProfileImageView)
[![Platform](https://img.shields.io/cocoapods/p/SMFBProfileImageView.svg?style=flat)](http://cocoadocs.org/docsets/SMFBProfileImageView)

## Benefits
* Just as simple as using the `FBProfilePictureView` class.
* Uses the AFNetworking library to manage image downloads making it easy to add additional control.
* Fixes an issue that `FBProfilePictureView` has when used in a tableview. See [FBProfilePictureView in UITableView](#fbprofilepictureview-in-uitableview) below.

### FBProfilePictureView in UITableView

The original `FBProfilePictureView` has an issue where images in a UITableView will not be set until scrolling is stopped.

![fbprofilepictureview_scrolling_small](https://cloud.githubusercontent.com/assets/1255071/5689837/451b1d9a-983c-11e4-90d7-88ed3e4e534e.gif)

This is caused by scheduling the connection handler block to run in the default run loop mode. Therefore, the connection handler block, which sets the image, is not run until scrolling is completed. The fix, which AFNetworking does by default, is to set the runloop mode to NSRunLoopCommonModes when scheduling the connection handler. You can see the difference it makes with [SMFBProfileImageView in UITableView](#smfbprofileimageview-in-uitableview) below.

### SMFBProfileImageView in UITableView

![smfbprofileimageview_scrolling_small](https://cloud.githubusercontent.com/assets/1255071/5689838/451ebd60-983c-11e4-9805-6ba82875b0e5.gif)

## The Example Project
To run the example project, clone the repo, and run `pod install` from the Example directory first.

You can simply run the application and you will be presented with a screen to enter a Facebook user ID, you can find your own by using the [Facebook Graph Explorer tool](https://developers.facebook.com/tools/explorer). **If you have having an issue with images loading, read [Setting the Access Token](#setting-the-access-token) below**.

### Setting the Access Token

You can easily set a Facebook access token for the access token. Just copy a temporary access token (you can just copy the one provided by [Facebook Graph Explorer tool](https://developers.facebook.com/tools/explorer)). Then find `SMViewController.h` in the example project and find the section of code:

```objective-c
/* UNCOMMENT TO USE YOUR OWN ACCESS TOKEN (you can use a temporary one
 * from http://developers.facebook.com/tools/explorer
 */
//#define kAccessToken @""
```

Uncomment the define line and paste the access token between the quotes so it looks like this:

```objective-c
#define kAccessToken @"<your access token>"
```

Now when running the example app, the access token you added will be used to quary Facebook and should allow you to view all public images and all the pictures in the list example.

## Usage

This class is based off of `FBProfilePictureView` provided with the [Facebook-iOS-SDK](https://github.com/facebook/facebook-ios-sdk) and will attempt to maintain the same API as descibed in the [Facebook iOS SDK docs](https://developers.facebook.com/docs/reference/ios/current/class/FBProfilePictureView/).

### Basic usage

The following code creates a SMFBProfileImageView instance with a users facebook ID. This will automatically load the users profile picture and display the FB placeholder image while loading.

```objective-c
SMFBProfileImageView *profileImageView = [[SMFBProfileImageView alloc] initWithProfileID:@"<profile id>"
 					     		                 pictureCropping:FBProfilePictureCroppingSquare];
```

You can also create an instance of the view without profile ID or picture cropping and set those properties later.


```objective-c
// Method 1 - Use default initializer with nil ID
SMFBProfileImageView *profileImageView = [[SMFBProfileImageView alloc] initWithProfileID:nil
 					     		                 pictureCropping:FBProfilePictureCroppingSquare];
profileImageView.profileID = @"<facebook user ID>";

// Method 2 - Create profileImageView and set all properties later
SMFBProfileImageView *profileImageView2 = [SMFBProfileImageView new];
profileImageView2.profileID = @"<facebook user ID>";
profileImageView2.pictureCropping = FBProfilePictureCroppingOriginal;
```

### Added Functionality to FBProfilePictureView

By default, `SMFBProfileImageView` instances use Facebook's graph api version 2.2 and attempts to use a Facebook access token from the Facebook SDK `[FBSession activeSession]`. This behavior can be modified by setting the API version to use or setting the access token to use.

```objective-c
SMFBProfileImageView *profileImageView = [SMFBProfileImageView new];
profileImageView.pictureCropping = FBProfilePictureCroppingOriginal;

// Set the API version to use
profileImageView.graphVersion = @"2.0";

// Set the access token to use
profileImageView.accessToken = @"<access token";

// When specifying version and/or access token to use, must set profileID afterwards
// to ensure using the new access token and version.
profileImageView.profileID = @"<facebook user ID>";
```

To make an instance use the access token from `[FBSession activeSession]` *after explicitly setting the access token*:

```objective-c
profileImageView.accessToken = nil;
```

## Requirements

In order to load every profile photo, it may be necessary to use a Facebook access token. This will require following the [Facebook Getting Started Guide](https://developers.facebook.com/docs/ios/getting-started/) to get an App ID and opening a session in the app. Once a FB session is open in your application, `SMFBProfileImageView` should work as expected.

## Installation

SMFBProfileImageView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "SMFBProfileImageView", "0.6.0"

## Change Log

#### 0.6.0
* Changed image loading to use the `UIImageView+AFNetworking` category for dedicated image loading support.

#### 0.5.0
* Initial public release

## Author

Sam Miller, sm11963@gmail.com

## License

SMFBProfileImageView is available under the Apache 2.0 license. See the LICENSE file for more info.

