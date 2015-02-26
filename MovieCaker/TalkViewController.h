//
//  TalkViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/4/8.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SchoolPartyObj.h"
#import "SchoolPartyHeaderCell.h"
#import "WriteReplyViewController.h"

@interface TalkViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SchoolPartyHeaderCellDelegate,WriteReplyDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) SchoolPartyObj *party;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
- (IBAction)topButtonPressed:(id)sender;
@end
