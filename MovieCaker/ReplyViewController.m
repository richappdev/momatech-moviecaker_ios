//
//  ReplyViewController.m
//  MovieCaker
//
//  Created by iKevin on 2013/11/23.
//  Copyright (c) 2013年 iKevin. All rights reserved.
//

#import "ReplyViewController.h"
#import "UIImageView+WebCache.h"
#import "TopicReplyCell.h"
#import "TopicReply.h"

@interface ReplyViewController ()
    @property (nonatomic, strong) NSArray *replyArray;
@end

@implementation ReplyViewController

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
    
    self.title=NSLocalizedStringFromTable(@"專題回應",@"InfoPlist",nil);
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 32, 32);
    left.showsTouchWhenHighlighted = YES;
    [left addTarget:self
             action:@selector(back:)
   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"TopicReplyCell" bundle:nil] forCellReuseIdentifier:@"TopicReplyCell"];
    self.replyArray=[self.manager getTopicReplyWithTopicID:self.topic.topicID];
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    TopicReply *reply=self.replyArray[indexPath.row];
    float replyHeight=[self getContentHeight:reply.message width:264 fontSize:13];
    if (replyHeight==0) {
        return 0;
    }else if(replyHeight<16){
        return 44;
    }else{
        return replyHeight+29;
    }

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TopicReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicReplyCell"];
    [self configureTopicReplyCell:(TopicReplyCell *)cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)configureTopicReplyCell:(TopicReplyCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TopicReply *reply=self.replyArray[indexPath.row];
    self.df.dateFormat = @"yyyy-MM-dd";
    cell.nickName.text=[NSString stringWithFormat:@"%@ %@ %@",reply.nickName,NSLocalizedStringFromTable(@"寫於",@"InfoPlist",nil),[self.df stringFromDate:reply.createdOn]];
    float replyHeight=[self getContentHeight:reply.message width:264 fontSize:13];
    cell.message.frame=CGRectMake(46, 22, 264, replyHeight+5);
    cell.message.text=reply.message;
    [cell.avatarView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",PROPUCTION_API_DOMAIN,reply.avatar]]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
