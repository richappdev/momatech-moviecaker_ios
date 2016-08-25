//
//  noticeCell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 8/26/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noticeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
