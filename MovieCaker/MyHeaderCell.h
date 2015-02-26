//
//  MyHeaderCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/8.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendObj.h"

@protocol MyHeaderCellDelegate <NSObject>
@optional
- (void)refreshData;
@end

@interface MyHeaderCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userBanner;

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property (strong, nonatomic) FriendObj *friend;
@property (weak, nonatomic) id<MyHeaderCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *inviteView;

@property (strong, nonatomic) IBOutlet UILabel *inviteWord;

- (IBAction)addFriendButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
- (IBAction)agreeButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *rejectButton;
- (IBAction)rejectButtonPressed:(id)sender;

@end
