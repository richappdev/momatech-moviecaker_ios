//
//  SchoolPartyViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SchoolPartyCell.h"
#import "WXApi.h"

@interface SchoolPartyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SchoolPartyCellDelegate,WXApiDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;

- (IBAction)topButtonPressed:(id)sender;

@end
