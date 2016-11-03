//
//  scanViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/7/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "scanViewController.h"
#import "MainVerticalScroller.h"
#import "AustinApi.h"

@interface scanViewController ()
@property MainVerticalScroller *helper;
@property (strong, nonatomic) IBOutlet UIView *bg;
@property (strong, nonatomic) IBOutlet ZBarReaderView *reader;
@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedStringFromTableInBundle(@"scan.title", @"Main", [NSBundle mainBundle], nil);
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
    self.bg.layer.borderColor = [UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1].CGColor;
    self.bg.layer.borderWidth = 3.0f;
    
    self.reader.readerDelegate = self;
    [self.reader start];
}

- (void)readerView:(ZBarReaderView*)readerView
    didReadSymbols:(ZBarSymbolSet*)symbols
         fromImage:(UIImage*)image
{
    
    NSString *code =@"as";
    for(ZBarSymbol *sym in symbols)
    {
        code = sym.data;
        NSLog(@"%@",code);
        
    }
    [[AustinApi sharedInstance]inviteFriend:code function:^(NSString *returnData) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"朋友已被邀请" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
@end
