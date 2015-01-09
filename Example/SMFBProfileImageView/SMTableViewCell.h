//
//  SMTableViewCell.h
//  SMFBProfileImageView
//
//  Created by Sam Miller on 1/9/15.
//  Copyright (c) 2015 Sam Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMFBProfileImageView.h>

#define kSMTableViewCellIdentifier @"SMCell"
#define kSMTableViewCellHeight 75

@interface SMTableViewCell : UITableViewCell

@property (nonatomic, strong) SMFBProfileImageView *profileImageView;

@end
