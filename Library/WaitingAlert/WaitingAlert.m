/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.x Edition
 BSD License, Use at your own risk
 */


#import "WaitingAlert.h"
#import "WCAlertView.h"

static NSTimer *timer = nil;

@implementation WaitingAlert
+ (void) presentWithText: (NSString *) alertText
{
     [WCAlertView getStaticWaitingAlert:alertText message:nil customizationBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleBlack;
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            NSLog(@"Cancel");
        } else {
            NSLog(@"Ok");
        }
    } cancelButtonTitle:nil otherButtonTitles:nil, nil];
}

+ (void) presentWithText: (NSString *) alertText withTimeOut:(NSInteger)second
{
    [self presentWithText:alertText];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: second
                                             target: self
                                           selector: @selector(dismiss)
                                           userInfo: nil
                                            repeats: NO];
}

+ (void) dismiss
{
    [WCAlertView dismissWaitingAlert];
    [timer invalidate];
}


@end
