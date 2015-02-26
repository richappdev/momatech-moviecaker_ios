//
//  FriendSearchViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/3/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FriendSearchViewController : BaseViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UIView *touchView;

- (IBAction)tap:(id)sender;

@end
