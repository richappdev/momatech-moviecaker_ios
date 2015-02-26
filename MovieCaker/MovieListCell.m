//
//  MovieListCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "MovieListCell.h"
#import "MovieCakerManager.h"
#import "WaitingAlert.h"

#define SEEN_ALERT_VIEW  30
#define WANTVIEW_ALERT_VIEW  31

@implementation MovieListCell

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

- (IBAction)seenButtonPressed:(id)sender {
    
    NSComparisonResult result=[[NSDate date] compare:[self stringToDate:self.video.releaseDate]];
    if (result==NSOrderedAscending) {
        [self showNoReleaseAlert];
        return;
    }
    
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    if ([manager isLogined]) {
        
        if (self.seenButton.selected) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedStringFromTable(@"確定刪除看過?",@"InfoPlist",nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil)
                                                  otherButtonTitles:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil), nil];
            alert.tag = SEEN_ALERT_VIEW;
            alert.delegate=self;
            [alert show];
            
        }else{
            [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"看過這部電影...",@"InfoPlist",nil) withTimeOut:2];
            [manager like:self.video.videoID withCol:@"IsViewed" callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
 
                self.video.viewNum=@(self.video.viewNum.intValue+1);
                self.seenButton.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
                
                self.seenButton.selected=YES;
                self.video.isViewed=[NSNumber numberWithBool:YES];
                [self updateVideoInfo];
                
                if (self.video.isWantView.boolValue) {
                    [self watchButtonPressed:nil];
                }
             }];
            
            
        }
        
    }else{
        [self showAlertView];
    }
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == SEEN_ALERT_VIEW)
    {
        if([alertView firstOtherButtonIndex] == buttonIndex)
        {
            MovieCakerManager *manager = [MovieCakerManager sharedInstance];
            [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"取消看過這部電影...",@"InfoPlist",nil) withTimeOut:2];
            [manager like:self.video.videoID withCol:@"IsViewed" callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
                
                    self.video.viewNum=@(self.video.viewNum.intValue-1);
                    self.seenButton.backgroundColor=[UIColor grayColor];
                    self.seenButton.selected=NO;
                    self.video.isViewed=[NSNumber numberWithBool:NO];
                    [self updateVideoInfo];

            }];
        }
    }
}
- (IBAction)likeButtonPressed:(id)sender {
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    
    if ([manager isLogined]) {
        if (self.likeButton.selected) {
            [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"取消喜歡這部電影...",@"InfoPlist",nil) withTimeOut:3];
        }else{
             [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"喜歡這部電影...",@"InfoPlist",nil) withTimeOut:3];
        }
        
        
        [manager like:self.video.videoID withCol:@"IsLiked" callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
            if (self.likeButton.selected) {
                self.video.likeNum=@(self.video.likeNum.intValue-1);
                self.likeButton.backgroundColor=[UIColor grayColor];
            }else{
                self.video.likeNum=@(self.video.likeNum.intValue+1);
                
                self.likeButton.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            }
            self.likeButton.selected=!self.likeButton.selected;
            self.video.isLiked=[NSNumber numberWithBool:self.likeButton.selected];
            [self updateVideoInfo];
        }];
    }else{
       [self showAlertView];
    }
}
- (IBAction)watchButtonPressed:(id)sender {
    
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    if ([manager isLogined] ) {
        
        if (self.watchButton.selected) {
            [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"取消想看這部電影...",@"InfoPlist",nil) withTimeOut:2];
             [manager like:self.video.videoID withCol:@"IsWantView" callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
                 self.video.wantViewNum=@(self.video.wantViewNum.intValue-1);
                 self.watchButton.backgroundColor=[UIColor grayColor];
                 self.watchButton.selected=NO;
                 self.video.isWantView=[NSNumber numberWithBool:NO];
                 [self updateVideoInfo];
             }];
        }else{
            
            if (self.video.isViewed.boolValue) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedStringFromTable(@"您已看過，可以取消看過選擇想看。",@"InfoPlist",nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                                      otherButtonTitles:nil];
                [alert show];
                
            }else{
                [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"想看這部電影...",@"InfoPlist",nil) withTimeOut:2];
               [manager like:self.video.videoID withCol:@"IsWantView" callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
                   
                   self.video.wantViewNum=@(self.video.wantViewNum.intValue+1);
                   self.watchButton.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:195.0/255.0 blue:77.0/255.0 alpha:1.0];
                   self.watchButton.selected=YES;
                   self.video.isWantView=[NSNumber numberWithBool:YES];
                   [self updateVideoInfo];
               }];
            }
            
        }
        
    }else{
        [self showAlertView];
    }
}

- (IBAction)addTopicButtonPressed:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(joinTopic:)]){
        [self.delegate joinTopic:self.video];
    }
}

- (IBAction)reviewButtonPressed:(id)sender {
    NSComparisonResult result=[[NSDate date] compare:[self stringToDate:self.video.releaseDate]];

    if (result==NSOrderedAscending) {
        [self showNoReleaseAlert];
        return;
    }
}

- (IBAction)gradeButtonPressed:(id)sender {
    NSComparisonResult result=[[NSDate date] compare:[self stringToDate:self.video.releaseDate]];

    if (result==NSOrderedAscending) {
        [self showNoReleaseAlert];
        return;
    }
}

-(void)showAlertView{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedStringFromTable(@"請先登入！",@"InfoPlist",nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                          otherButtonTitles:nil];
    [alert show];
    
}
-(void)showNoReleaseAlert{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedStringFromTable(@"這部電影還沒上映！",@"InfoPlist",nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                          otherButtonTitles:nil];
    [alert show];
    
}


-(void)updateVideoInfo{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *lang = [languages objectAtIndex:0];
    if ([lang isEqualToString:@"zh-Hant"]) {
        self.socialLabel.text=[NSString stringWithFormat:@"上映時間：%@\n看過數：%d\n喜歡數：%d\n想看數：%d\n影評數：%d",self.video.releaseDate,self.video.viewNum.intValue,self.video.likeNum.intValue,self.video.wantViewNum.intValue,self.video.reviewNum.intValue];
    }else{
        self.socialLabel.text=[NSString stringWithFormat:@"上映时间：%@\n看过数：%d\n喜欢数：%d\n想看数：%d\n影评数：%d",self.video.releaseDate,self.video.viewNum.intValue,self.video.likeNum.intValue,self.video.wantViewNum.intValue,self.video.reviewNum.intValue];
    }

}


-(NSDate *)stringToDate:(NSString *)string{
    
    NSArray *dateAry=[string componentsSeparatedByString:@"-"];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[dateAry[2] intValue]];
    [components setMonth:[dateAry[1] intValue]];
    [components setYear:[dateAry[0] intValue]];
    
    components.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];

    
    NSCalendar *cal=  [NSCalendar currentCalendar];
    
    return [cal dateFromComponents:components];
}

@end
