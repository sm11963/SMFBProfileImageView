//
//  SMViewController.m
//  SMFBProfileImageView
//
//  Created by Sam Miller on 01/08/2015.
//  Copyright (c) 2014 Sam Miller. All rights reserved.
//

#import "SMViewController.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor orangeColor];
  
  self.profileImageView = [[SMFBProfileImageView alloc] initWithProfileID:nil
                                                          pictureCropping:FBProfilePictureCroppingSquare];
  self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
  self.profileImageView.backgroundColor = [UIColor blueColor];
  
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
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[textField]-15-[button]-50-[profileView(200)]" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[profileView(200)]" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[textField]-20-|" options:0 metrics:nil views:views]];
  
  // Centering
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
}

- (void)loadID {
  self.profileImageView.profileID = ([self.textField.text isEqualToString:@""]) ? nil : self.textField.text;
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
