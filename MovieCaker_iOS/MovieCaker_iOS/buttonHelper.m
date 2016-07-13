//
//  buttonHelper.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "buttonHelper.h"

@implementation buttonHelper
+(void)likeShareClick:(UIView*)view{
    if(view.tag==0){
        view.tag=2;
        [self adjustLike:view];
    }else
    if(view.tag==1){
        view.tag=3;
        [self adjustShare:view];
    }else
    if(view.tag==2){
        view.tag=0;
        [self adjustLike:view];
    }
}

+(void)adjustLike:(UIView *)view{
    if(view.tag==2){
        UIImageView *image = [view viewWithTag:5];
        image.image = [UIImage imageNamed:@"iconHeartListLiked.png"];
        UILabel *label = [view viewWithTag:6];
        label.textColor = [UIColor colorWithRed:1.00 green:0.53 blue:0.60 alpha:1.0];
    }else
            if(view.tag==0){
                UIImageView *image = [view viewWithTag:5];
                image.image = [UIImage imageNamed:@"iconHeartList.png"];
                UILabel *label = [view viewWithTag:6];
                label.textColor = [UIColor colorWithRed:0.47 green:0.49 blue:0.51 alpha:1.0];
            }
}
+(void)adjustShare:(UIView*)view{
    if(view.tag==3){
    UIImageView *image = [view viewWithTag:5];
    image.image = [UIImage imageNamed:@"iconShareListShared.png"];
    UILabel *label = [view viewWithTag:6];
        label.textColor = [UIColor colorWithRed:0.39 green:0.73 blue:0.34 alpha:1.0];}
    else if(view.tag==1){
        UIImageView *image = [view viewWithTag:5];
        image.image = [UIImage imageNamed:@"iconShareList.png"];
        UILabel *label = [view viewWithTag:6];
        label.textColor = [UIColor colorWithRed:0.47 green:0.49 blue:0.51 alpha:1.0];
    }
}

+(void)gradientBg:(UIImageView*)imageView width:(int)width{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame =CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, width, imageView.frame.size.height);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(1.0f, 0.7f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    imageView.layer.mask = gradientLayer;

}

+ (BOOL)isLabelTruncated:(UILabel *)label
{
    BOOL isTruncated = NO;
    
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(label.bounds.size.width, NSIntegerMax) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil].size;
  //  NSLog(@"%f,%f",size.height,label.frame.size.height);
    if (size.height > label.frame.size.height) {
        isTruncated = YES;
    }
    
    return isTruncated;
}
+(NSMutableDictionary*)reviewNewData:(NSDictionary*)vData User:(NSDictionary *)User{
    NSDictionary *param = @{@"VideoPosterUrl":[vData objectForKey:@"PosterUrl"],@"UserAvatar":[User objectForKey:@"Avatar"],@"UserNickName":[User objectForKey:@"NickName"],@"VideoName":[vData objectForKey:@"CNName"],@"OwnerLinkVideo_Score":@10,@"OwnerLinkVideo_IsLiked":[NSNumber numberWithBool:[[vData objectForKey:@"IsLiked"] boolValue]], @"PageViews":@0,@"LikedNum":@0,@"SharedNum":@0,@"UserId":[User objectForKey:@"UserId"],@"IsLiked":@false,@"IsShared":@false,@"ReviewId":@0,@"VideoId":[vData objectForKey:@"Id"]};
    return [[NSMutableDictionary alloc]initWithDictionary:param];
}
@end
