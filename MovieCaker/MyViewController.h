//
//  MyViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/8.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MyHeaderCell.h"
#import "FriendObj.h"

@interface MyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MyHeaderCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) NSNumber *userId;
@end
