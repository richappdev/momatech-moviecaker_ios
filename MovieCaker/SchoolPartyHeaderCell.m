//
//  SchoolPartyHeaderCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "SchoolPartyHeaderCell.h"
#import "MovieCakerManager.h"
#import "WaitingAlert.h"

@implementation SchoolPartyHeaderCell

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

- (IBAction)shareButtonPressed:(id)sender {
    
    UIImage *image=self.banner.image;
    if([self.delegate respondsToSelector:@selector(shareButtonPressed:)]){
        [self.delegate shareButtonPressed:image];
    }
}

- (IBAction)joinButtonPressed:(id)sender {
    
    NSLog(@"joinButtonPressed");
    if (self.isCreator) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedStringFromTable(@"你不能加入或退出自己所創辦的社團！",@"InfoPlist",nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.party.needAuth.boolValue) {
        if (self.party.isJoined.boolValue && !self.party.isPassAudit.boolValue) {
            return;
        }
    }

    
    if (self.party.isJoined.boolValue) {
        [self quitClub];
    }else{
        [self joinClub];
    }
    
}


-(void)joinClub{
    
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"加入社團",@"InfoPlist",nil) withTimeOut:2];
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *lang = [languages objectAtIndex:0];
    
    if (self.party.needAuth.boolValue) {
        if (self.btnView3.hidden) {
            [self.joinButton setImage:[UIImage imageNamed:@"Audit.png"] forState:UIControlStateNormal];
        }else{
            [self.join2Button setImage:[UIImage imageNamed:@"Audit_small.png"] forState:UIControlStateNormal];
        }
        
    }else{
        if (self.btnView3.hidden) {
            if ([lang isEqualToString:@"zh-Hant"]) {
                [self.joinButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
            }else{
                [self.joinButton setImage:[UIImage imageNamed:@"退出社團大.png"] forState:UIControlStateNormal];
            }
        }else{
            
            if ([lang isEqualToString:@"zh-Hant"]) {
                [self.join2Button setImage:[UIImage imageNamed:@"Exit-Societies.png"] forState:UIControlStateNormal];
            }else{
                [self.join2Button setImage:[UIImage imageNamed:@"退出社團.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    [self.party setValue:[NSNumber numberWithBool:YES] forKey:@"isJoined"];
    
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    [manager joinParty:self.party.partyID callback:^(NSNumber *result, NSString *errorMsg, NSError *error) {
        
        
    }];
    
}
-(void)quitClub{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedStringFromTable(@"退出此社團！",@"InfoPlist",nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil)
                                          otherButtonTitles:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil), nil];
    [alert show];
    
    

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView firstOtherButtonIndex] == buttonIndex){
        
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"退出社團",@"InfoPlist",nil) withTimeOut:2];
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *lang = [languages objectAtIndex:0];
        
        if (self.btnView3.hidden){
            if ([lang isEqualToString:@"zh-Hant"]) {
                [self.joinButton setImage:[UIImage imageNamed:@"Societies.png"] forState:UIControlStateNormal];
            }else{
                [self.joinButton setImage:[UIImage imageNamed:@"加入社團大.png"] forState:UIControlStateNormal];
            }
        }else{
            

            if ([lang isEqualToString:@"zh-Hant"]) {
                [self.join2Button setImage:[UIImage imageNamed:@"Societies_small.png"] forState:UIControlStateNormal];
            }else{
                [self.join2Button setImage:[UIImage imageNamed:@"加入社團.png"] forState:UIControlStateNormal];
            }
        }
        [self.party setValue:[NSNumber numberWithBool:NO] forKey:@"isJoined"];
        
        MovieCakerManager *manager = [MovieCakerManager sharedInstance];
        [manager quitParty:self.party.partyID callback:^(NSNumber *result, NSString *errorMsg, NSError *error) {
            
        }];
    }
    
}


- (IBAction)addTalkButtonPressed:(id)sender {
    
    
    if([self.delegate respondsToSelector:@selector(openReplyPanel)]){
        [self.delegate openReplyPanel];
    }
}

@end
