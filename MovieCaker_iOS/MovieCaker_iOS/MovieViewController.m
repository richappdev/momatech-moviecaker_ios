//
//  SecondViewController.m
//  MovieCaker_iOS
//
//  Created by Albert Hsu on 3/31/16.
//  Copyright © 2016 Albert Hsu. All rights reserved.
//

#import "MovieViewController.h"
#import "AustinApi.h"
#import "MovieTwoTableViewController.h"
#import "MovieDetailController.h"
#import "reviewController.h"

@interface MovieViewController ()
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UIView *lowerBar;
@property (strong, nonatomic) IBOutlet UILabel *secondLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;
@property (strong, nonatomic) IBOutlet UILabel *fourthLabel;
@property (strong, nonatomic) IBOutlet UIView *firstFilter;
@property (strong, nonatomic) IBOutlet UIView *secondFilter;
@property (strong, nonatomic) IBOutlet UIView *thirdFilter;
@property (strong, nonatomic) IBOutlet UIView *locationBtn;
@property (strong, nonatomic) IBOutlet UIView *locationFilter;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationConstrant;
@property UIView *currentFilter;
@property int filterIndex;
@property NSArray *labelArray;
@property NSArray *locationArray;
@property NSArray *locationBackend;
@property int locationIndex;
@property int index;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITableView *movieTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property MovieTwoTableViewController *movieTableController;
@property (strong, nonatomic) IBOutlet UILabel *oneOneL;
@property (strong, nonatomic) IBOutlet UILabel *oneTwoL;
@property (strong, nonatomic) IBOutlet UILabel *oneThreeL;
@property (strong, nonatomic) IBOutlet UILabel *twoOneL;
@property (strong, nonatomic) IBOutlet UILabel *twoTwoL;
@property (strong, nonatomic) IBOutlet UILabel *twoThreeL;
@property (strong, nonatomic) IBOutlet UILabel *threeOneL;
@property (strong, nonatomic) IBOutlet UILabel *threeTwoL;
@property (strong, nonatomic) IBOutlet UILabel *threeThreeL;

@property NSArray *tabOneData;
@property NSArray *tabTwoData;
@property NSArray *tabThreeData;
@property NSArray *tabFourData;

@property UILabel* fOneIndex;
@property UILabel* fTwoIndex;
@property UILabel* fFourIndex;

@property BOOL loaded;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    self.labelArray = [[NSArray alloc]initWithObjects:self.firstLabel,self.secondLabel,self.thirdLabel,self.fourthLabel, nil];
    
    for (UILabel *label in self.labelArray) {
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [label addGestureRecognizer:singleFingerTap];
    }
    self.index = 0;
    self.filterIndex = 0;
    self.currentFilter = self.firstFilter;
    
    self.locationBtn.clipsToBounds = YES;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(221.0f/255.0f) alpha:1].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(self.locationBtn.frame), CGRectGetHeight(self.locationBtn.frame)+2);
    
    [self.locationBtn.layer addSublayer:rightBorder];

    CALayer *top = [CALayer layer];
    top.borderColor = [UIColor colorWithRed:(221.0f/255.0f) green:(221.0f/255.0f) blue:(221.0f/255.0f) alpha:1].CGColor;
    top.borderWidth = 1;
    top.frame = CGRectMake(0,0, CGRectGetWidth(self.view.frame), 1.0f);
    
    
    self.locationFilter.clipsToBounds = YES;
    [self.locationFilter.layer addSublayer:top];
    
    UITapGestureRecognizer *showLocation =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLocation:)];
    
    [self.locationBtn addGestureRecognizer:showLocation];

    self.locationIndex = 0;
    [self createLocationIcons];
    
    self.movieTableController = [[MovieTwoTableViewController alloc] init];
    self.movieTableController.tableView = self.movieTable;
    self.movieTable.delegate =self.movieTableController;
    [self.movieTableController ParentController:self];
    
    self.view.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *cancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelLocation)];
    [cancel setCancelsTouchesInView:NO];
    [self.movieTable addGestureRecognizer:cancel];
    
    [self setupFilterBtns];
}
-(void)addLabelTap:(UILabel*)label{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClick:)];
    [label setUserInteractionEnabled:YES];
    [label addGestureRecognizer:tap];

}
-(void)setupFilterBtns{
    self.fOneIndex = self.oneOneL;
    self.fTwoIndex = self.twoOneL;
    self.fFourIndex = self.threeOneL;
    
    
    [self addLabelTap:self.oneOneL];
    [self addLabelTap:self.oneTwoL];
    [self addLabelTap:self.oneThreeL];
    
    [self addLabelTap:self.twoOneL];
    [self addLabelTap:self.twoTwoL];
    [self addLabelTap:self.twoThreeL];
    
    [self addLabelTap:self.threeOneL];
    [self addLabelTap:self.threeTwoL];
    [self addLabelTap:self.threeThreeL];

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    if(self.loaded) {
        [self doJump];}
}
-(void)doJump{
    if(self.jump==1){
        self.index =0;
        [self moveBar:self.firstLabel];
        [self setFilter];
    }
    if(self.jump==2){
        self.index =1;
        [self moveBar:self.secondLabel];
        [self setFilter];
    }
    if(self.jump==3){
        [self moveBar:self.fourthLabel];
        [self setFilter];
    }
    self.jump =0;
}
-(void)filterClick:(UIGestureRecognizer*)gesture{
    UILabel *previous;
    UILabel *current = (UILabel*)gesture.view;
    if(self.currentFilter.tag==0){
        previous = self.fOneIndex;
        if(previous!=current){
            if(current.tag==0){
                [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:0];
            }else if (current.tag==1){
                [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:self.locationIndex]objectForKey:@"Id"] type:1];
            }else if (current.tag==2){
                [self getMovieList:@"6" location:nil type:2];
            }
            
            self.fOneIndex = current;
        }
    }
    if (self.currentFilter.tag==1){
        previous = self.fTwoIndex;
        if(previous!=current){
            if(current.tag==0){
                [self getMovieList:@"month" location:nil type:3];
            }else if (current.tag==1){
                [self getMovieList:@"week" location:nil type:3];
            }else if (current.tag==2){
                [self getMovieList:@"year" location:nil type:3];
            }
        }
        self.fTwoIndex = current;
    }
    
    if (self.currentFilter.tag==2){
        previous = self.fFourIndex;
        if(previous!=current){
            if(current.tag==0){
                self.movieTableController.data = self.tabFourData;
            }else{
                NSMutableArray *data = [[NSMutableArray alloc]init];
                for (NSDictionary *row in self.tabFourData) {
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd'T'HH:mm:ss"];
                    NSString *test= [[row objectForKey:@"CreateOn"] substringWithRange:NSMakeRange(0,19)];
                    NSDate *dateFromString = [dateFormatter dateFromString:test];
                    if([self within7Days:dateFromString]&&current.tag==2)
                    {
                        [data addObject:row];
                    }
                    if(current.tag==1){
                        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateFromString];
                        NSInteger month = [components month];
                        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[[NSDate alloc]init]];
                        
                        if(month==[components month]){
                            [data addObject:row];
                        }}
                    
                }
                self.movieTableController.data =data;
                
                
            }
            [self.movieTableController.tableView reloadData];
        }
        self.fFourIndex = current;
    }
    
    previous.textColor = [UIColor blackColor];
    current.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0/255.0f) alpha:1];

}
-(BOOL)within7Days:(NSDate*)someDate{

    NSDate *currentDate = [NSDate date];
    NSDate *dateSevenDaysPrior = [currentDate dateByAddingTimeInterval:-(7 * 24 * 60 * 60)];

    if (([dateSevenDaysPrior compare:someDate] != NSOrderedDescending) &&
        ([someDate compare:currentDate] != NSOrderedDescending))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)createLocationIcons{
    
    
    [[AustinApi sharedInstance] locationList:^(NSArray *returnData) {
        self.locationBackend = returnData;
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        int count = 0;
        for (NSDictionary *row in returnData) {
            if(count==0){
                self.locationLabel.text = [row objectForKey:@"Name"];
                [self getMovieList:@"6" location:[row objectForKey:@"Id"] type:0];
            }
            UIView *view;
            if(self.view.frame.size.width>=375){
                view = [[UIView alloc]initWithFrame:CGRectMake(18+count*72, 30, 62, 28)];
            }else{
                if(count<4){
                view = [[UIView alloc]initWithFrame:CGRectMake(18+count*72, 20, 62, 28)];
                }else{
                view = [[UIView alloc]initWithFrame:CGRectMake(18, 52, 62, 28)];
                }
            }
            view.tag = count;
            view.layer.borderWidth = 1.0f;
            view.layer.borderColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1].CGColor;
            view.layer.cornerRadius = 4;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationBtnClick:)];
            [view addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 28)];
            label.font = [UIFont fontWithName:@"Heiti SC" size:15.0f];
            label.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
            label.text = [row objectForKey:@"Name"];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            [self.locationFilter addSubview:view];
            count++;
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:view,@"view",label,@"label", nil];
            [tempArray addObject:dict];
        }
        self.locationArray = tempArray;
        [self setLocationBtnColor:0];
        [self doJump];
        self.loaded=YES;
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];


}

-(void)getMovieList:(NSString*)type location:(NSString*)locationId type:(int)callType {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    NSString *monthString = [formatter stringFromDate:[NSDate date]];
    if(callType==1){
        int temp =[monthString intValue]+1;
        if(temp>12){
            temp=1;
        }
        monthString = [NSString stringWithFormat:@"%d",temp];
    }
    if(callType==2||callType==3){
        monthString =nil;
        yearString = nil;
    }

    [[AustinApi sharedInstance] movieListCustom:type location:locationId year:yearString month:monthString function:^(NSArray *returnData) {
        if(callType==3){
        self.tabTwoData = returnData;
        }
        else{
        self.tabOneData = returnData;
        }
        self.movieTableController.data = returnData;
        [self.movieTable reloadData];
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)setLocationBtnColor:(int)index{
    NSDictionary *temp = [self.locationArray objectAtIndex:self.locationIndex];
    UIView *view = [temp objectForKey:@"view"];
    UILabel *label = [temp objectForKey:@"label"];
    view.backgroundColor =[UIColor whiteColor];
    label.textColor = [UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
    
    temp = [self.locationArray objectAtIndex:index];
    view = [temp objectForKey:@"view"];
    label = [temp objectForKey:@"label"];
    view.backgroundColor =[UIColor colorWithRed:(244.0f/255.0f) green:(154.0f/255.0f) blue:(68.0f/255.0f) alpha:1];
    label.textColor = [UIColor whiteColor];
    self.locationIndex = index;
}
-(void)locationBtnClick:(UITapGestureRecognizer*)gestureRecongnizer{
    [self setLocationBtnColor:(int)gestureRecongnizer.view.tag];
    if(self.fOneIndex.tag!=2){
        [self getMovieList:@"6" location:[[self.locationBackend objectAtIndex:(int)gestureRecongnizer.view.tag] objectForKey:@"Id"] type:(int)self.fOneIndex.tag];}
    else{
        [self getMovieList:@"6" location:nil type:2];
    }
    [self confirmLocation:gestureRecongnizer];
}
-(void)confirmLocation:(UITapGestureRecognizer*)gestureRecongnizer{
    [self.view layoutIfNeeded];
    
    self.locationConstrant.constant = -150;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    NSDictionary *temp = [self.locationArray objectAtIndex:self.locationIndex];
    UILabel *label = [temp objectForKey:@"label"];
    self.locationLabel.text = label.text;
    self.locationLabel.tag = self.locationIndex;
    self.movieTable.alpha = 1;
}
-(void)cancelLocation{
    [self setLocationBtnColor:(int)self.locationLabel.tag];
    [self confirmLocation:nil];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.movieTable.delegate =self.movieTableController;
    });
}

-(void)showLocation:(UISwipeGestureRecognizer*)gestureRecongnizer{
    self.movieTable.delegate =nil;
    self.movieTable.alpha = 0.5;
    [self.view layoutIfNeeded];
    
    self.locationConstrant.constant = 0;
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
    
}

-(void)handleSingleTap:(UIGestureRecognizer*)gestureRecongnizer{
    self.index = (int)gestureRecongnizer.view.tag;
    [self moveBar:[self.labelArray objectAtIndex:gestureRecongnizer.view.tag]];
    [self setFilter];
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index>0){
        self.index--;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
    [self setFilter];
}
-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecongnizer{
    if(self.index<[self.labelArray count]-1){
        self.index++;
        [self moveBar:[self.labelArray objectAtIndex:self.index]];
    }
    [self setFilter];
}
-(void)setFilter{
    [self cancelLocation];
    if(self.index!=self.filterIndex){
        self.filterIndex = self.index;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        self.currentFilter.alpha = 0;
        self.topMargin.constant = 0;
        BOOL change = false;
        
        self.movieTableController.type = self.filterIndex;
        if(self.filterIndex ==0){
            if(self.tabOneData!=nil){
                self.movieTableController.data = self.tabOneData;
                [self.movieTableController.tableView reloadData];
            }
            self.currentFilter = self.firstFilter;
            change = true;
        }
        if(self.filterIndex==1){
            self.currentFilter = self.secondFilter;
            change = true;
            if(self.tabTwoData!=nil){
                self.movieTableController.data= self.tabTwoData;
                [self.movieTable reloadData];
            }else{
                [self getMovieList:@"month" location:nil type:3];}
        }
        if(self.filterIndex==2){
            if(self.tabThreeData!=nil){
           self.movieTableController.data =self.tabThreeData;
            [self.movieTableController.tableView reloadData];
            }else{
            [[AustinApi sharedInstance]movieListCustom:@"1" location:nil year:nil month:nil function:^(NSArray *returnData) {
                self.tabThreeData =returnData;
                self.movieTableController.data = returnData;
                [self.movieTableController.tableView reloadData];
            } error:^(NSError *error) {
                NSLog(@"%@",error);
            }];}
            self.topMargin.constant = -36;
        }
        if(self.filterIndex==3){
            self.currentFilter = self.thirdFilter;
            change = true;
            if(self.tabFourData!=nil){
                self.movieTableController.data =self.tabFourData;
                [self.movieTableController.tableView reloadData];
            }else{
            [[AustinApi sharedInstance]getReview:@"2" function:^(NSArray *returnData) {
                self.tabFourData =returnData;
                self.movieTableController.data = returnData;
                [self.movieTableController.tableView reloadData];
            } error:^(NSError *error) {
                NSLog(@"%@",error);
            }];}	
        }
        if(change){
            self.currentFilter.alpha = 1;}
        [UIView commitAnimations];
        
        }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moveBar:(UILabel*)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    self.lowerBar.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y+30, label.frame.size.width, 4);
    
    [UIView commitAnimations];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"a");
    if([[segue identifier] isEqualToString:@"movieDetail"]){
    MovieDetailController *vc = segue.destinationViewController;
    vc.movieDetailInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[[self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex] objectForKey:@"Id"],@"Id", nil];
        vc.loadLater = YES;}
    else if([[segue identifier] isEqualToString:@"reviewSegue"]){
        reviewController *vc = segue.destinationViewController;
         vc.data = [[NSMutableDictionary alloc]initWithDictionary:[self.movieTableController.data objectAtIndex:self.movieTableController.selectIndex]];
    }
}


@end
