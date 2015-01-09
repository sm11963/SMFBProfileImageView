//
//  SMTableViewCell.h
//  SMFBProfileImageView
//
//  Created by Sam Miller on 1/9/15.
//  Copyright (c) 2015 Sam Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>

#define kSMFBTableViewCellIdentifier @"SMFBCell"
#define kSMFBTableViewCellHeight 75

@interface SMFBTableViewCell : UITableViewCell

@property (nonatomic, strong) FBProfilePictureView *profileImageView;

@end
