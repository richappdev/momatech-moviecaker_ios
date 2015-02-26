//
//  MyPartyChildViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/24.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FriendObj.h"
#import "MyHeaderCell.h"
#import "SchoolPartyCell.h"
#import "WXApi.h"

@interface MyPartyChildViewController : BaseViewController<MyHeaderCellDelegate,SchoolPartyCellDelegate,WXApiDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) FriendObj *friend;
@property (strong, nonatomic) NSString *partyChannel;
@property (strong, nonatomic) NSString *channel;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@end
