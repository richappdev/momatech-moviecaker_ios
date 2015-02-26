//
//  InviteCell.m
//  MovieCaker
//
//  Created by iKevin on 2014/5/4.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "InviteCell.h"
#import "APIManager.h"
#import "WaitingAlert.h"

@implementation InviteCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)agreeButtonPressed:(id)sender {
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"確認交友邀請...",@"InfoPlist",nil) withTimeOut:2];
    
     [[APIManager sharedInstance] invitingAction:self.userId type:@"Accept" success:^(NSData *data) {
         
         if([self.delegate respondsToSelector:@selector(refreshData)]){
             [self.delegate refreshData];
         }
         
     } failure:^(NSString *errorMsg, NSError *error) {
         //
     }];
    
}
- (IBAction)rejectButtonPressed:(id)sender {
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"刪除交友邀請...",@"InfoPlist",nil) withTimeOut:2];
    
    [[APIManager sharedInstance] invitingAction:self.userId type:@"Reject" success:^(NSData *data) {
        
        if([self.delegate respondsToSelector:@selector(refreshData)]){
            [self.delegate refreshData];
        }
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}

@end
