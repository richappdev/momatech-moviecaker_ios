//
//  BaseViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "BaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>



@interface BaseViewController ()
    @property(nonatomic,strong) UIView *notifView;
    @property(nonatomic,strong) UILabel *txtlabel;
    @property (assign) SystemSoundID mySound;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(self.manager == nil)
            self.manager = [MovieCakerManager sharedInstance];
        
        if(self.imageManager == nil)
            self.imageManager = [SDWebImageManager sharedManager];
        
        if(self.persistentManager == nil)
            self.persistentManager = [PersistentManager sharedInstance];
        
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.df = [[NSDateFormatter alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:INBOX_NOTIF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self receivedNotification:NSLocalizedStringFromTable(@"你有一則新的訊息！",@"InfoPlist",nil)];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_NOTIF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self receivedNotification:NSLocalizedStringFromTable(@"你有一則新的通知！",@"InfoPlist",nil)];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:INVITING_NOTIF object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self receivedNotification:NSLocalizedStringFromTable(@"你有一則新的交友邀請！",@"InfoPlist",nil)];
    }];
    
    self.notifView=[[UIView alloc] initWithFrame:CGRectMake(0, -30, 320, 30)];
    self.notifView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    self.txtlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    self.txtlabel.text=NSLocalizedStringFromTable(@"你有一則新的訊息！",@"InfoPlist",nil);
    self.txtlabel.textAlignment=NSTextAlignmentCenter;
    self.txtlabel.font=[UIFont boldSystemFontOfSize:13];
    self.txtlabel.textColor=[UIColor whiteColor];
    
    [self.notifView addSubview:self.txtlabel];
    
    [self.view addSubview:self.notifView];
    
    
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"request" ofType:@"aiff"];
	NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_mySound);
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    
    
    NSArray *languages = [NSLocale preferredLanguages];
    self.lang = [languages objectAtIndex:0];
    NSLog(@"%@",self.lang);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setupDefaultNavBarButtons
{
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"navbar_left_menu"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self.revealViewController
             action:@selector(revealToggle:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"navbar_right_list"] forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 32, 32);
    right.showsTouchWhenHighlighted = YES;
    [right addTarget:self.revealViewController
              action:@selector(rightRevealToggle:)
    forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}

# pragma mark - Get Dynamic cell Height (topicContent)

-(float) getContentHeight:(NSString *)str width:(int)width fontSize:(int)fontSize{
    
    
    
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    CGSize maximumSize = CGSizeMake(width, 9999);
    NSString *myString = str;
    UIFont *myFont = [UIFont boldSystemFontOfSize:fontSize];
    if (myString) {
        CGSize myStringSize = [myString sizeWithFont: myFont
                                   constrainedToSize: maximumSize
                                       lineBreakMode: lb.lineBreakMode];
    
        return myStringSize.height;
    }
    return 0;
}

-(NSURL *)getUesrBannerUrl:(NSNumber *)userId{
    
    NSString *path=[NSString stringWithFormat:@"%@/api/UserBanner/%@",PROPUCTION_API_DOMAIN,userId.stringValue];
    NSError *error = nil;
    NSString *bannerPath=[NSString stringWithContentsOfURL:[NSURL URLWithString:path] encoding:NSUTF8StringEncoding error:&error];
    bannerPath=[bannerPath substringWithRange:NSMakeRange(1,bannerPath.length-2)];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?width=320",bannerPath]];
}

-(NSDictionary *)getUserDashboard:(NSNumber *)userId{
    
    NSDictionary *dashBoardInfo=nil;
    NSString *path=[NSString stringWithFormat:@"%@/api/UserDashboard/%@",PROPUCTION_API_DOMAIN,userId.stringValue];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    dashBoardInfo=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    return dashBoardInfo;
}

-(NSDictionary *)checkLoginInfo:(NSDictionary *)loginInfo{
    NSMutableDictionary *data=[loginInfo objectForKey:@"data"];
    if (!data) {
        data=[[NSMutableDictionary alloc] initWithDictionary:loginInfo];
    }
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setValue:[self replaceNullString:data[@"Avatar"]] forKey:@"Avatar"];
    [dic setValue:[self replaceNullString:data[@"Intro"]]  forKey:@"Intro"];
    [dic setValue:[self replaceNullString:data[@"Banner"]] forKey:@"Banner"];
    [dic setValue:[self replaceNullNumber:data[@"BannerType"]] forKey:@"BannerType"];
    [dic setValue:[self replaceNullString:data[@"FristName"]] forKey:@"FristName"];
    [dic setValue:[self replaceNullString:data[@"LastName"]] forKey:@"LastName"];
    [dic setValue:[self replaceNullNumber:data[@"EditStage"]] forKey:@"EditStage"];
    [dic setValue:[self replaceNullNumber:data[@"Gender"]] forKey:@"Gender"];
    [dic setValue:[self replaceNullNumber:data[@"IsCompleteEditProfile"]] forKey:@"IsCompleteEditProfile"];
    [dic setValue:[self replaceNullNumber:data[@"Location"]] forKey:@"Location"];
    [dic setValue:[self replaceNullNumber:data[@"MasterLocation"]] forKey:@"MasterLocation"];
    [dic setValue:[self replaceNullString:data[@"LocationName"]] forKey:@"LocationName"];
    [dic setValue:[self replaceNullString:data[@"NickName"]] forKey:@"NickName"];
    [dic setValue:[self replaceNullNumber:data[@"UserId"]] forKey:@"UserId"];
    [dic setValue:[self replaceNullString:data[@"UserName"]] forKey:@"UserName"];
    
    return dic;
    
}
-(NSString *)replaceNullString:(id)string{
    NSString *str=[NSString stringWithFormat:@"%@",string];
    if ([str isEqualToString:@"<null>"]) {
        return @"";
    }
    return str;
    
}

-(NSNumber *)replaceNullNumber:(id)number{
    NSString *str=[NSString stringWithFormat:@"%@",number];
    if ([str isEqualToString:@"<null>"]) {
        return [NSNumber numberWithInt:0];
    }
    return number;
}

-(NSDate *)stringToDate:(NSString *)string{
    
    NSArray *dateAry=[string componentsSeparatedByString:@"-"];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[dateAry[2] intValue]];
    [components setMonth:[dateAry[1] intValue]];
    [components setYear:[dateAry[0] intValue]];
    components.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    NSCalendar *cal=  [NSCalendar currentCalendar];
    
    return [cal dateFromComponents:components];
}

-(NSString *)convertDateStringforClubReply:(NSString *)dateString{
    
    NSLog(@"%@",dateString);
    
    //2014-05-08T15:31:04.013
    //NSArray *dateAry=[dateString componentsSeparatedByString:@"-"];
    NSString *year=[dateString substringWithRange:NSMakeRange(0,4)];
    NSString *month=[dateString substringWithRange:NSMakeRange(5,2)];
    NSString *day=[dateString substringWithRange:NSMakeRange(8,2)];
    NSString *hour=[dateString substringWithRange:NSMakeRange(11,2)];
    NSString *min=[dateString substringWithRange:NSMakeRange(14,2)];
    
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[day intValue]];
    [components setMonth:[month intValue]];
    [components setYear:[year intValue]];
    [components setHour:[hour intValue]];
    [components setMinute:[min intValue]];
    
    components.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    
    
    NSCalendar *cal=  [NSCalendar currentCalendar];
    
    NSDate *dateTime=[cal dateFromComponents:components];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    dateformatter.dateFormat = @"yyyy/MM/dd HH:mm";
    
    
    
    return [dateformatter stringFromDate:dateTime];
}

- (BOOL)isRunningiOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

-(void)receivedNotification:(NSString *)txt{
    AudioServicesPlaySystemSound(self.mySound);
    self.txtlabel.text=txt;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.notifView.frame = CGRectMake(0, 0, 320 , 30);
                     } completion:^(BOOL finished) {
                         [self resetNotification];
                     }];
    
}
-(void)resetNotification{
    [UIView animateWithDuration:0.3
                          delay:2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.notifView.frame = CGRectMake(0, -30, 320 , 30);
                     }
                     completion:nil];
}

//秀出Alert(單選)
-(void)alertShow:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedStringFromTable(@"確定",@"InfoPlist",nil)
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)isRetina4inch
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (scale == 2.0f)
        {
            if (pixelHeight == 1136.0f)
                return YES;
        }
    }
    return NO;
}
-(NSString *) removeHTMLTag:(NSString *)str{
    str=[str stringByReplacingOccurrencesOfString:@"<!DOCTYPE html>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"<html>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"<head>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"</head>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"<body>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"<p>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"</p>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"</body>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"</html>"
                                       withString:@""];
    str=[str stringByReplacingOccurrencesOfString:@"<BR>"
                                       withString:@"\n"];
    str=[str stringByReplacingOccurrencesOfString:@"<br />"
                                       withString:@"\n"];
    
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return str;
}

//取得圖片給weChat分享
-(UIImage *)image:(UIImage *)image cropInSize:(CGSize)viewsize{
    
    //圖像的尺寸
    CGSize size=image.size;
    
    //新的尺寸
    CGSize newSize=CGSizeMake(0, 0);
    
    float rateW=viewsize.width/size.width;
    float rateH=viewsize.height/size.height;
    
    if (rateH>rateW) {
        //橫式圖片
        newSize=CGSizeMake(size.width*rateH, size.height*rateH);
    }else{
        //直式圖片
        newSize=CGSizeMake(size.width*rateW, size.height*rateW);
    }
    
    UIGraphicsBeginImageContext(newSize);
    
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    [image drawInRect:rect];
    //取得等比縮小的圖像，不是長100，就是寬100
    UIImage *tempImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //計算卡圖的起點 x, y
    float startX=(newSize.width-viewsize.width)/2.0f;
    float startY=(newSize.height-viewsize.height)/2.0f;
    
    UIGraphicsBeginImageContext(viewsize);
    
    //設定卡圖的起點及大小
    rect = CGRectMake(startX, startY, viewsize.width, viewsize.height);
    
    CGImageRef clipImage = CGImageCreateWithImageInRect(tempImg.CGImage, rect);
    //取得我們所要的圖
    UIImage *uiClipImage=[UIImage imageWithCGImage:clipImage];
    
    CGImageRelease(clipImage);
    return uiClipImage;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
