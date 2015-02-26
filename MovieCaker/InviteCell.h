//
//  InviteCell.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/4.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteCellDelegate <NSObject>
@optional
- (void)refreshData;
@end

@interface InviteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong,nonatomic) NSNumber *userId;
@property (weak, nonatomic) id<InviteCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
- (IBAction)agreeButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *rejectButton;
- (IBAction)rejectButtonPressed:(id)sender;
@end
