//
//  TalkCell.m
//  MovieCaker
//
//  Created by iKevin on 2014/4/11.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "TalkCell.h"
#import "MovieCakerManager.h"

@implementation TalkCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replyButtonPressed:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(openReplyPanel)]){
        [self.delegate openReplyPanel];
    }
}
- (IBAction)shareButtonPressed:(id)sender {
    
     UIImage *image=self.partyBanner.image;
    if([self.delegate respondsToSelector:@selector(shareButtonPressed:)]){
        [self.delegate shareButtonPressed:image];
    }
}
- (IBAction)likeButtonPressed:(id)sender {
    
    if (self.isCreator) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你不能對自己的話題點喜歡！"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    
    if ([manager isLogined]) {
        [manager likeClubTopic:self.talkObj.talkId callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
            self.likeButton.selected = !self.likeButton.selected;
            self.talkObj.isLike =[NSNumber numberWithBool:self.likeButton.selected];
        }];
        
    }else{
        [self showAlertView];
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
@end
