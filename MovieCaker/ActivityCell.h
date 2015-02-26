//
//  ActivityCell.h
//  MovieCaker
//
//  Created by iKevin on 2014/1/12.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *createdOn;
@property (strong, nonatomic) IBOutlet UILabel *content;

@end
