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
        //view.tag=3; shouldn't be able to unshare
        [self adjustShare:view];
    }else
    if(view.tag==2){
        view.tag=0;
        [self adjustLike:view];
    }else
    if(view.tag==3){
        view.tag=1;
        UIImageView *image = [view viewWithTag:5];
        image.image = [UIImage imageNamed:@"iconShareList.png"];
        UILabel *label = [view viewWithTag:6];
        label.textColor = [UIColor colorWithRed:0.47 green:0.49 blue:0.51 alpha:1.0];
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
    if(view.tag==1){
    UIImageView *image = [view viewWithTag:5];
    image.image = [UIImage imageNamed:@"iconShareListShared.png"];
    UILabel *label = [view viewWithTag:6];
        label.textColor = [UIColor colorWithRed:0.39 green:0.73 blue:0.34 alpha:1.0];}
    else if(view.tag==3){
        UIImageView *image = [view viewWithTag:5];
        image.image = [UIImage imageNamed:@"iconShareList.png"];
        UILabel *label = [view viewWithTag:6];
        label.textColor = [UIColor colorWithRed:0.47 green:0.49 blue:0.51 alpha:1.0];
    }
}
@end
