//
//  friendCell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/30/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendTableViewController.h"
@interface friendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *statusTxt;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet UIView *statusBg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgWidth;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property friendTableViewController *parent;
@property NSIndexPath *path;
@end
