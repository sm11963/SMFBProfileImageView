//
//  SMTableViewCell.m
//  SMFBProfileImageView
//
//  Created by Sam Miller on 1/9/15.
//  Copyright (c) 2015 Sam Miller. All rights reserved.
//

#import "SMFBTableViewCell.h"

@implementation SMFBTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _profileImageView = [[FBProfilePictureView alloc] initWithProfileID:nil pictureCropping:FBProfilePictureCroppingSquare];
    _profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_profileImageView];
    
    // Make the image padding 5 pixels in the cell and the image square
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.profileImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    // Center the image in the cell
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  /* Need to ensure that the wrong ID is not used when the cell is reused. Otherwise, the wrong image may be shown
   briefly */
  self.profileImageView.profileID = nil;
}

@end
