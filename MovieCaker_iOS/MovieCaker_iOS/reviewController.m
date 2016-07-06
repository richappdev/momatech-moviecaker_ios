//
//  reviewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 6/23/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "reviewController.h"
#import "MainVerticalScroller.h"
#import "buttonHelper.h"
#import "UIImage+FontAwesome.h"
#import "buttonHelper.h"
#import "ReviewTableViewController.h"
#import "starView.h"
#import "AustinApi.h"
#import "UIImageView+WebCache.h"
#import "MovieDetailController.h"
#import "WXAPi.h"
#import "WechatAccess.h"

@interface reviewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIView *editBtn;
@property MainVerticalScroller *scrollHelp;
@property (strong, nonatomic) IBOutlet UIImageView *editPen;
@property (strong, nonatomic) IBOutlet UIImageView *penPic;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UIImageView *movieNavIcon;
@property (strong, nonatomic) IBOutlet UIView *movieNavBg;
@property (strong, nonatomic) IBOutlet UIView *likeBtn;
@property (strong, nonatomic) IBOutlet UIView *shareBtn;
@property (strong, nonatomic) IBOutlet UITableView *reviewTable;
@property (strong, nonatomic) IBOutlet UITextView *respondText;
@property ReviewTableViewController *tableController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *respondHeight;
@property (strong, nonatomic) IBOutlet starView *starView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *respondTextMargin;
@property (strong, nonatomic) IBOutlet UILabel *editBtnTxt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
@property int keyboardHeight;
@property (strong, nonatomic) IBOutlet UILabel *UserNickName;
@property (strong, nonatomic) IBOutlet UILabel *reviewTitle;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UIImageView *heart;
@property (strong, nonatomic) IBOutlet UILabel *modifiedDate;
@property (strong, nonatomic) IBOutlet UILabel *PageViews;
@property (strong, nonatomic) IBOutlet UILabel *like;
@property (strong, nonatomic) IBOutlet UILabel *share;
@property (strong, nonatomic) IBOutlet UIView *movieJump;
@property (strong, nonatomic) IBOutlet UILabel *movieJumpLabel;
@property (strong, nonatomic) IBOutlet UILabel *replyTop;
@property (strong, nonatomic) IBOutlet UIView *replyView;
@property (strong, nonatomic) IBOutlet UIView *respondBtn;
@end


@implementation reviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollHelp = [[MainVerticalScroller alloc]init];
    self.scrollHelp.nav = self.navigationController;
    [self.scrollHelp setupBackBtn:self];
    [self.scrollHelp setupStatusbar:self.view];
    
    self.mainScroll.delegate = self.scrollHelp;
    
    [buttonHelper gradientBg:self.bgImage width:self.view.frame.size.width];
    
    self.editBtn.layer.borderWidth=1;
    self.editBtn.layer.cornerRadius =3;
    self.editBtn.layer.borderColor = [UIColor colorWithRed:(128/255.0f) green:(203/255.0f) blue:(196/255.0f) alpha:1].CGColor;
    self.editPen.image = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(77/255.0f) green:(182/255.0f) blue:(172/255.0f) alpha:1.0] andSize:CGSizeMake(10, 10)];
    self.penPic.image = [UIImage imageWithIcon:@"fa-pencil" backgroundColor:[UIColor clearColor] iconColor:[UIColor colorWithRed:(121/255.0f) green:(124/255.0f) blue:(131/255.0f) alpha:1.0] andSize:CGSizeMake(12, 14)];
    
    self.movieNavIcon.image = [UIImage imageWithIcon:@"fa-chevron-left" backgroundColor:[UIColor clearColor] iconColor:[UIColor whiteColor] andSize:CGSizeMake(16, 16)];
    self.movieNavBg.layer.cornerRadius =8;
    self.movieNavBg.backgroundColor = [UIColor colorWithRed:(68/255.0f) green:(85/255.0f) blue:(102/255.0f) alpha:1.0];
    [self.content setEditable:NO];
    
    [self addIndexGesture:self.likeBtn];
    [self addIndexGesture:self.shareBtn];
    
    self.tableController = [[ReviewTableViewController alloc] init];
    self.tableviewHeight.constant = 5;
    self.tableController.tableViewHeight = self.tableviewHeight;
    self.reviewTable.delegate = self.tableController;
    self.reviewTable.dataSource = self.tableController;
    self.tableController.tableView = self.reviewTable;
    self.reviewTable.scrollEnabled = NO;
    
    [self.respondText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.respondText.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.respondText.layer.cornerRadius = 1;
    self.respondText.clipsToBounds = YES;
    self.respondText.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit:)];
    [self.editBtn addGestureRecognizer:tap2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    self.content.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;

    [self changeReal];
    if(self.sync){
        [self refreshMain];
        [[AustinApi sharedInstance]getReviewByrid:[self.data objectForKey:@"ReviewId"] function:^(NSDictionary *returndata) {
            self.data = [[NSMutableDictionary alloc]initWithDictionary:returndata];
            [self changeReal];
        } error:^(NSError *error2) {
            NSLog(@"%@",error2);
        }];
    }
    
    UITapGestureRecognizer *movieTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToMovieDetail)];
    [self.movieJump addGestureRecognizer:movieTap];
    
    self.replyTop.hidden = YES;
    self.reviewTable.hidden = YES;
    if(self.newReview){
        [self editMode];
        self.replyView.hidden = YES;
    }else{
        
        [self loadReplies];
    
    }
    UITapGestureRecognizer *respond = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respond)];
    [self.respondBtn addGestureRecognizer:respond];
}
-(void)loadReplies{
    [[AustinApi sharedInstance]reviewReplyTable:[self.data objectForKey:@"ReviewId"] function:^(NSArray *returnData) {
        if([returnData count]>0){
            self.tableController.data =returnData;
            self.replyTop.hidden = NO;
            self.reviewTable.hidden = NO;
            self.tableviewHeight.constant = 5;
            self.tableController.array = [[NSMutableArray alloc]init];
            [self.reviewTable reloadData];
            self.replyTop.text = [NSString stringWithFormat:@"共%d則回應",[returnData count]];
        }
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)respond{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
    [[AustinApi sharedInstance]reviewReply:[self.data objectForKey:@"ReviewId"] message:self.respondText.text function:^(NSString *returnData) {
        NSLog(@"%@",returnData);
        [self loadReplies];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [self.respondText resignFirstResponder];
        self.respondText.text =@"";}
}
-(void)changeReal{
    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.data objectForKey:@"VideoPosterUrl"]]] placeholderImage:[UIImage imageNamed:@"img-placeholder.jpg"]];
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Uploads/UserAvatar/%@",[[AustinApi sharedInstance] getBaseUrl],[self.data objectForKey:@"UserAvatar"]]]];
    self.title = self.UserNickName.text = [self.data objectForKey:@"UserNickName"];
    self.reviewTitle.text = [NSString stringWithFormat:@"%@ 的影評", [self.data objectForKey:@"VideoName"]];
    [self.starView setStars:[[self.data objectForKey:@"OwnerLinkVideo_Score"] integerValue]];
    
    if([[self.data objectForKey:@"OwnerLinkVideo_IsLiked"]intValue]==0){
        self.heart.image = [UIImage imageNamed:@"iconHeartList.png"];
    }else{
        self.heart.image = [UIImage imageNamed:@"iconHeartListLiked.png"];
    }
    
    self.modifiedDate.text = [[self.data objectForKey:@"ModifiedOn"] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.modifiedDate.text = [self.modifiedDate.text substringWithRange:NSMakeRange(0,[self.modifiedDate.text rangeOfString:@"T"].location)];
    self.PageViews.text = [[self.data objectForKey:@"PageViews"]stringValue];
    self.content.text = [self.data objectForKey:@"Review"];
    self.like.text = [NSString stringWithFormat:@"喜歡   %@",[[self.data objectForKey:@"LikedNum"]stringValue]];
    self.share.text = [NSString stringWithFormat:@"分享   %@",[[self.data objectForKey:@"SharedNum"]stringValue]];
    
    NSDictionary *returnData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]];
    if(!self.newReview){
    if(returnData == nil){
        self.editBtn.hidden = YES;
    }else if (![[[[returnData objectForKey:@"Data"] objectForKey:@"UserId"]stringValue]isEqualToString:[[self.data objectForKey:@"UserId"] stringValue]]){
        self.editBtn.hidden = YES;
    }
        
    }
    self.movieJumpLabel.text = [NSString stringWithFormat:@"電影 - %@",[self.data objectForKey:@"VideoName"]];
    if([[self.data objectForKey:@"IsLiked"]boolValue]){
        self.likeBtn.tag = 2;
    }else{
        self.likeBtn.tag = 0;
    }
    [buttonHelper adjustLike:self.likeBtn];
    
    if([[self.data objectForKey:@"IsShared"]boolValue]){
        self.shareBtn.tag = 3;
    }else{
        self.shareBtn.tag = 1;
    }
    [buttonHelper adjustShare:self.shareBtn];
    if([buttonHelper isLabelTruncated:(UILabel*)self.content]==NO){
        self.moreBtn.hidden = YES;
    }
    
}
-(void)jumpToMovieDetail{
    [self performSegueWithIdentifier:@"movieDetail" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MovieDetailController *vc = segue.destinationViewController;
    vc.movieDetailInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[self.data objectForKey:@"VideoId"],@"Id", nil];
    vc.loadLater = YES;
}
-(IBAction)readMore:(id)sender{
    [self more];
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.keyboardHeight = MIN(keyboardSize.height,keyboardSize.width);
}
-(void)editMode{
    self.editBtnTxt.text = @"確認";
    self.starView.edit = YES;
    [self.content setEditable:YES];
    [self.content setScrollEnabled:YES];
}
-(void)edit:(UITapGestureRecognizer*)gesture{
    if(self.starView.edit!=YES){
        [self editMode];
    }else{
        self.replyView.hidden = NO;
        self.editBtnTxt.text = @"編輯";
        self.starView.edit = NO;
        [self.content setEditable:NO];
        [self.content setScrollEnabled:NO];
        [[AustinApi sharedInstance]reviewChange:[self.data objectForKey:@"ReviewId"] videoId:[self.data objectForKey:@"VideoId"]  score:[NSString stringWithFormat:@"%d",self.starView.rating] review:self.content.text function:^(NSDictionary *returnData) {
            [self.data setObject:[[returnData objectForKey:@"ReviewId"] stringValue] forKey:@"ReviewId"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy/MM/dd"];
            self.modifiedDate.text = [formatter stringFromDate:[NSDate date]];
            NSLog(@"%@",returnData);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        [self refreshMain];
    }

    [self more];
}

-(void)more{
    self.moreBtn.hidden = YES;
    [self.content sizeToFit];
    if(self.content.frame.size.height<90){
        self.contentHeight.constant = 90;
    }else{
        self.contentHeight.constant = self.content.frame.size.height;
    }
    
    [self performSelector:@selector(resizeScroll) withObject:self afterDelay:0.5];
}
-(void)tap:(UITapGestureRecognizer*)gesture{
    [self.content resignFirstResponder];
    [self.respondText resignFirstResponder];
}
- (void)textViewDidChange:(UITextView *)textView
{
    float rows = (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font.lineHeight;
    if(rows>=2){
        self.respondHeight.constant = 70;
    }else{
        self.respondHeight.constant = 40;
    }

}
-(void)resizeScroll{
    self.mainScroll.contentSize = CGSizeMake(self.view.frame.size.width,430+self.contentHeight.constant+self.tableviewHeight.constant);
}
-(void)viewWillLayoutSubviews{
    [self resizeScroll];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.respondTextMargin.constant = self.keyboardHeight;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.respondTextMargin.constant = 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addIndexGesture:(UIView*)view{
    UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexClick:)];
    [view addGestureRecognizer:indexTap];
}

-(void)indexClick:(UITapGestureRecognizer *)sender{
    if([[[self.data objectForKey:@"ReviewId"]stringValue]isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"還未建立影評" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"]==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"请登入" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil,nil];
        [alert show];
    }else{
        [self refreshMain];
        NSString *act;
        if(sender.view.tag==0||sender.view.tag==2){
            act =@"1";
        }else{
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = [self.data objectForKey:@"VideoName"];
            
            NSString *str;
            if (self.content.text.length>140) {
                str=[self.content.text substringToIndex:140];
            }else{
                str=self.content.text;
            }
            
            message.description=str;
            
            [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=88",[self.data objectForKey:@"VideoPicture"]]]]]];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl =  [NSString stringWithFormat:@"%@/video/%@",[[AustinApi sharedInstance] getBaseUrl],[self.data objectForKey:@"VideoId"]];
            NSLog(@"%@",ext.webpageUrl);
            message.mediaObject = ext;
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            [WXApi sendReq:req];
            NSLog(@"%@",message.title);
            act =@"3";
        }
        [[AustinApi sharedInstance]socialAction:[self.data objectForKey:@"ReviewId"] act:act obj:@"2" function:^(NSString *returnData) {
            if([act isEqualToString:@"1"]){
                int temp = [[self.data objectForKey:@"LikedNum"]integerValue];
                if([returnData isEqualToString:@"1"]){
                    temp++;
                }else{
                    temp--;
                }
                [self.data setValue:[NSString stringWithFormat:@"%d",temp] forKey:@"LikedNum"];
            self.like.text = [NSString stringWithFormat:@"喜歡   %d",temp];

            }
            
            if([act isEqualToString:@"3"]){
                if([returnData isEqualToString:@"1"]){
                    int temp = [[self.data objectForKey:@"LikedNum"]integerValue];
                    temp++;
                    self.share.text = [NSString stringWithFormat:@"分享   %d",temp];
                }
                
                
            }
            
            
            NSLog(@"%@",returnData);
        } error:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        [buttonHelper likeShareClick:sender.view];}
    }
}
-(void)refreshMain{
    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:0];
    MovieController *movie = [[nav viewControllers]objectAtIndex:0];
    movie.refresh = YES;
}
-(void)viewWillAppear:(BOOL)animated{
self.navigationController.navigationBarHidden = NO;
}
@end
