//
//  SMFBProfileImageView.m
//
//  Created by Sam Miller on 1/8/15.
//
//  Originally from Facebook-iOS-SDK (https://github.com/facebook/facebook-ios-sdk)
//

#import "SMFBProfileImageView.h"
#import "FBProfilePictureViewBlankProfilePortraitPNG.h"
#import "FBProfilePictureViewBlankProfileSquarePNG.h"
#import "AFNetworking.h"
#import "FacebookSDK.h"

@interface SMFBProfileImageView ()

@property (copy, nonatomic) NSDictionary *currentImageQueryParams;

@property (retain, nonatomic) UIImageView *imageView;

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
                 @"width":  [NSString stringWithFormat:@"%d", width],
                 @"height": [NSString stringWithFormat:@"%d", width],
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

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView = imageView;

    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;

    [self addSubview:self.imageView];
}

- (void)refreshImage:(BOOL)forceRefresh  {
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
      // Create the request to let the Facebook SDK handle the URL
      /*
      NSString *graphPath = [NSString stringWithFormat:@"%@/picture",self.profileID];
      FBRequest *fbRequest = [[FBRequest alloc] initWithSession:nil graphPath:graphPath parameters:self.currentImageQueryParams HTTPMethod:nil];
      FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
      [requestConnection addRequest:fbRequest completionHandler:nil];
      
      // Get the url
      NSURL *url = requestConnection.urlRequest.URL;
       */
      NSURL *url;
      if ([self.currentImageQueryParams valueForKey:@"type"] != nil) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.2/%@/picture?type=%@", self.profileID, self.currentImageQueryParams[@"type"]]];
      }
      else if ([self.currentImageQueryParams valueForKey:@"width"] != nil && [self.currentImageQueryParams valueForKey:@"height"] != nil) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.2/%@/picture?width=%@&height=%@", self.profileID,self.currentImageQueryParams[@"width"],self.currentImageQueryParams[@"height"]]];
      }
      else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.2/%@/picture", self.profileID]];
      }
     
      /*
      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
      [request setHTTPShouldHandleCookies:NO];
      [request setHTTPShouldUsePipelining:YES];
      
      AFHTTPRequestOperation* requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
      requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
      [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.imageView.image = responseObject;
        [self ensureImageViewContentMode];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
      }];
      */
      
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      manager.responseSerializer = [AFImageResponseSerializer serializer];
      [manager GET:[url absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
