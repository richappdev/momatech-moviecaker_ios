//
//  WriteReplyViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/5/2.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "BaseViewController.h"
#import "TalkObj.h"
#import "SchoolPartyObj.h"

@protocol WriteReplyDelegate <NSObject>
@optional
    - (void)refreshData;
@end

@interface WriteReplyViewController : BaseViewController<UITextViewDelegate>
@property (strong,nonatomic) TalkObj *talkObj;
@property (strong, nonatomic) SchoolPartyObj *party;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;

@property (strong, nonatomic) IBOutlet UITextField *talkHead;
@property (weak, nonatomic) id<WriteReplyDelegate> delegate;
- (IBAction)sendButtonPressed:(id)sender;

@end
