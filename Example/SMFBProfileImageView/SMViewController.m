//
//  SMViewController.m
//  SMFBProfileImageView
//
//  Created by Sam Miller on 01/08/2015.
//  Copyright (c) 2014 Sam Miller. All rights reserved.
//

#import "SMViewController.h"
#import "SMListController.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.title = @"Single Image Demo";
  UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(goToList)];
  self.navigationItem.rightBarButtonItem = listButton;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor orangeColor];
  
  /* NOTE: Setup the SMFBProfileImageView just as you would a FBProfilePictureView */
  self.profileImageView = [[SMFBProfileImageView alloc] initWithProfileID:nil
                                                          pictureCropping:FBProfilePictureCroppingSquare];
  self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.profileImageView.backgroundColor = [UIColor blueColor];
#ifdef kAccessToken
  self.profileImageView.accessToken = kAccessToken;
#endif
  [self.view addSubview:self.profileImageView];
  
  self.textField = [UITextField new];
  self.textField.translatesAutoresizingMaskIntoConstraints = NO;
  self.textField.backgroundColor = [UIColor whiteColor];
  self.textField.placeholder = @"A Facebook ID";
  self.textField.returnKeyType = UIReturnKeyDone;
  self.textField.delegate = self;
  [self.view addSubview:self.textField];
  
  self.button = [UIButton buttonWithType:UIButtonTypeSystem];
  self.button.translatesAutoresizingMaskIntoConstraints = NO;
  [self.button setTitle:@"Set ID" forState:UIControlStateNormal];
  [self.button addTarget:self action:@selector(loadID) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.button];
  
  NSDictionary *views = @{
                          @"profileView":self.profileImageView,
                          @"button": self.button,
                          @"textField": self.textField,
                          };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField]-15-[button]-50-[profileView(250)]" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[textField]-20-|" options:0 metrics:nil views:views]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
  
  // Centering
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:25]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

#pragma mark - Actions

- (void)loadID {
  /* NOTE: just set the profile ID to load the profile picture for a user */
  self.profileImageView.profileID = ([self.textField.text isEqualToString:@""]) ? nil : self.textField.text;
}

- (void)goToList {
  [self.navigationController pushViewController:[SMListController new] animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

@end
