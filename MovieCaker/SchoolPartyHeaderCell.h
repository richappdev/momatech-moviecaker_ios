//
//  SchoolPartyHeaderCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolPartyObj.h"

@protocol SchoolPartyHeaderCellDelegate <NSObject>
@optional
- (void)openReplyPanel;
- (void)shareButtonPressed:(UIImage *)image;
@end

@interface SchoolPartyHeaderCell : UITableViewCell<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *creator;
@property (strong, nonatomic) IBOutlet UILabel *memberCount;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UIImageView *banner;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;

@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UIView *introView;
@property (assign, nonatomic) BOOL isCreator;
@property (strong, nonatomic) IBOutlet UIView *btnView2;
@property (strong, nonatomic) IBOutlet UIView *btnView3;
@property (strong, nonatomic) IBOutlet UIButton *join2Button;
@property (strong, nonatomic) SchoolPartyObj *party;

@property (weak, nonatomic) id<SchoolPartyHeaderCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *addTalkButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareButtonPressed:(id)sender;




- (IBAction)joinButtonPressed:(id)sender;
- (IBAction)addTalkButtonPressed:(id)sender;

@end
