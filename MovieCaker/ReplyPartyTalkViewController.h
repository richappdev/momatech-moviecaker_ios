//
//  ReplyPartyTalkViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/2.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "BaseViewController.h"
#import "WriteReplyViewController.h"
#import "TalkObj.h"
#import "TalkCell.h"

@interface ReplyPartyTalkViewController : BaseViewController<TalkCellDelegate,WriteReplyDelegate>

@property (strong,nonatomic) TalkObj *talkObj;
@property (strong,nonatomic) NSNumber *talkId;
@property (strong,nonatomic) NSNumber *partyId;
@property (strong,nonatomic) NSString *partyName;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UILabel *moreLabel;
- (IBAction)topButtonPressed:(id)sender;
@end
