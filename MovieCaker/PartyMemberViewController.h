//
//  PartyMemberViewController.h
//  MovieCaker
//
//  Created by iKevin on 2014/4/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "BaseViewController.h"
#import "SchoolPartyObj.h"
#import "SchoolPartyHeaderCell.h"

@interface PartyMemberViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SchoolPartyHeaderCellDelegate>
@property (strong, nonatomic) SchoolPartyObj *party;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end
