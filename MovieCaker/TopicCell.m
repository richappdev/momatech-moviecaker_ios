//
//  topicCell.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/16.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "TopicCell.h"
#import "MovieCakerManager.h"

@implementation TopicCell

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
    UIImage *image=self.imageView1.image;
    if([self.delegate respondsToSelector:@selector(shareButtonPressed:WithImage:)]){
        [self.delegate shareButtonPressed:self.indexPath WithImage:image];
    }
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
            if (self.topic.isLiked) {
                self.topic.likeNum=@(self.topic.likeNum.intValue+1);
            }else{
                self.topic.likeNum=@(self.topic.likeNum.intValue-1);
            }
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
