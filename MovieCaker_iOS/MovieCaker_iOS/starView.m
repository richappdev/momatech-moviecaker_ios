//
//  starView.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 6/29/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "starView.h"

@implementation starView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.edit){
    UITouch *aTouch = [touches anyObject];
    CGPoint point = [aTouch locationInView:self];
        [self setStars:(int)(point.x/(self.frame.size.width-10)*10)];
    }
}
-(void)setStars:(int)rating{
    self.rating = rating;
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
- (void) awakeFromNib
{
    [super awakeFromNib];
    self.starArray = [[NSArray alloc] initWithObjects:self.star1,self.star2,self.star3,self.star4,self.star5, nil];
}
@end
