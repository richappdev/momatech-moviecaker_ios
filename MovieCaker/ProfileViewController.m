//
//  ProfileViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/3/10.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyHeaderCell.h"

@interface ProfileViewController ()
    @property(nonatomic,strong) NSString *genderStr;
@end

@implementation ProfileViewController

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
    [self setupDefaultNavBarButtons];
    self.title=NSLocalizedStringFromTable(@"個人資料設置",@"InfoPlist",nil);
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHeaderCell" bundle:nil] forCellReuseIdentifier:@"MyHeaderCell"];
    
    
    UIView *leftView=[[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 34)];
    self.nickNameFiled.leftView=leftView;
    self.nickNameFiled.leftViewMode= UITextFieldViewModeAlways;
    
    if ([self isRunningiOS7]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.manager userProfile:self.friend.userId callback:^(FriendObj *friend, NSString *errorMsg, NSError *error) {
        self.friend=friend;
        self.nickNameFiled.text=self.friend.nickName;
        if (self.friend.gender.boolValue) {
            self.genderStr=@"true";
            self.segmentedControl.selectedSegmentIndex=0;
        }else{
            self.genderStr=@"false";
            self.segmentedControl.selectedSegmentIndex=1;
        }
        self.brithday.text=[self.friend.brithDay substringToIndex:10];
        [self.myTableView reloadData];
        
    }];
    [self showDatePicker:NO];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view from its nib.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSLog(@"keyboardWillBeShown");
    [self showDatePicker:NO];
    //[self.scollView setContentOffset:CGPointMake(0.0,60) animated:YES];
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"keyboardWillBeHidden");
    //[self.scollView setContentOffset:CGPointMake(0.0,0.0) animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"MyHeaderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
}

-(void) configureMyHeaderCell:(MyHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //if ([self.manager isLogined]) {
    NSString *gender =(self.friend.gender.boolValue)? @"男":@"女";
    
    cell.inviteView.hidden=YES;
    cell.addFriendButton.hidden=YES;
    
    cell.userName.text=[NSString stringWithFormat:@" %@ %@ %@",self.friend.nickName,self.friend.locationName,gender];
    NSString *path=[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,self.friend.avatar];
    
    NSURL *bannerUrl=[self getUesrBannerUrl:self.friend.userId];
    
    [cell.userBanner setImageWithURL:bannerUrl placeholderImage:nil];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"nobody.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didChangeSegmentControl:(id)sender {
    [self.nickNameFiled resignFirstResponder];
    [self showDatePicker:NO];
    if (self.segmentedControl.selectedSegmentIndex==0) {
        self.genderStr=@"true";
    }else{
        self.genderStr=@"false";
    }
    
}
- (IBAction)valueChanged:(id)sender {    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.brithday.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
}
- (IBAction)tapGesture:(id)sender {
    [self.nickNameFiled resignFirstResponder];
     [self showDatePicker:NO];
}
- (IBAction)brithButtonPressed:(id)sender {
    [self.nickNameFiled resignFirstResponder];
    [self showDatePicker:YES];
    self.datePicker.date=[self stringToDate:self.brithday.text];
}

-(void)showDatePicker:(BOOL)showed{
    if (showed) {
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.datePicker.frame=CGRectMake(0, 318, 320, 162);
                         }];
    }else{
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.datePicker.frame=CGRectMake(0, 568, 320, 162);
                         }];
    }

}
- (IBAction)sendButtonPressed:(id)sender {
    

    
    NSString *nickName=self.nickNameFiled.text;
    nickName=[nickName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (nickName.length==0) {
        [self alertShow:NSLocalizedStringFromTable(@"暱稱不可空白！",@"InfoPlist",nil)];
        
        return;
    }
    
    [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"資料已送出",@"InfoPlist",nil) withTimeOut:2];
    
    NSDictionary *dic=@{@"UserId":self.friend.userId.stringValue,@"NickName":self.nickNameFiled.text,@"Gender":self.genderStr,@"BrithDay":self.brithday.text};
    [self.manager saveUserProfile:dic callback:^(NSDictionary *loginInfo, NSString *errorMsg, NSError *error) {
        
        self.friend.gender=[self.genderStr isEqualToString:@"true"]? @(1): @(0);
        self.friend.nickName=self.nickNameFiled.text;
        NSDictionary *dic=[self checkLoginInfo:loginInfo];
        [self.manager saveLoginInfo:dic];
        [self.myTableView reloadData];
    }];

}
@end
