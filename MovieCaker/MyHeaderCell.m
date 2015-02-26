//
//  MyHeaderCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/8.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MyHeaderCell.h"
#import "MovieCakerManager.h"
#import "WaitingAlert.h"
#import "APIManager.h"

@implementation MyHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addFriendButtonPressed:(id)sender {
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"邀請朋友已送出...",@"InfoPlist",nil) withTimeOut:30];
    [manager invitFiend:self.friend.userId.stringValue callback:^(NSDictionary *result, NSString *errorMsg, NSError *error)
     {
         NSLog(@"result:%@",result);

        self.addFriendButton.hidden=YES;
        [WaitingAlert dismiss];
        
        if([self.delegate respondsToSelector:@selector(refreshData)]){
            [self.delegate refreshData];
        }
        
    }];
}

- (IBAction)agreeButtonPressed:(id)sender {
    
    if (self.friend.isInviting.boolValue) {
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"取消交友邀請...",@"InfoPlist",nil) withTimeOut:2];
        
        [[APIManager sharedInstance] invitingAction:self.friend.userId type:@"Cancel" success:^(NSData *data) {
            
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                [self.delegate refreshData];
            }
            
        } failure:^(NSString *errorMsg, NSError *error) {
            //
        }];
    }else{
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"確認交友邀請...",@"InfoPlist",nil) withTimeOut:2];
        [[APIManager sharedInstance] invitingAction:self.friend.userId type:@"Accept" success:^(NSData *data) {
        
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                [self.delegate refreshData];
            }
        
        } failure:^(NSString *errorMsg, NSError *error) {
        //
        }];
    }
    
}
- (IBAction)rejectButtonPressed:(id)sender {
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"刪除交友邀請...",@"InfoPlist",nil) withTimeOut:2];
    
    [[APIManager sharedInstance] invitingAction:self.friend.userId type:@"Reject" success:^(NSData *data) {
        
        if([self.delegate respondsToSelector:@selector(refreshData)]){
            [self.delegate refreshData];
        }
    } failure:^(NSString *errorMsg, NSError *error) {
        //
    }];
    
}
@end
