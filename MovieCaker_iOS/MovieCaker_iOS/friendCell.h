//
//  friendCell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/30/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface friendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *statusTxt;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet UIView *statusBg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bgWidth;

@end
