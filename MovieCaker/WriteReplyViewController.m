//
//  WriteReplyViewController.m
//  MovieCaker
//
//  Created by iKevin on 2014/5/2.
//  Copyright (c) 2014年 iKevin. All rights reserved.
//

#import "WriteReplyViewController.h"

@interface WriteReplyViewController ()

@end

@implementation WriteReplyViewController

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
    
    if (self.talkObj) {
        self.title=self.talkObj.clubTopicName;
        self.talkHead.hidden=YES;
        self.myTextView.frame=CGRectMake(10, 8, 300, 135);
        [self.myTextView becomeFirstResponder];
    }else{
        self.title=NSLocalizedStringFromTable(@"新增話題",@"InfoPlist",nil);
        [self.talkHead becomeFirstResponder];
    }
    
    self.myTextView.contentInset=UIEdgeInsetsMake(0,12,0,0);

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];

    
    
    if([self isRunningiOS7]){
        [self.toolbar setBackgroundColor:[UIColor whiteColor]];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)close{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self subscribeForKeyboardEvents];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self unsubscribeFromKeyboardEvents];
    
    [super viewWillDisappear:animated];
}


#pragma mark - keyboard
- (void)subscribeForKeyboardEvents
{
    /* Listen for keyboard */
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardEvents
{
    /* No longer listen for keyboard */
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    int curve = [[info  objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect endFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSInteger top=self.view.frame.size.height-22;
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:curve
                     animations:^{self.toolbar.center=CGPointMake(160, top-endFrame.size.height);}
                     completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    int curve = [[info  objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSInteger top=self.view.frame.size.height-22;
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:curve
                     animations:^{self.toolbar.center=CGPointMake(160, top);}
                     completion:nil];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSString *str=self.myTextView.text;
    if ([str isEqualToString:NSLocalizedStringFromTable(@"話題介紹",@"InfoPlist",nil)] || [str isEqualToString:NSLocalizedStringFromTable(@"話題回應",@"InfoPlist",nil)] ) {
        self.myTextView.text=@"";
        self.myTextView.textColor=[UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    NSString *str=self.myTextView.text;
    if ([str isEqualToString:@""]) {
        if (self.talkObj) {
            self.myTextView.text=NSLocalizedStringFromTable(@"話題介紹",@"InfoPlist",nil);
        }else{
            self.myTextView.text=NSLocalizedStringFromTable(@"話題回應",@"InfoPlist",nil);
        }
        self.myTextView.textColor=[UIColor lightGrayColor];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButtonPressed:(id)sender {
    
    if (self.talkObj) {
        
        if ([self.myTextView.text isEqualToString:@""]) {
            [self alertShow:NSLocalizedStringFromTable(@"請輸入話題回應！",@"InfoPlist",nil)];
            return;
        }
        
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"資料送出中...",@"InfoPlist",nil) withTimeOut:30];
        [self.manager leaveMessageWithId:self.talkObj.talkId  withMessage:self.myTextView.text withReplyId:self.talkObj.clubId callback:^(NSDictionary *dict, NSString *errorMsg, NSError *error) {
            //
            [WaitingAlert dismiss];
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                [self.delegate refreshData];
            }
            [self close];
        }];
    }else{
        if ([self.myTextView.text isEqualToString:@""] || [self.myTextView.text isEqualToString:@"話題介紹"]) {
            [self alertShow:NSLocalizedStringFromTable(@"請輸入話題介紹！",@"InfoPlist",nil)];
            return;
        }
        if ( [self.talkHead.text isEqualToString:@""] ) {
            [self alertShow:NSLocalizedStringFromTable(@"請輸入話題標題！",@"InfoPlist",nil)];
            return;
        }
        
        NSLog(@"self.myTextView.text:%@",self.myTextView.text);
        
        [WaitingAlert presentWithText:NSLocalizedStringFromTable(@"資料送出中...",@"InfoPlist",nil) withTimeOut:30];
        [self.manager createTopicWithId:self.party.partyID withTopicName:self.talkHead.text withTopicDesc:self.myTextView.text callback:^(NSDictionary *JSON ,NSString *errorMsg, NSError *error) {
            [WaitingAlert dismiss];
            
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                [self.delegate refreshData];
            }
            
            [self close];
            
        }];
    }
 
    
}
@end
