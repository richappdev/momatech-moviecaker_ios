//
//  CheckInViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "CheckInViewController.h"
#import "ScanViewController.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDefaultNavBarButtons];
    
    if([CLLocationManager locationServicesEnabled] == YES)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"定位中", nil)];
    }
    
    ScanViewController *svc=[[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:svc];
    [self.navigationController presentViewController:nav animated:NO completion:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeForKeyboardEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsubscribeFromKeyboardEvents];
    
    [super viewWillDisappear:animated];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [SVProgressHUD dismiss];
    MKCoordinateRegion mapRegion;
    mapRegion.center.latitude = self.mapView.userLocation.coordinate.latitude;
    mapRegion.center.longitude = self.mapView.userLocation.coordinate.longitude;
    mapRegion.span.latitudeDelta = 0.003;
    mapRegion.span.longitudeDelta = 0.003;
    [self.mapView setRegion:mapRegion animated:NO];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)messageButtonPressed:(id)sender {
    [self.message becomeFirstResponder];
}

- (IBAction)insertButtonPressed:(id)sender {
    [self.message resignFirstResponder];
}

- (IBAction)joinButtonPressed:(id)sender {
    [self.message resignFirstResponder];
}

#pragma mark - keyboard
- (void)subscribeForKeyboardEvents
{
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardEvents
{
    /* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    int curve = [[info  objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:curve
                     animations:^{self.buttonView.center=CGPointMake(160, 484-endFrame.size.height);}
                     completion:nil];
     
}

- (void)keyboardWillHide:(NSNotification *)notification
{

    NSDictionary *info = [notification userInfo];
    int curve = [[info  objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:curve
                     animations:^{self.buttonView.center=CGPointMake(160, 484);}
                     completion:nil];
    
}



@end
