//
//  UtilityManager.m
//  carrefour
//
//  Created by jason on 3/7/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#import "UtilityManager.h"
#include "FileMD5Hash.h"
#import "AppDelegate.h"

@implementation UtilityManager

- (NSString *)getDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES) lastObject];
}

- (NSString *)calculateFileMD5:(NSString*)path
{
    NSString *md5 = @"";
    CFStringRef fileMD5Hash = FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
    if (fileMD5Hash)
    {
        md5 = ((NSString *)CFBridgingRelease(fileMD5Hash));
    }
    
    return md5;
}

- (NSString *)md5InHexString:(NSString *)source
{
	const char *cStr = [source UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

- (NSData *)loadJSONFile:(NSString *)fileName
{
    NSData *json = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    if(!filePath)
    {
        NSLog(@"unable to load file named: %@", fileName);
        
        return nil;
    }
    
    json = [[NSData alloc] initWithContentsOfFile:filePath];
    
    if(!json)
    {
        NSLog(@"zomg could not read JSON");
    }
    
    return json;
}

- (NSURL *)detectLinkURL:(NSString *)code
{
    NSURL *link = nil;
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink
                                                               error:&error];
    if(error == nil)
    {
        NSArray *matches = [detector matchesInString:code
                                             options:0
                                               range:NSMakeRange(0, [code length])];
        
        for (NSTextCheckingResult *match in matches)
        {
            if ([match resultType] == NSTextCheckingTypeLink)
            {
                link = [match URL];
                break;
            }
        }
    }
    
    return link;
}

#pragma mark - local cache

- (void)updateLocalCache:(NSData *)data dataType:(NSString *)type
{
    if(!data)
        return;
    
    // save the cache meta info to userDefaults
    NSString *cacheKey = [NSString stringWithFormat:@"cache_%@", type];
    NSDictionary *cacheMeta = @{@"lastUpdated": [NSDate date]};
    [[NSUserDefaults standardUserDefaults] setObject:cacheMeta forKey:cacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSURL *fileURL = [[delegate applicationDocumentsDirectory] URLByAppendingPathComponent:type];
    
    // save the cache to disc
    [data writeToURL:fileURL atomically:YES];
}

- (NSData *)getLocalCachedData:(NSString *)type
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSURL *fileURL = [[delegate applicationDocumentsDirectory] URLByAppendingPathComponent:type];
    
    return [NSData dataWithContentsOfURL:fileURL];
}

- (NSDictionary *)getLocalCacheMeta:(NSString *)type
{
    NSString *cacheKey = [NSString stringWithFormat:@"cache_%@", type];
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:cacheKey];
}

#pragma mark - singleton implementation code

//static UtilityManager *singletonManager = nil;
+ (UtilityManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static UtilityManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
//+ (id)allocWithZone:(NSZone *)zone {
//    @synchronized(self) {
//        if (singletonManager == nil) {
//            singletonManager = [super allocWithZone:zone];
//            return singletonManager;  // assignment and return on first allocation
//        }
//    }
//    return nil; // on subsequent allocation attempts return nil
//}
//- (id)copyWithZone:(NSZone *)zone {
//    return self;
//}

@end
