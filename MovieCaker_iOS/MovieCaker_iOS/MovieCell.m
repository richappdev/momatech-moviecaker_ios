//
//  MovieCell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/1/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieCell.h"
#import "buttonHelper.h"
#import "AustinApi.h"
#import "WXApi.h"
#import "WechatAccess.h"
@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
    self.imageArray = [[NSArray alloc] initWithObjects:self.one,self.two,self.three,self.four,self.five, nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCirclePercentage:(float)percent{
    self.Circle.percentage = percent;
    UIColor *circleColor;
    if(percent<=1&&percent>=.75){
        circleColor = [UIColor colorWithRed:0.39 green:0.73 blue:0.34 alpha:1.0];
    }else if (percent<=.75&&percent>=.5){
        circleColor = [UIColor colorWithRed:0.97 green:0.39 blue:0.34 alpha:1.0];
    }else if(percent<=.5&&percent>=.25){
        circleColor = [UIColor orangeColor];
    }else{
        circleColor = [UIColor blackColor];
    }
    
    self.Circle.color = circleColor;
    self.percentageLabel.textColor = circleColor;
    self.finishLabel.textColor = circleColor;
    self.percentageLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
}

-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}

-(void)indexClick:(UITapGestureRecognizer *)sender{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
    NSString *act;
    if(sender.view.tag==0||sender.view.tag==2){
        act =@"1";
    }else{
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = self.title.text;
        
        NSString *str;
        if (self.Content.text.length>140) {
            str=[self.Content.text substringToIndex:140];
        }else{
            str=self.Content.text;;
        }
        
        message.description=str;
        UIImageView *image = [self.imageArray objectAtIndex:0];
        [message setThumbImage:image.image];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl =  [NSString stringWithFormat:@"%@/Topic/TopicPage/%@",[[AustinApi sharedInstance] getBaseUrl],self.Id];
        //NSLog(@"%@",ext.webpageUrl);
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        
        [WXApi sendReq:req];

        act =@"3";
    }
        [[AustinApi sharedInstance]socialAction:self.Id act:act obj:@"3" function:^(NSString *returnData) {
            NSLog(@"%@",returnData);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        [buttonHelper likeShareClick:sender.view];}
}
-(void)setLikeState:(BOOL)state{
    if(state){
        self.likeBtn.tag = 2;
    }else{
        self.likeBtn.tag = 0;
    }
    [buttonHelper adjustLike:self.likeBtn];
}
-(void)setShareState:(BOOL)state{
    if (state) {
        self.shareBtn.tag=1;
    }else{
        self.shareBtn.tag=3;
    }
    [buttonHelper adjustShare:self.shareBtn];
}
@end
