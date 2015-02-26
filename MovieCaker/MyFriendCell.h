//
//  MyFriendCell.h
//  MovieCaker
//
//  Created by iKevin on 2014/1/7.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) NSNumber *uesrID;
@property (strong, nonatomic) IBOutlet UILabel *locationName;
@property (strong, nonatomic) IBOutlet UIImageView *genderIcon;
@property (strong, nonatomic) IBOutlet UILabel *intro;

@end
