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
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [self.reviewBtn addGestureRecognizer:indexTap];
}
-(void)indexClick:(UIGestureRecognizer*)gesture{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
    [self.parent gotoEdit:self.index];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
