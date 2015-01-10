/*
 * SMFBProfileImageView.m
 *
 * Copyright 2012
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *  Created by Sam Miller on 1/8/15.
 *
 *  Originally from Facebook-iOS-SDK (https://github.com/facebook/facebook-ios-sdk)
 */

#import "SMFBProfileImageView.h"
#import "FBProfilePictureViewBlankProfilePortraitPNG.h"
#import "FBProfilePictureViewBlankProfileSquarePNG.h"
#import "AFNetworking.h"
#import "FacebookSDK.h"

@interface SMFBProfileImageView ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *httpManager;

@property (copy, nonatomic) NSDictionary *currentImageQueryParams;

@property (strong, nonatomic) UIImageView *imageView;

- (void)initialize;
- (void)refreshImage:(BOOL)forceRefresh;
- (void)ensureImageViewContentMode;

@end

@implementation SMFBProfileImageView

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }

    return self;
}

- (instancetype)initWithProfileID:(NSString *)profileID
                  pictureCropping:(FBProfilePictureCropping)pictureCropping {
    self = [self init];
    if (self) {
        self.pictureCropping = pictureCropping;
        self.profileID = profileID;
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark -

- (NSDictionary *)_generateQueryParams {
    static CGFloat screenScaleFactor = 0.0;
    if (screenScaleFactor == 0.0) {
        screenScaleFactor = [[UIScreen mainScreen] scale];
    }

    // Retina display doesn't increase the bounds that iOS returns.  The larger size to fetch needs
    // to be calculated using the scale factor accessed above.
    int width = (int)(self.bounds.size.width * screenScaleFactor);

    if (self.pictureCropping == FBProfilePictureCroppingSquare) {
        return @{
                 @"width": @(width),
                 @"height": @(width),
                 };
    }

    // For non-square images, we choose between three variants knowing that the small profile picture is
    // 50 pixels wide, normal is 100, and large is about 200.
    if (width <= 50) {
        return @{ @"type": @"small" };
    } else if (width <= 100) {
        return @{ @"type": @"normal" };
    } else {
        return @{ @"type": @"large" };
    }
}

- (UIImage *)_placeholderImage {
  return (self.pictureCropping == FBProfilePictureCroppingSquare ?
          [FBProfilePictureViewBlankProfileSquarePNG image] :
          [FBProfilePictureViewBlankProfilePortraitPNG image]);
}

- (void)initialize {
    // the base class can cause virtual recursion, so
    // to handle this we make initialize idempotent
    if (self.imageView) {
        return;
    }
  
    self.httpManager = [AFHTTPRequestOperationManager manager];
    self.httpManager.responseSerializer = [AFImageResponseSerializer serializer];
  
    self.graphVersion = @"2.2";

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView = imageView;

    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;

    [self addSubview:self.imageView];
}

- (void)refreshImage:(BOOL)forceRefresh  {
    /* If the size of the image is 0, dont bother sending a url request */
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
      self.imageView.image = [self _placeholderImage];
      return;
    }
     
    NSDictionary *imageQueryParams = [self _generateQueryParams];

    // If not forcing refresh, check to see if the previous size we used would be the same
    // as what we'd request now, as this method could be called often on control bounds animation,
    // and we only want to fetch when needed.
    if (!forceRefresh && [self.currentImageQueryParams isEqualToDictionary:imageQueryParams]) {
        // But we still may need to adjust the contentMode.
        [self ensureImageViewContentMode];
        return;
    }

    // store the params without the accessToken
    self.currentImageQueryParams = imageQueryParams;

    if (self.profileID) {
      
      /* Cancel any pending requests */
      [self.httpManager.operationQueue cancelAllOperations];
      
      NSString *token;
      
      if (self.accessToken != nil) {
        token = self.accessToken;
      }
      else {
        /* We default to using the currenly set FBSession access token if it exists */
        @try {
          token = [FBSession activeSession].accessTokenData.accessToken;
        }
        @catch (NSException *exception) {
          token = nil;
        }
      }
      
      /* If we have a token add it to the query parameters but make sure we dont add to the instance property */
      if (token != nil) {
        NSMutableDictionary *mQueryParams = [NSMutableDictionary dictionaryWithDictionary:imageQueryParams];
        mQueryParams[@"access_token"] = token;
        imageQueryParams = mQueryParams;
      }
      
      // Create the request url
      NSString *baseUrlString = [NSString stringWithFormat:@"https://graph.facebook.com/v%@/%@/picture", self.graphVersion, self.profileID];
     
      [self.httpManager GET:baseUrlString parameters:imageQueryParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /* The response is a UIImage since we selected the AFImageResponseSerializer as the response serializer */
        self.imageView.image = responseObject;
        [self ensureImageViewContentMode];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      }];
    } else {
        self.imageView.image = [self _placeholderImage];
        [self ensureImageViewContentMode];
    }
  
}

- (void)ensureImageViewContentMode {
    // Set the image's contentMode such that if the image is larger than the control, we scale it down, preserving aspect
    // ratio.  Otherwise, we center it.  This ensures that we never scale up, and pixellate, the image.
    CGSize viewSize = self.bounds.size;
    CGSize imageSize = self.imageView.image.size;
    UIViewContentMode contentMode;

    // If both of the view dimensions are larger than the image, we'll center the image to prevent scaling up.
    // Note that unlike in choosing the image size, we *don't* use any Retina-display scaling factor to choose centering
    // vs. filling.  If we were to do so, we'd get profile pics shrinking to fill the the view on non-Retina, but getting
    // centered and clipped on Retina.
    if (viewSize.width > imageSize.width && viewSize.height > imageSize.height) {
        contentMode = UIViewContentModeCenter;
    } else {
        contentMode = UIViewContentModeScaleAspectFit;
    }

    self.imageView.contentMode = contentMode;
}

- (void)setProfileID:(NSString *)profileID {
    if (!_profileID || ![_profileID isEqualToString:profileID]) {
        _profileID = [profileID copy];
        [self refreshImage:YES];
    }
}

- (void)setPictureCropping:(FBProfilePictureCropping)pictureCropping  {
    if (_pictureCropping != pictureCropping) {
        _pictureCropping = pictureCropping;
        [self refreshImage:YES];
    }
}

// Lets us catch resizes of the control, or any outer layout, allowing us to potentially
// choose a different image.
- (void)layoutSubviews {
    [self refreshImage:NO];
    [super layoutSubviews];
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

@end
