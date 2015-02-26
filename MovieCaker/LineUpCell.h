//
//  LineUpCell.h
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineUpCellDelegate <NSObject>
@optional
    - (void)clickActor:(NSNumber *)actorId withActorName:(NSString *)actorName;
@end

@interface LineUpCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lineUp;
@property (strong, nonatomic) NSArray *actorArray;
@property (strong, nonatomic) id<LineUpCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
-(NSNumber *)lineSet:(NSArray *)lineArray;

@end
