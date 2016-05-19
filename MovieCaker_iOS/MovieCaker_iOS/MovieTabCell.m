//
//  MovieTabCell.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 5/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieTabCell.h"

@implementation MovieTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ratingBg.layer.cornerRadius = 11;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
