//
//  friendCell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/30/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "friendCell.h"

@implementation friendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.statusBg addGestureRecognizer:tap];
}
-(void)click{

    NSLog(@"work");
    [self.parent acceptFriend:self.path];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
