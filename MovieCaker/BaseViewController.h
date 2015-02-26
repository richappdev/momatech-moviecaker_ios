//
//  BaseViewController.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SWRevealViewController.h"
#import "MovieCakerManager.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "PersistentManager.h"
#import "WaitingAlert.h"

@interface BaseViewController : UIViewController

@property (nonatomic, weak) MovieCakerManager *manager;
@property (nonatomic, strong) SDWebImageManager *imageManager;
@property (nonatomic, strong) PersistentManager *persistentManager;
@property (nonatomic, strong) NSDateFormatter *df;
@property(nonatomic,strong) NSString *lang;
@property (nonatomic, strong) AppDelegate *appDelegate;


- (void)setupDefaultNavBarButtons;
-(float) getContentHeight:(NSString *)str width:(int)width fontSize:(int)fontSize;
-(NSURL *)getUesrBannerUrl:(NSNumber *)userId;
-(NSDictionary *)getUserDashboard:(NSNumber *)userId;

-(NSDictionary *)checkLoginInfo:(NSDictionary *)dic;
-(NSString *)replaceNullString:(id)string;
-(NSNumber *)replaceNullNumber:(id)number;
- (BOOL)isRunningiOS7;
-(NSDate *)stringToDate:(NSString *)string;
-(NSString *)convertDateStringforClubReply:(NSString *)dateString;
-(void)alertShow:(NSString *)msg;
- (BOOL)isRetina4inch;
-(NSString *) removeHTMLTag:(NSString *)str;
-(UIImage *)image:(UIImage *)image cropInSize:(CGSize)viewsize;

@end
