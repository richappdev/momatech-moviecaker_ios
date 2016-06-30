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
@end
