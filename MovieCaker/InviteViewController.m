//
//  InviteViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/5/4.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "InviteViewController.h"
#import "MyViewController.h"


@interface InviteViewController ()
    @property(strong, nonatomic) NSArray *dataArray;
@end

@implementation InviteViewController

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
    self.title=NSLocalizedStringFromTable(@"交友邀請",@"InfoPlist",nil);
    [self setupDefaultNavBarButtons];
    
     [self.myTableView registerNib:[UINib nibWithNibName:@"InviteCell" bundle:nil] forCellReuseIdentifier:@"InviteCell"];
    
    /*
    [self.manager resetNotice:@"Reminder" success:^(BOOL showLocalNotification, NSString *errorMsg, NSError *error) {

    }];
     */
    
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    [self.manager inviting:^(NSArray *dataArray, NSString *errorMsg, NSError *error) {
        self.dataArray=dataArray;
        [self.manager saveInviting:self.dataArray.count];
        [self.myTableView reloadData];
    }];
}

#pragma mark - InviteCellDelegate
- (void)refreshData {
    [self loadData];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 56;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"InviteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureInviteCell:(InviteCell *)cell atIndexPath:indexPath];
    return cell;
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // SearchObj *obj=[self.listArray objectAtIndex:indexPath.row];
    
    NSDictionary *dic=self.dataArray[indexPath.row];
    MyViewController *mvc=[[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
    NSNumber *friendUserId=dic[@"FriendUserId"];
    mvc.userId= [NSNumber numberWithInteger: [friendUserId integerValue]];
    [self.navigationController pushViewController:mvc animated:YES];
    
    
}

-(void) configureInviteCell:(InviteCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic=self.dataArray[indexPath.row];
    cell.userId=dic[@"FriendUserId"];
    cell.nickName.text=dic[@"Name"];
    [cell.agreeButton setTitle:NSLocalizedStringFromTable(@"確認",@"InfoPlist",nil) forState:UIControlStateNormal];
    [cell.rejectButton setTitle:NSLocalizedStringFromTable(@"刪除邀請",@"InfoPlist",nil) forState:UIControlStateNormal];
    cell.delegate=self;
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,dic[@"Avatar"]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
