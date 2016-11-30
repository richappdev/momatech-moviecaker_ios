//
//  FriendProfileViewController.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 11/29/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendProfileViewController : UIViewController
@property NSDictionary *data;
@property (strong, nonatomic) IBOutlet UIImageView *banner;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIImageView *gender;
@end
