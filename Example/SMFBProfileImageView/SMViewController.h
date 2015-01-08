//
//  SMViewController.h
//  SMFBProfileImageView
//
//  Created by Sam Miller on 01/08/2015.
//  Copyright (c) 2014 Sam Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMFBProfileImageView/SMFBProfileImageView.h>

@interface SMViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) SMFBProfileImageView *profileImageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;

@end
