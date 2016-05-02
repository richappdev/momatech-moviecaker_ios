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
@end
