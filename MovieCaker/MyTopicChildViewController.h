//
//  MyTopicChildViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/24.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendObj.h"
#import "BaseViewController.h"
#import "MyHeaderCell.h"


@interface MyTopicChildViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MyHeaderCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) NSString *topicChannel;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

@end
