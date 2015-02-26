//
//  CardViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/2/18.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "CardViewController.h"
#import "MyHeaderCell.h"
#import "ZXingObjC.h"
#import "ScanViewController.h"

@interface CardViewController ()
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation CardViewController

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
    
    self.title=NSLocalizedStringFromTable(@"QRCode 名片",@"InfoPlist",nil);
     [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyHeaderCell"];
    
    NSError* error = nil;
    
    self.userInfo=[self.manager getLoginUnfo];
    NSNumber *userId=self.userInfo[@"UserId"];
    NSString *path=[NSString stringWithFormat:@"http://happymovie.azurewebsites.net/api/Inviting/%@",userId.stringValue];
    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:path
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        UIImage *imageObj=[UIImage imageWithCGImage:image];
        self.qrcodeImageView.image=imageObj;
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        //NSString* errorMessage = [error localizedDescription];
    }
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"MyHeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:indexPath];
    return cell;

}


-(void)configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *gender =(self.friend.gender.boolValue)? NSLocalizedStringFromTable(@"男",@"InfoPlist",nil):NSLocalizedStringFromTable(@"女",@"InfoPlist",nil);
    cell.addFriendButton.hidden=self.friend.isFriend.boolValue;
    cell.friend=self.friend;
    cell.userName.text=[NSString stringWithFormat:@" %@ %@ %@",self.friend.nickName,self.friend.locationName,gender];
    cell.addFriendButton.hidden=YES;
    
    NSString *path=[NSString stringWithFormat:@"%@/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.friend.avatar];
    NSURL *bannerUrl=[self getUesrBannerUrl:self.friend.userId];
    [cell.userBanner setImageWithURL:bannerUrl placeholderImage:nil];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanButtonPressed:(id)sender {
    ScanViewController *svc=[[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:svc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
@end
