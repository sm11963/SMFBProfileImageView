//
//  SMListController.h
//  SMFBProfileImageView
//
//  Created by Sam Miller on 1/9/15.
//  Copyright (c) 2015 Sam Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMListController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, readonly) NSArray *profileIds;
@property (nonatomic, strong) UITableView *tableView;

/**
 * @brief Determines whether to use FBProfilePictureView or SMFBProfileImageView
 * @note YES to use @c FBProfilePictureView, NO to use @c SMFBProfileImageView.
 */
@property (nonatomic) BOOL usesFBProfilePictureView;

@end
