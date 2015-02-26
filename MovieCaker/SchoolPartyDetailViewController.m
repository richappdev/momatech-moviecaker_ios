//
//  SchoolPartyDetailViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/12/15.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "SchoolPartyDetailViewController.h"
#import "SchoolPartyHeaderCell.h"
#import "SchoolPartyIntroCell.h"
#import "UIImageView+WebCache.h"

@interface SchoolPartyDetailViewController ()
    @property(nonatomic, strong) NSNumber *uid;
    @property (nonatomic, strong) NSDictionary *userInfo;
    @property (nonatomic, assign) float txtHeight;
@end

@implementation SchoolPartyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=self.party.name;
    
    
    if ([self.manager isLogined]) {
        self.userInfo=[self.manager getLoginUnfo];
        self.uid=self.userInfo[@"UserId"];
    }else{
        self.uid=[NSNumber numberWithInt:0];
    }

    
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyHeaderCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyHeaderCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"SchoolPartyIntroCell" bundle:nil] forCellReuseIdentifier:@"SchoolPartyIntroCell"];
    
    self.txtHeight=[self getContentHeight:self.party.desc width:301 fontSize:14];
}
/*
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
 */

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        self.txtHeight=[self getContentHeight:self.party.desc width:301 fontSize:14];
        return self.txtHeight+250;
    }
    return 250;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        static NSString *cellIdentifier = @"SchoolPartyHeaderCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureSchoolPartyHeaderCell:(SchoolPartyHeaderCell *)cell atIndexPath:indexPath];
        return cell;
    }
    if (indexPath.row==1) {
        static NSString *cellIdentifier = @"SchoolPartyIntroCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self configureSchoolPartyIntroCell:(SchoolPartyIntroCell *)cell atIndexPath:indexPath];
        return cell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     MyVideoViewController *mvvc=[[MyVideoViewController alloc] initWithNibName:@"MyVideoViewController" bundle:nil];
     [self.navigationController pushViewController:mvvc animated:YES];
     */
    
}

-(void)configureSchoolPartyHeaderCell:(SchoolPartyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.partyName.text=self.party.name;
    
    cell.party=self.party;
    cell.creator.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"創辦人",@"InfoPlist",nil),self.party.nickName];
    cell.memberCount.text=[NSString stringWithFormat:@"%@ %@",self.party.memberCount,NSLocalizedStringFromTable(@"會員",@"InfoPlist",nil)];
    cell.desc.text=self.party.desc;
    cell.desc.frame=CGRectMake(10, 42, 301, self.txtHeight+10);
    cell.introView.frame=CGRectMake(0, 165, 320, self.txtHeight+85);
    
    cell.isCreator= (self.uid.intValue==self.party.founderID.intValue) ? YES : NO;
    
    if (self.party.needAuth.boolValue) {
        //已加入
        if (self.party.isJoined.boolValue) {
            //審核過
            if (self.party.isPassAudit.boolValue) {
                
                //退出社團
                
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.joinButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
                }else{
                    [cell.joinButton setImage:[UIImage imageNamed:@"退出社團大.png"] forState:UIControlStateNormal];
                }
                
            }else{
                //審核中
                if ([self.lang isEqualToString:@"zh-Hant"]) {
                    [cell.joinButton setImage:[UIImage imageNamed:@"Audit.png"] forState:UIControlStateNormal];
                }else{
                    [cell.joinButton setImage:[UIImage imageNamed:@"審核中大.png"] forState:UIControlStateNormal];
                }
                
            }
        }else{
            //加入社團
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Societies.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"加入社團大.png"] forState:UIControlStateNormal];
            }
        }
    }else{
        if (self.party.isJoined.boolValue) {
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"退出社團大.png"] forState:UIControlStateNormal];
            }
        }else{
            if ([self.lang isEqualToString:@"zh-Hant"]) {
                [cell.joinButton setImage:[UIImage imageNamed:@"Societies.png"] forState:UIControlStateNormal];
            }else{
                [cell.joinButton setImage:[UIImage imageNamed:@"加入社團大.png"] forState:UIControlStateNormal];
            }
        }
    }

    
    
    NSString *path=[NSString stringWithFormat:@"%@/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.party.avatar];
    [cell.avatar setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];

    NSString *bannerPath=[NSString stringWithFormat:@"%@/Uploads/ClubBanner/Club_%d.jpg",PROPUCTION_API_DOMAIN,self.party.partyID.intValue];
    [cell.banner setImageWithURL:[NSURL URLWithString:bannerPath] placeholderImage:[UIImage imageNamed:@"ngbg-1185.png"]];
    
    cell.btnView3.hidden=YES;
    
}
-(void)configureSchoolPartyIntroCell:(SchoolPartyIntroCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.intro.frame=CGRectMake(10, 0, 301, self.txtHeight);
    cell.intro.text=self.party.desc;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
