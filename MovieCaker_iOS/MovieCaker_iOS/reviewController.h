//
//  reviewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 6/23/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reviewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
-(IBAction)readMore:(id)sender;
@property NSMutableDictionary *data;
@property BOOL sync;
@end
