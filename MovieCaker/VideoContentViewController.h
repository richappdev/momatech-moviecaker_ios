//
//  VideoContentViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/2/11.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "VideoObj.h"

@interface VideoContentViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) VideoObj *video;
@property (strong, nonatomic) NSString *videoId;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (assign, nonatomic) int landingNo;
@property BOOL gotoMovieReview;

- (IBAction)didChangeSegmentControl:(id)sender;

@end
