//
//  MainMenuCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKBadgeView.h"

@interface MainMenuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *unitHeader;
@property (strong, nonatomic) IBOutlet UIImageView *unitIcon;
@property (strong, nonatomic) IBOutlet LKBadgeView *badgeView;

@end
