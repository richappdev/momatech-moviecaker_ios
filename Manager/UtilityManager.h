//
//  UtilityManager.h
//  carrefour
//
//  Created by jason on 3/7/13.
//  Copyright (c) 2013 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityManager : NSObject
{
    
}

+ (UtilityManager *)sharedInstance;

- (NSString *)getDocumentDirectoryPath;

- (NSString *)calculateFileMD5:(NSString*)path;
- (NSString *)md5InHexString:(NSString *)source;

- (NSURL *)detectLinkURL:(NSString *)code;

- (void)updateLocalCache:(NSData *)data dataType:(NSString *)type;

- (NSData *)getLocalCachedData:(NSString *)type;

- (NSDictionary *)getLocalCacheMeta:(NSString *)type;

- (NSData *)loadJSONFile:(NSString *)fileName;

@end
