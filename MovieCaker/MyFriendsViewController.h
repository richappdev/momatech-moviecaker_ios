//
//  MyFriendsViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/1/7.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MyHeaderCell.h"
#import "FriendObj.h"

@interface MyFriendsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@end
