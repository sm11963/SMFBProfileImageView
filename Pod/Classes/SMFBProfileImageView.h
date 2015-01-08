//
//  SMFBProfilePhotoView.h
//
//  Created by Sam Miller on 1/8/15.
//
//  Originally from Facebook-iOS-SDK (https://github.com/facebook/facebook-ios-sdk)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FacebookSDK.h>

/*!
 @class
 @abstract
 An instance of `SMFBProfileImageView` is used to display a profile picture.

 The default behavior of this control is to center the profile picture
 in the view and shrinks it, if necessary, to the view's bounds, preserving the aspect ratio. The smallest
 possible image is downloaded to ensure that scaling up never happens.  Resizing the view may result in
 a different size of the image being loaded.  Canonical image sizes are documented in the "Pictures" section
 of https://developers.facebook.com/docs/reference/api.
 */
@interface SMFBProfileImageView : UIView

/*!
 @abstract
 The Facebook ID of the user, place or object for which a picture should be fetched and displayed.
 */
@property (copy, nonatomic) NSString *profileID;

/*!
 @abstract
 The cropping to use for the profile picture.
 */
@property (nonatomic) FBProfilePictureCropping pictureCropping;

/*!
 @abstract
 Initializes and returns a profile view object.
 */
- (instancetype)init;

/*!
 @abstract
 Initializes and returns a profile view object for the given Facebook ID and cropping.

 @param profileID       The Facebook ID of the user, place or object for which a picture should be fetched and displayed.
 @param pictureCropping The cropping to use for the profile picture.
 */
- (instancetype)initWithProfileID:(NSString *)profileID
                  pictureCropping:(FBProfilePictureCropping)pictureCropping;

@end
