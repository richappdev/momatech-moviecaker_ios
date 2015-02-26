//
//  MyVideoChildViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/3/9.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"
#import "MyContentView.h"
#import "MyHeaderCell.h"

@interface MyVideoChildViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MyContentViewDelegate,MyHeaderCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) NSNumber *myType;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@end
