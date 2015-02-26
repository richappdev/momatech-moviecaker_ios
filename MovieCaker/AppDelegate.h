//
//  AppDelegate.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "WXApi.h"
//#import "SendMsgToWechatMgr.h"

//@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (readonly, strong, nonatomic) RootViewController *homeViewController;
//@property (readonly, strong, nonatomic) IIViewDeckController *ivdc;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property (strong, nonatomic) FBSession *session;

@property (assign, nonatomic) BOOL autoLogin;
@property (strong, nonatomic) NSString *wbtoken;
//@property (strong, nonatomic) SendMsgToWechatMgr *_sendMsgToWechatMgr;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)showSignUpView;

@end
