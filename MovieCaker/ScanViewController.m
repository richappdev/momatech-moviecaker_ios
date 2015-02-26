//
//  ScanViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/17.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

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
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"取消",@"InfoPlist",nil)
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(dismiss)];
    
    self.navigationItem.leftBarButtonItem = left;
    [self zbarSetup];
    // Do any additional setup after loading the view from its nib.
}
-(void)dismiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startZbar];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopZbar];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - zbar related

- (void)zbarSetup
{
    self.myReaderView.readerDelegate = self;
}

- (void)zbarCleanUp
{
    self.myReaderView.readerDelegate = nil;
    [self setMyReaderView:nil];
}

- (void)startZbar
{
    [self.myReaderView start];
}

- (void)stopZbar
{
    [self.myReaderView stop];
}

#pragma mark - zbar delegate

- (void)readerView:(ZBarReaderView*)readerView
    didReadSymbols:(ZBarSymbolSet*)symbols
         fromImage:(UIImage*)image
{
    for(ZBarSymbol *sym in symbols)
    {
        NSString *code = sym.data;
        
        NSURL *url=[NSURL URLWithString:code];
        if ([url.host isEqualToString:@"happymovie.azurewebsites.net"]) {
            NSArray *ary=[code componentsSeparatedByString:@"/"];
            
            [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"邀請朋友已送出...",@"InfoPlist",nil) withTimeOut:2];
            
            [self.manager invitFiend:[ary lastObject] callback:^(NSDictionary *result, NSString *errorMsg, NSError *error) {
                [self stopZbar];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }

    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
