//
//  TalkCell.h
//  MovieCaker
//
//  Created by iKevin on 2014/4/11.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkObj.h"

@protocol TalkCellDelegate <NSObject>
@optional
    - (void)openReplyPanel;
    - (void)shareButtonPressed:(UIImage *)image;
@end

@interface TalkCell : UITableViewCell
@property (strong,nonatomic) TalkObj *talkObj;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) id<TalkCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *btnsView;
@property (strong, nonatomic) IBOutlet UIImageView *partyBanner;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *socialLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (assign, nonatomic) BOOL isCreator;
- (IBAction)replyButtonPressed:(id)sender;

- (IBAction)shareButtonPressed:(id)sender;

- (IBAction)likeButtonPressed:(id)sender;

@end
