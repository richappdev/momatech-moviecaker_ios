//
//  SecondViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieViewController : UIViewController
@property int jump;
@property BOOL newReview;
-(void)loadMore:(int)page;
-(void)refresh;
@end

