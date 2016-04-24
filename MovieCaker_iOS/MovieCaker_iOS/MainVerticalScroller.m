//
//  MainVerticalScroller.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/25/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MainVerticalScroller.h"

@implementation MainVerticalScroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //offset is -64 for some weird unknown reason
    float alpha;
    if(scrollView.contentOffset.y>=0){
        alpha = 1;
    }else{
    alpha = scrollView.contentOffset.y/64+1;
        
    }

    self.movieView.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:(100/255.0) green:(186/255.0) blue:(87/255.0) alpha:alpha];
    self.movieView.statubarBg.backgroundColor = [UIColor colorWithRed:(100/255.0) green:(186/255.0) blue:(87/255.0) alpha:alpha];
    [self.movieView.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:alpha]}];
}

@end
