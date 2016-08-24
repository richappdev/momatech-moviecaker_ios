//
//  CircleView.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

-(void)awakeFromNib{
    self.layers = [[NSMutableArray alloc]init];
}
- (void)drawRect:(CGRect)rect {
    for (CAShapeLayer *row in self.layers) {
        [row removeFromSuperlayer];
    }
    float to_value = self.percentage;
    if(to_value==0){
        to_value =0.000001;
        //zero doesn't show gray line for some reason
    }
    if(to_value==1){
        to_value=0.9999;
    }
    float start_angle = -M_PI_2;
    float end_angle = 2*M_PI*to_value-M_PI_2;

    float radius = 26.0;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    // Make a circular shape
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                 radius:radius startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = self.color.CGColor;
    circle.lineWidth = 2;
    
    // Add to parent layer
    [self.layer addSublayer:circle];
    [self.layers addObject:circle];
    
    CAShapeLayer *circle2 = [CAShapeLayer layer];
    circle2.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                 radius:radius startAngle:end_angle endAngle:start_angle clockwise:YES].CGPath;
    circle2.fillColor = [UIColor clearColor].CGColor;
    circle2.strokeColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0].CGColor;
    circle2.lineWidth = 1;
    [self.layer addSublayer:circle2];
    [self.layers addObject:circle2];
}


@end
