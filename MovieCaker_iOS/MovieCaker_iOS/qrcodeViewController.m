//
//  qrcodeViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 9/5/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "qrcodeViewController.h"
#import "MainVerticalScroller.h"
#import "ZXingObjC.h"

@interface qrcodeViewController ()
@property MainVerticalScroller *helper;
@property (strong, nonatomic) IBOutlet UIImageView *qrcode;
@end

@implementation qrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的QR Code";
    self.helper = [[MainVerticalScroller alloc]init];
    self.helper.nav = self.navigationController;
    [self.helper setupBackBtn2:self];
    [self.helper setupSinglePage:self.view];
    
    self.qrcode.layer.borderColor = [UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1].CGColor;
    self.qrcode.layer.borderWidth = 3.0f;
    
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]];

    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:[[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue]
                                  format:kBarcodeFormatQRCode
                                   width:148
                                  height:148
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        self.qrcode.image = [[UIImage alloc] initWithCGImage:image];
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{

    self.navigationController.navigationBarHidden = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
