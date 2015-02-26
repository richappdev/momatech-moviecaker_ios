//
//  TopicReplyCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicReplyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;

@end
