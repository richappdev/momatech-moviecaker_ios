//
//  MovieTabCell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTabCell.h"
#import "buttonHelper.h"
#import "AustinApi.h"
@implementation MovieTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ratingBg.layer.cornerRadius = 11;
    [self addIndexGesture:self.reviewBtn];
    [self addIndexGesture:self.watchBtn];
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.wannaBtn];
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 5;
}
-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}
-(void)indexClick:(UIGestureRecognizer*)gesture{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        UIView *view = gesture.view;
        if(view.tag==0||view.tag==1||view.tag==2){
    
            UILabel *label = [view viewWithTag:6];
            NSNumber *boolValue;
            int count;
                if(view.tag==0){
                    count = [[self.data objectForKey:@"ViewNum"] integerValue];
                    boolValue = self.watchBool;
                }else if (view.tag==1){
                    count = [[self.data objectForKey:@"LikeNum"] integerValue];
                    boolValue = self.likeBool;
                }else if (view.tag==2){
                    count = [[self.data objectForKey:@"WantViewNum"] integerValue];
                    boolValue = self.wannaBool;
                }
                if([boolValue boolValue]){
                    count--;
                }else{
                    count++;
                }
            
            
            if(view.tag==0){
                [self setWatchState:![boolValue boolValue]];
                [self.data setObject:self.watchBool forKey:@"IsViewed"];
                [self.data setObject:[NSNumber numberWithInt:count] forKey:@"ViewNum"];
            }else if (view.tag==1){
                [self setLikeState:![boolValue boolValue]];
                [self.data setObject:self.likeBool forKey:@"IsLiked"];
                [self.data setObject:[NSNumber numberWithInt:count] forKey:@"LikeNum"];
            }else if (view.tag==2){
                [self setWannaState:![boolValue boolValue]];
                [self.data setObject:self.wannaBool forKey:@"IsWantView"];
                [self.data setObject:[NSNumber numberWithInt:count] forKey:@"WantViewNum"];
            }
                label.text = [NSString stringWithFormat:@"%d",count];
            [[AustinApi sharedInstance]socialAction:[self.data objectForKey:@"Id"] act:[NSString stringWithFormat:@"%d",view.tag] obj:@"1" function:^(NSString *returnData) {
                NSLog(@"%@",returnData);
            } error:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }else if (view.tag==3){
            [self.parent gotoEdit:self.index];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setWatchState:(BOOL)state{
    [buttonHelper v2AdjustWatch:self.watchBtn state:state];
    self.watchBool = [[NSNumber alloc] initWithBool:state];
}
-(void)setLikeState:(BOOL)state{
    [buttonHelper v2AdjustLike:self.likeBtn state:state];
    self.likeBool = [[NSNumber alloc] initWithBool:state];
}
-(void)setWannaState:(BOOL)state{
    [buttonHelper v2AdjustWanna:self.wannaBtn state:state];
    self.wannaBool = [[NSNumber alloc] initWithBool:state];
}
@end
