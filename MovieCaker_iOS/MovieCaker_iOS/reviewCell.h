//
//  reviewCell.h
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 7/1/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reviewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *heart;
@property (strong, nonatomic) IBOutlet UILabel *heartNum;
@end
