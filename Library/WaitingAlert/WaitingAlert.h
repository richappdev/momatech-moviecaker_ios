/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.x Edition
 BSD License, Use at your own risk
 */


#import <Foundation/Foundation.h>

@interface WaitingAlert : NSObject
+ (void) presentWithText: (NSString *) alertText;
+ (void) dismiss;
+ (void) presentWithText: (NSString *) alertText withTimeOut:(NSInteger)second;

@end
