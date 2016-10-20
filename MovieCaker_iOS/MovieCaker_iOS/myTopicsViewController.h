//
//  myTopicsViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/12/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myTopicsViewController : UIViewController
@property NSString *nickName;
@property BOOL jump;
-(void)loadMore:(int)page;
@end
