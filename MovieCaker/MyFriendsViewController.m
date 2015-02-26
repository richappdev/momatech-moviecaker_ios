//
//  MyFriendsViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/1/7.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "MyViewController.h"
#import "MyFriendCell.h"

@interface MyFriendsViewController ()
    @property(nonatomic,strong) NSArray *friendArray;
    @property(nonatomic,strong) NSNumber *page;
    @property(assign,nonatomic) BOOL isLoading;
    @property(assign,nonatomic) BOOL isLast;
    @property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation MyFriendsViewController

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
    
    self.userInfo=[self.manager getLoginUnfo];
    NSNumber *userID=self.userInfo[@"UserId"];
    if (userID.intValue==self.friend.userId.intValue) {
        self.title=NSLocalizedStringFromTable(@"我的朋友列表",@"InfoPlist",nil);
    }else{
        self.title=[NSString stringWithFormat:@"%@的朋友列表",self.friend.nickName];
    }
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyFriendCell" bundle:nil] forCellReuseIdentifier:@"MyFriendCell"];
    
    self.page=[NSNumber numberWithInt:1];
    [self loadData:self.page];
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];  
}

-(void)loadData:(NSNumber *)page{
    self.isLoading=YES;
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"請稍後...",@"InfoPlist",nil) withTimeOut:30];
    
    [self.manager myFriendsWithUserID:self.friend.userId withPage:page callback:^(NSArray *friendArray, NSString *errorMsg, NSError *error) {
        
        self.isLoading=NO;
        [WaitingAlert dismiss];
        self.friendArray=friendArray;
        self.myTableView.tableFooterView=nil;
        [self.myTableView reloadData];
        if (self.friendArray.count<page.intValue*10) {
            self.isLast=YES;
        }
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 84;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"MyFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureMyFriendCell:(MyFriendCell *)cell atIndexPath:indexPath];
    return cell;
    
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendObj *friend=self.friendArray[indexPath.row];
    MyViewController *mvc=[[MyViewController alloc] initWithNibName:@"MyViewController" bundle:nil];
    mvc.friend=friend;
    [self.navigationController pushViewController:mvc animated:YES];

    
    
}

-(void) configureMyFriendCell:(MyFriendCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    FriendObj *friend=self.friendArray[indexPath.row];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,friend.avatar];
    cell.nickName.text=friend.nickName;
    cell.locationName.text=friend.locationName;
    cell.intro.text=friend.intro;
    
    if (friend.gender.boolValue) {
        [cell.genderIcon setImage:[UIImage imageNamed:@"我的朋友Icon男.png"]];
    }else{
       [cell.genderIcon setImage:[UIImage imageNamed:@"我的朋友Icon女.png"]]; 
    }
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];


}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isLoading) {
        return;
    }
    if (self.isLast) {
        return;
    }
    
    float pointY=scrollView.contentOffset.y;
    float startLoadY=scrollView.contentSize.height-self.view.frame.size.height;
    
    if (pointY>startLoadY) {
        self.page=@(self.page.intValue+1);
        self.myTableView.tableFooterView=self.footView;
        self.moreLabel.text=NSLocalizedStringFromTable(@"載入更多",@"InfoPlist",nil);
        [self loadData:self.page];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
