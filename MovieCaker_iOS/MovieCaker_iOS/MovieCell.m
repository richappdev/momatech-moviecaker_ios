//
//  MovieCell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/1/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieCell.h"
#import "buttonHelper.h"
@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
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
    [buttonHelper likeShareClick:sender.view];
}

@end
