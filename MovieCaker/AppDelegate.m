//
//  AppDelegate.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/13.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "AppDelegate.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "SignUpViewController.h"
#import "TopicViewController.h"
#import "MovieCakerManager.h"



@interface AppDelegate() <SWRevealViewControllerDelegate>
    
@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [ZBarReaderView class];
    // bring back the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
#ifdef __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
    
    // -------------------- root view --------------------
    
    TopicViewController *frontViewController = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    
    RightViewController *right = [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    UINavigationController *nav_right = [[UINavigationController alloc] initWithRootViewController:right];
    [nav_right setNavigationBarHidden:YES];
    
    
    LeftViewController *rearViewController = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    [rearNavigationController setNavigationBarHidden:YES];
    
    /*
    self.rvc = [[SWRevealViewController alloc] initWithRearViewController:nav_left frontViewController:nil];
    
    self.rvc.rightViewController = nav_right;
    self.rvc.delegate = self;
     */
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    
    
    RightViewController *rightViewController = [[RightViewController alloc] init];
    //rightViewController.view.backgroundColor = [UIColor greenColor];
    
    revealController.rightViewController = rightViewController;
    
    // default view is edm view
   // [self showHome];
    self.viewController = revealController;
    
    self.window.rootViewController = self.viewController ;
    
    // -------------------- appearence --------------------
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    // -------------------- push --------------------
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // ---------------------- UI customization ---------------------
    
    UIColor *movieCakerBlack = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    
    [[UINavigationBar appearance] setBackgroundColor:movieCakerBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIImage *image = [UIImage imageNamed:@"navbar_default"];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
        [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"search_bar_bg_white"]];
    // [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_default"]];
    
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_default"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    [FBLoginView class];
    
    self.autoLogin=YES;
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Register your app
    [WXApi registerApp:@"wx67639291e86b2f9a" withDescription:@"Version 1.0"];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    
    return YES;
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    /*
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
        [self.viewController presentModalViewController:controller animated:YES];
    }
     */
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    /*
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
         
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        
        [alert show];
        

    }
     */
}

/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:_sendMsgToWechatMgr];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:_sendMsgToWechatMgr];
}
*/

-(void)showSignUpView{
    
    SignUpViewController *suvc= [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:suvc];
    nav.navigationBarHidden=YES;
    /*
    [self.rvc presentViewController:nav animated:NO completion:^{
        [self showHome];
    }];
     */

    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
 

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
	// Handle the notification when the app is running
	NSLog(@"Recieved Notification %@",notif);
}


-(void)updateNotice:(id)sender{
    
    if ([[MovieCakerManager sharedInstance] isLogined]) {
        [[MovieCakerManager sharedInstance] notice:@"Message" success:^(BOOL showLocalNotification, NSString *errorMsg, NSError *error) {
            if (showLocalNotification) {
                [[NSNotificationCenter defaultCenter] postNotificationName:INBOX_NOTIF object:nil];
            }
        
            [self performSelector:@selector(updateNotification) withObject:self afterDelay:5];
        }];
    }
}

-(void)updateNotification{
    if ([[MovieCakerManager sharedInstance] isLogined]) {
        [[MovieCakerManager sharedInstance] notice:@"NotificationAndReminder" success:^(BOOL showLocalNotification, NSString *errorMsg, NSError *error) {
            if (showLocalNotification) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOTIF object:nil];
            }
            [self performSelector:@selector(updateInviting) withObject:self afterDelay:5];
        }];
    }
}

-(void)updateInviting{
    if ([[MovieCakerManager sharedInstance] isLogined]) {
        [[MovieCakerManager sharedInstance] notice:@"Inviting" success:^(BOOL showLocalNotification, NSString *errorMsg, NSError *error) {
            if (showLocalNotification) {
                [[NSNotificationCenter defaultCenter] postNotificationName:INVITING_NOTIF object:nil];
            }
        }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    [FBSession.activeSession handleDidBecomeActive];
    
    [NSTimer scheduledTimerWithTimeInterval:20
                                     target:self
                                   selector:@selector(updateNotice:)
                                   userInfo:nil
                                    repeats:YES];
    

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self.session close];
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MovieCaker" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MovieCaker.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [self.session handleOpenURL:url];
}
 */

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"sourceApplication:%@",sourceApplication);
    
    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Parse the incoming URL to look for a target_url parameter
                                      NSString *query = [url fragment];
                                      if (!query) {
                                          query = [url query];
                                      }
                                      NSDictionary *params = [self parseURLParams:query];
                                      // Check if target URL exists
                                      NSString *targetURLString = [params valueForKey:@"target_url"];
                                      if (targetURLString) {
                                          // Show the incoming link in an alert
                                          // Your code to direct the user to the appropriate flow within your app goes here
                                          [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                                                      message:targetURLString
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil] show];
                                      }
                                  }];
    
    return urlWasHandled;
    
    
    

}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeftSideMostRemoved ) str = @"FrontViewPositionLeftSideMostRemoved";
    if ( position == FrontViewPositionLeftSideMost) str = @"FrontViewPositionLeftSideMost";
    if ( position == FrontViewPositionLeftSide) str = @"FrontViewPositionLeftSide";
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealControllerPanGestureBegan:(SWRevealViewController *)revealController;
{
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealControllerPanGestureEnded:(SWRevealViewController *)revealController;
{
    NSLog( @"%@", NSStringFromSelector(_cmd) );
}

- (void)revealController:(SWRevealViewController *)revealController panGestureBeganFromLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

- (void)revealController:(SWRevealViewController *)revealController panGestureEndedToLocation:(CGFloat)location progress:(CGFloat)progress
{
    NSLog( @"%@: %f, %f", NSStringFromSelector(_cmd), location, progress);
}

@end
