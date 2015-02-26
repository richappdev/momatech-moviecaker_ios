//
//  TopicDetailCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicObj.h"

@protocol TopicDetailCellDelegate <NSObject>
@optional
- (void)shareButtonPressed:(UIImage *)image;
@end

@interface TopicDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *header;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *createdOn;
@property (strong, nonatomic) IBOutlet UIView *cellGrayBgView;
@property (strong, nonatomic) IBOutlet UILabel *socialLabel;
@property (strong, nonatomic) IBOutlet UIImageView *banner;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *viewNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (assign,nonatomic) BOOL isCreator;
@property (strong, nonatomic) TopicObj *topic;

@property (strong, nonatomic) id<TopicDetailCellDelegate> delegate;
- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end
