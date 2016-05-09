//
//  scrollBoxView.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/9/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "scrollBoxView.h"

@implementation scrollBoxView
@synthesize scrollView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self pointInside:point withEvent:event] ? scrollView : nil;
}

@end
