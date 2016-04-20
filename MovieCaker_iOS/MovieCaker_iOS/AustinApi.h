//
//  AustinApi.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 4/20/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AustinApi : NSObject

+ (instancetype)sharedInstance;

-(void)apiRegisterPost:(NSString*)unionId completion:(void (^)(NSMutableDictionary *returnData))completion error:(void (^)(NSError *error))error;
@end
