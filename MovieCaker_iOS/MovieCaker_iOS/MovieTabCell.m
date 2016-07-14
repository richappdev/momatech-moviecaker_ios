//
//  MovieTabCell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTabCell.h"
#import "buttonHelper.h"
@implementation MovieTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ratingBg.layer.cornerRadius = 11;
    [self addIndexGesture:self.reviewBtn];
    [self addIndexGesture:self.watchBtn];
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
        switch (view.tag) {
            case 0:{
                UILabel *label = [view viewWithTag:6];
                int count = [[self.data objectForKey:@"ViewNum"] integerValue];
                if(self.watchBool){
                    count--;
                }else{
                    count++;
                }
                self.watchBool = !self.watchBool;
                [self setWatchState:self.watchBool];
                label.text = [NSString stringWithFormat:@"%d",count];
                [self.data setObject:[NSNumber numberWithInt:count] forKey:@"ViewNum"];
                break;}
            case 3:
                [self.parent gotoEdit:self.index];
                break;
            default:
                break;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setWatchState:(BOOL)state{
    [buttonHelper v2AdjustWatch:self.watchBtn state:state];
    self.watchBool = state;
}
@end
