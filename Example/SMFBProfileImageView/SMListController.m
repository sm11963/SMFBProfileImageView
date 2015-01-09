//
//  SMListController.m
//  SMFBProfileImageView
//
//  Created by Sam Miller on 1/9/15.
//  Copyright (c) 2015 Sam Miller. All rights reserved.
//

#import "SMListController.h"
#import "SMTableViewCell.h"
#import "SMFBTableViewCell.h"
#import "SMViewController.h"

@interface SMListController ()

@end

@implementation SMListController

- (instancetype)init
{
  self = [super init];
  if (self) {
    _profileIds = [self _testProfileIds];
    _usesFBProfilePictureView = NO;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.title = @"List Demo";
  [self.tableView reloadData];
  
  self.usesFBProfilePictureView = YES;
  [self switchCellVersions];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.tableView = [UITableView new];
  self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  
  [self.tableView registerClass:[SMTableViewCell class] forCellReuseIdentifier:kSMTableViewCellIdentifier];
  [self.tableView registerClass:[SMFBTableViewCell class] forCellReuseIdentifier:kSMFBTableViewCellIdentifier];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[tableView]-|" options:0 metrics:nil views:@{@"tableView":self.tableView}]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[tableView]-|" options:0 metrics:nil views:@{@"tableView":self.tableView}]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
}

/**
 Array of facebook profile IDs for testing. Currently just has a list of company profile IDs
 */
- (NSArray *)_testProfileIds {
  return @[
           @"439688879476966",
           @"434174436675167",
           @"10152203108461729",
           @"10151163421672838",
           @"462359820525647",
           @"642069992499956",
           @"10151840146086756",
           @"10152384967974060",
           @"10152214521608870",
           @"10151667042841344",
           @"10152575173388124",
           @"10152839234679654",
           ];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *thisCell;
  
  if (self.usesFBProfilePictureView) {
    SMFBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMFBTableViewCellIdentifier forIndexPath:indexPath];
    cell.profileImageView.profileID = self.profileIds[indexPath.row];
    thisCell = cell;
  }
  else {
    SMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSMTableViewCellIdentifier forIndexPath:indexPath];
    cell.profileImageView.profileID = self.profileIds[indexPath.row];
    #ifdef kAccessToken
    cell.profileImageView.accessToken = kAccessToken;
    #endif
    thisCell = cell;
  }
  
  return thisCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.profileIds.count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kSMTableViewCellHeight;
}

#pragma mark - Accessors

- (void)setUsesFBProfilePictureView:(BOOL)usesFBProfilePictureView {
  if (usesFBProfilePictureView != _usesFBProfilePictureView) {
    _usesFBProfilePictureView = usesFBProfilePictureView;
    [self.tableView reloadData];
  }
}

#pragma mark - Actions

- (void)switchCellVersions {
  self.usesFBProfilePictureView = !self.usesFBProfilePictureView;
  
  UIBarButtonItem *button;
  if (self.usesFBProfilePictureView) {
    button = [[UIBarButtonItem alloc] initWithTitle:@"SM Class" style:UIBarButtonItemStylePlain target:self action:@selector(switchCellVersions)];
  }
  else {
    button = [[UIBarButtonItem alloc] initWithTitle:@"FB Class" style:UIBarButtonItemStylePlain target:self action:@selector(switchCellVersions)];
  }
  self.navigationItem.rightBarButtonItem = button;
}

@end
