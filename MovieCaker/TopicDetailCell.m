//
//  TopicDetailCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "TopicDetailCell.h"
#import "MovieCakerManager.h"

@implementation TopicDetailCell

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

- (IBAction)likeButtonPressed:(id)sender {
    if (self.isCreator) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"你不能對自己的專題點喜歡！"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
    MovieCakerManager *manager = [MovieCakerManager sharedInstance];
    
    if ([manager isLogined]) {
        [manager likeTopic:self.topic.topicID callback:^(NSNumber *count, NSString *errorMsg, NSError *error) {
            self.likeButton.selected = !self.likeButton.selected;
            self.topic.isLiked =[NSNumber numberWithBool:self.likeButton.selected];
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

- (IBAction)shareButtonPressed:(id)sender {
    
    UIImage *image=self.banner.image;
    if([self.delegate respondsToSelector:@selector(shareButtonPressed:)]){
        [self.delegate shareButtonPressed:image];
    }
}
@end
