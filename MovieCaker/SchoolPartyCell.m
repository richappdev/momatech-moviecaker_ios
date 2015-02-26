//
//  SchoolPartyCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "SchoolPartyCell.h"
#import "MovieCakerManager.h"
#import "WaitingAlert.h"

@implementation SchoolPartyCell

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

- (IBAction)joinButtonPressed:(id)sender {
    
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
    
    if (self.party.needAuth.boolValue) {
        
        [self.joinButton setImage:[UIImage imageNamed:@"Audit_small.png"] forState:UIControlStateNormal];
    }else{
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *lang = [languages objectAtIndex:0];
        if ([lang isEqualToString:@"zh-Hant"]) {
            [self.joinButton setImage:[UIImage imageNamed:@"Exit-Societies.png"] forState:UIControlStateNormal];
        }else{
            [self.joinButton setImage:[UIImage imageNamed:@"退出社團.png"] forState:UIControlStateNormal];
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
                                          otherButtonTitles:NSLocalizedString(@"確定", nil), nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView firstOtherButtonIndex] == buttonIndex){
        
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"退出社團",@"InfoPlist",nil) withTimeOut:2];
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *lang = [languages objectAtIndex:0];
        
        if ([lang isEqualToString:@"zh-Hant"]) {
            [self.joinButton setImage:[UIImage imageNamed:@"Societies_small.png"] forState:UIControlStateNormal];
        }else{
            [self.joinButton setImage:[UIImage imageNamed:@"加入社團.png"] forState:UIControlStateNormal];
        }
        
        [self.party setValue:[NSNumber numberWithBool:NO] forKey:@"isJoined"];
        
        MovieCakerManager *manager = [MovieCakerManager sharedInstance];
        [manager quitParty:self.party.partyID callback:^(NSNumber *result, NSString *errorMsg, NSError *error) {
            if([self.delegate respondsToSelector:@selector(reloadData)]){
                [self.delegate reloadData];
            }
        }];
    }
    
}

- (IBAction)shareButtonPressed:(id)sender {

    UIImage *image=self.partyBanner.image;
    
    if([self.delegate respondsToSelector:@selector(shareButtonPressed:WithImage:)]){
        [self.delegate shareButtonPressed:self.indexPath WithImage:image];
    }
    
}

@end
