//
//  CheckInViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface CheckInViewController : BaseViewController<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *insertButton;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;

- (IBAction)messageButtonPressed:(id)sender;
- (IBAction)insertButtonPressed:(id)sender;
- (IBAction)joinButtonPressed:(id)sender;

@end
