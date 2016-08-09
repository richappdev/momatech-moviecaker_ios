//
//  Movie2Cell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "Movie2Cell.h"
#import "buttonHelper.h"
#import "AustinApi.h"
#import "WXApi.h"
#import "WechatAccess.h"
@implementation Movie2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
    self.starArray = [[NSArray alloc] initWithObjects:self.star1,self.star2,self.star3,self.star4,self.star5, nil];
    self.mainPic.layer.masksToBounds = YES;
    self.mainPic.layer.cornerRadius =5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        [self.parent sync];
        NSString *act;
        if(sender.view.tag==0||sender.view.tag==2){
            act =@"1";
        }else{
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = self.Title.text;
            
            NSString *str;
            if (self.Content.text.length>140) {
                str=[self.Content.text substringToIndex:140];
            }else{
                str=self.Content.text;;
            }
            
            message.description=str;

            [message setThumbImage:self.mainPic.image];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl =  [NSString stringWithFormat:@"%@/video/%@",[[AustinApi sharedInstance] getBaseUrl],self.videoId];
            NSLog(@"%@",ext.webpageUrl);
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            [WXApi sendReq:req];

            act =@"3";
        }
        [[AustinApi sharedInstance]socialAction:self.Id act:act obj:@"2" function:^(NSString *returnData) {
            NSLog(@"%@",returnData);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        [buttonHelper likeShareClick:sender.view];}
}
-(void)setStars:(int)rating{
    int main =floor(rating/2);
    int remain = rating%2;
    int count = 1;
    for (UIImageView *row in self.starArray) {
        if(main>=count){
            row.image = [UIImage imageNamed:@"iconStar.png"];
        }else if (remain==1&&count==(main+1)){
            row.image = [UIImage imageNamed:@"iconSatrHalfO.png"];
        }else{
            row.image = [UIImage imageNamed:@"iconStarO"];
        }
        
        count++;
    }

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
        self.shareBtn.tag=3;
         }else{
        self.shareBtn.tag=1;
    }
    [buttonHelper adjustShare:self.shareBtn];
}
@end
