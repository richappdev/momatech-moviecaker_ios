//
//  LineUpViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/2/12.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "LineUpViewController.h"
#import "TopicDetailViewController.h"
#import "JoinTopicViewController.h"


@interface LineUpViewController ()
    @property (nonatomic, strong) NSNumber *lineUpHeight;
    @property(strong,nonatomic) UIFont *font;
@end

@implementation LineUpViewController

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
    
    //演員陣容
    if (!self.actorArray) {
        self.actorArray=[self.manager getActorWithVideoId:self.video.videoID];
    }
    
    self.font=[UIFont systemFontOfSize:14];
    self.lineUpHeight=[self calculateCellHeight:self.actorArray];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MovieListCell" bundle:nil] forCellReuseIdentifier:@"MovieListCell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"LineUpCell" bundle:nil] forCellReuseIdentifier:@"LineUpCell"];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//計算cell 的高度
-(NSNumber *)calculateCellHeight:(NSArray *)itemArray{
    
    int row=0;
    
    NSMutableArray *buttonFrames=[[NSMutableArray alloc] init];
    
    for (int i=0; i<itemArray.count; i++) {
        Actor *actor=(Actor *)[itemArray objectAtIndex:i];
        NSString *tagWord;
        if ([self.lang isEqualToString:@"zh-Hant"]) {
            tagWord=actor.name;
        }else{
            tagWord=actor.cnName;
        }
        CGSize stringsize = [tagWord sizeWithFont:self.font];
        CGRect buttonFrame=CGRectZero;
        
        if (buttonFrames.count>0) {
            
            NSString *buttonFrameString=[buttonFrames lastObject];
            CGRect preButtonFrame=CGRectFromString(buttonFrameString);
            
            buttonFrame=CGRectMake(preButtonFrame.origin.x+preButtonFrame.size.width+10,preButtonFrame.origin.y,stringsize.width+25, stringsize.height+10);
            
            float rightMargin=buttonFrame.origin.x+buttonFrame.size.width;
            
            if (rightMargin>310) {
                row+=1;
                buttonFrame=CGRectMake(10,40+row*40,stringsize.width+10, stringsize.height+10);
            }
            
        }else{
            buttonFrame=CGRectMake(10,40,stringsize.width+10, stringsize.height+10);
        }
        
        [buttonFrames insertObject:NSStringFromCGRect(buttonFrame) atIndex:i];
    }
    return [NSNumber numberWithFloat:100+row*40];
}
#pragma mark - MovieCellDelegate

- (void)joinTopic:(VideoObj *)video{
    JoinTopicViewController *jtvc=[[JoinTopicViewController alloc] initWithNibName:@"JoinTopicViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:jtvc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 220;
    }else{
        return self.lineUpHeight.intValue;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell"];
        [self configureMovieListCell:(MovieListCell *)cell atIndexPath:indexPath];
        return cell;
    }

     if(indexPath.row == 1)
     {
     LineUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LineUpCell"];
     [self configureLineUpCell:(LineUpCell *)cell atIndexPath:indexPath];
     return cell;
     }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)configureMovieListCell:(MovieListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *path=[NSString stringWithFormat:@"http://www.funmovie.tv/Content/pictures/files/%@?width=156",self.video.picture];
    
    [cell.videoImageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"noMoviePoster.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    cell.delegate=self;
    cell.video=self.video;
    
    if ([self.lang isEqualToString:@"zh-Hant"]) {
        cell.name.text=self.video.name;
    }else{
        cell.name.text=self.video.cnName;
    }
    cell.enName.text=self.video.enName;
    
    [cell updateVideoInfo];
    
    if (![self.manager isLogined]) {
        cell.likeButton.backgroundColor=[UIColor lightGrayColor];
        cell.seenButton.backgroundColor=[UIColor lightGrayColor];
        cell.watchButton.backgroundColor=[UIColor lightGrayColor];
        //cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
       // cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        //cell.addTopicButton.backgroundColor=[UIColor lightGrayColor];
    }else{
        
        NSComparisonResult result=[[NSDate date] compare:[self stringToDate:self.video.releaseDate]];
        
        
        if (result==NSOrderedAscending) {
            cell.seenButton.backgroundColor=[UIColor lightGrayColor];
            //cell.gradeButton.backgroundColor=[UIColor lightGrayColor];
           // cell.reviewButton.backgroundColor=[UIColor lightGrayColor];
        }else{
            if (self.video.isViewed.boolValue) {
                cell.seenButton.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:204.0/255.0 alpha:1.0];
                cell.seenButton.selected=YES;
                
            }else{
                cell.seenButton.backgroundColor=[UIColor grayColor];
                cell.seenButton.selected=NO;
            }
        }
        
        if (self.video.isLiked.boolValue) {
            cell.likeButton.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
            cell.likeButton.selected=YES;
            
        }else{
            cell.likeButton.backgroundColor=[UIColor grayColor];
            cell.likeButton.selected=NO;
        }
        
        
        if (self.video.isWantView.boolValue) {
            cell.watchButton.backgroundColor=[UIColor colorWithRed:254.0/255.0 green:195.0/255.0 blue:77.0/255.0 alpha:1.0];
            cell.watchButton.selected=YES;
            
        }else{
            cell.watchButton.backgroundColor=[UIColor grayColor];
            cell.watchButton.selected=NO;
        }
        
        
    }
}

- (void)configureLineUpCell:(LineUpCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=cell.indexPath.row) {
        cell.lineUp.text=NSLocalizedStringFromTable(@"導演及演員",@"InfoPlist",nil);
        self.lineUpHeight=[cell lineSet:self.actorArray];
        cell.indexPath=indexPath;
        cell.delegate=self;
    }
    
    
}

- (void)clickActor:(NSNumber *)actorId withActorName:(NSString *)actorName{
    
    TopicDetailViewController *topicDetailVC=[[TopicDetailViewController alloc] initWithNibName:@"TopicDetailViewController" bundle:nil];
    topicDetailVC.actorId=actorId;
    topicDetailVC.channel=@"Actor";
    topicDetailVC.actorName=actorName;
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
    
    NSLog(@"actorId:%d",actorId.intValue);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
