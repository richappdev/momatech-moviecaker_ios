//
//  SchoolPartyCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolPartyObj.h"

@protocol SchoolPartyCellDelegate <NSObject>
@optional
    - (void)shareButtonPressed:(NSIndexPath *)indexPath WithImage:(UIImage *)image;
    - (void)reloadData;
@end

@interface SchoolPartyCell : UITableViewCell<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *creator;
@property (strong, nonatomic) IBOutlet UILabel *memberCount;
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) SchoolPartyObj *party;
@property (strong, nonatomic) IBOutlet UIImageView *partyBanner;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *publicLabel;

@property (strong, nonatomic) id<SchoolPartyCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL isCreator;


- (IBAction)joinButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *publicImageView;

@end
