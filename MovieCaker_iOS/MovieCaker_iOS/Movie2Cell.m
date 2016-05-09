//
//  Movie2Cell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/2/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "Movie2Cell.h"
#import "buttonHelper.h"
@implementation Movie2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
    self.starArray = [[NSArray alloc] initWithObjects:self.star1,self.star2,self.star3,self.star4,self.star5, nil];
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
    [buttonHelper likeShareClick:sender.view];
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
@end
