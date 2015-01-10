# SMFBProfileImageView

[![CI Status](http://img.shields.io/travis/Sam Miller/SMFBProfileImageView.svg?style=flat)](https://travis-ci.org/Sam Miller/SMFBProfileImageView)
[![Version](https://img.shields.io/cocoapods/v/SMFBProfileImageView.svg?style=flat)](http://cocoadocs.org/docsets/SMFBProfileImageView)
[![License](https://img.shields.io/cocoapods/l/SMFBProfileImageView.svg?style=flat)](http://cocoadocs.org/docsets/SMFBProfileImageView)
[![Platform](https://img.shields.io/cocoapods/p/SMFBProfileImageView.svg?style=flat)](http://cocoadocs.org/docsets/SMFBProfileImageView)

## Benefits
* Just as simple as using the `FBProfilePictureView` class.
* Uses the AFNetworking library to manage image downloads making it easy to add additional control.
* Fixes an issue that `FBProfilePictureView` has when used in a tableview. See [FBProfilePictureView in UITableView](#fbprofilepictureview-in-uitableview) below.

### FBProfilePictureView in UITableView

![fbprofilepictureview_scrolling_small](https://cloud.githubusercontent.com/assets/1255071/5689837/451b1d9a-983c-11e4-90d7-88ed3e4e534e.gif)

This is caused by scheduling the connection handler block to run in the default run loop mode. Therefore, the connection handler block, which sets the image, is not run until scrolling is completed. The fix, which AFNetworking does by default, is to set the runloop mode to NSRunLoopCommonModes when scheduling the connection handler. You can see the difference it makes with [SMFBProfileImageView in UITableView](smfbprofileimageview-in-uitableview) below.

### SMFBProfileImageView in UITableView

![smfbprofileimageview_scrolling_small](https://cloud.githubusercontent.com/assets/1255071/5689838/451ebd60-983c-11e4-9805-6ba82875b0e5.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SMFBProfileImageView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "SMFBProfileImageView"

## Author

Sam Miller, sm11963@gmail.com

## License

SMFBProfileImageView is available under the MIT license. See the LICENSE file for more info.

