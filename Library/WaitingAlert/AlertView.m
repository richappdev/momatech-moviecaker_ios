//
//  UIPopupView.m
//  CustomAlertViewDemo
//
//  Created by Joey Chung on 12/12/18.
//  Copyright (c) 2012年 Joey Chung. All rights reserved.
//

#import "AlertView.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat BACKGROUND_ALPHA  = 0.8f;
const CGFloat CORNER_RADIUS     = 9.0f;


#ifdef DEFAULT_STYLE
/*
@implementation AlertView

+ (void)changeButtonStyleToTransparent:(UIButton *)button
{
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    button.layer.cornerRadius = CORNER_RADIUS;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor grayColor].CGColor;    
}

+ (void)activityIndicatorWithTitle: (NSString *) title withDelegate:(id) delegate
{
    if(waitingAlert)
    {
        waitingAlert.titleLabel.text = title;
        waitingAlert.delegate = delegate;
        [waitingAlert show];
    }
    else
    {
        waitingAlert = [[UIActivityIndicatorPopupView alloc] initWithFrame:CGRectMake(0, 0, 260, 110)];
    
        waitingAlert.backgroundColor = [UIColor colorWithWhite:0.0f alpha:BACKGROUND_ALPHA];
        waitingAlert.layer.cornerRadius = CORNER_RADIUS;
    
        waitingAlert.titleLabel.text = title;
        waitingAlert.titleLabel.textAlignment = UITextAlignmentCenter;
        waitingAlert.titleLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        waitingAlert.titleLabel.textColor = [UIColor whiteColor];
        waitingAlert.titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(waitingAlert.frame), floorf(CGRectGetHeight(waitingAlert.frame) / 2.0f));

        CGRect activityFrame = waitingAlert.activityIndicatorView.frame;
        activityFrame.origin = CGPointMake(floorf((CGRectGetWidth(waitingAlert.frame) - CGRectGetWidth(activityFrame)) / 2.0f), floorf(CGRectGetHeight(waitingAlert.frame) / 2.0f));
        waitingAlert.activityIndicatorView.frame = activityFrame;
        
        waitingAlert.delegate = delegate;
        
        [waitingAlert show];
    }
}

+ (void)textInputWithTitle: (NSString *) title withDelegate:(id) delegate
{
    if(textInputAlert)
    {
        textInputAlert.titleLabel.text = title;
        textInputAlert.delegate = delegate;
        [textInputAlert show];
    }
    else
    {
        textInputAlert = [[UITextInputPopupView alloc] initWithFrame:CGRectMake(0, 0, 260, 260)];
    
        textInputAlert.backgroundColor = [UIColor colorWithWhite:0.0f alpha:BACKGROUND_ALPHA];
        textInputAlert.layer.cornerRadius = CORNER_RADIUS;   
    
        textInputAlert.titleLabel.text = title;
        textInputAlert.titleLabel.textAlignment = UITextAlignmentCenter;
        textInputAlert.titleLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        textInputAlert.titleLabel.textColor = [UIColor whiteColor];
        textInputAlert.titleLabel.frame = CGRectMake(0, 0, 260, 45);
        
        textInputAlert.textView.frame = CGRectMake(5, 45, 250, 150);
        textInputAlert.textView.layer.cornerRadius = CORNER_RADIUS;
        textInputAlert.textView.font = [UIFont fontWithName:textInputAlert.textView.font.fontName size:17];
    
        textInputAlert.cancelButton.frame = CGRectMake( 5, 205, 120, 45);
        [textInputAlert.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        [self changeButtonStyleToTransparent:textInputAlert.cancelButton];
    
        [textInputAlert.okButton setTitle:@"OK" forState:UIControlStateNormal];
        textInputAlert.okButton.frame = CGRectMake( 5+120+10, 205, 120, 45);
        textInputAlert.okButton.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        [self changeButtonStyleToTransparent:textInputAlert.okButton];
        
        textInputAlert.delegate = delegate;
        
        [textInputAlert show];
    }
}

+ (void) textDisplayWithBody: (NSString *)body withDelegate:(id) delegate
{
    if(textDisplayAlert)
    {
        textDisplayAlert.titleLabel.text = body;
        textDisplayAlert.delegate = delegate;
        [textDisplayAlert show];
    }
    else
    {
        textDisplayAlert = [[UITextDisplayPopupView alloc]initWithFrame:CGRectMake(0, 0, 260, 280)];
        
        textDisplayAlert.backgroundColor = [UIColor colorWithWhite:0.0f alpha:BACKGROUND_ALPHA];
        textDisplayAlert.layer.cornerRadius = CORNER_RADIUS;

        textDisplayAlert.titleLabel.text = body;
        textDisplayAlert.titleLabel.textAlignment = UITextAlignmentCenter;
        textDisplayAlert.titleLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        textDisplayAlert.titleLabel.textColor = [UIColor whiteColor];
        textDisplayAlert.titleLabel.frame = CGRectMake(0, 5, 260, 30);
        textDisplayAlert.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
    
        textDisplayAlert.textView.frame = CGRectMake(5, 30, 250, 175);    
        textDisplayAlert.textView.layer.cornerRadius = CORNER_RADIUS;
        textDisplayAlert.textView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        textDisplayAlert.textView.textColor =  [UIColor whiteColor];
        textDisplayAlert.textView.font = [UIFont fontWithName:textDisplayAlert.textView.font.fontName size:17];
    
        textDisplayAlert.cancelButton.frame = CGRectMake( 5, 225, 250, 45);
        [textDisplayAlert.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
        [self changeButtonStyleToTransparent:textDisplayAlert.cancelButton];
        
        textDisplayAlert.delegate = delegate;
        
        [textDisplayAlert show];
    }
}

+ (void) textDisplayWithTitle: (NSString *)title message:(NSString *) message withDelegate:(id) delegate;
{
    if(textDisplayAlertWithTitle)
    {
        textDisplayAlertWithTitle.titleLabel.text = title;
        textDisplayAlertWithTitle.textView.text = message;
        textDisplayAlertWithTitle.delegate = delegate;
        [textDisplayAlertWithTitle show];
        return;
    }
    
    if(title)
    {
        // Background
        textDisplayAlertWithTitle = [[UITextDisplayPopupView alloc]initWithFrame:CGRectMake(0, 0, 260, 5+40+60+5+45)];
        
        textDisplayAlertWithTitle.backgroundColor = [UIColor colorWithWhite:0.0f alpha:BACKGROUND_ALPHA];
        textDisplayAlertWithTitle.layer.cornerRadius = CORNER_RADIUS;
        
        // Title label
        textDisplayAlertWithTitle.titleLabel.text = title;
        textDisplayAlertWithTitle.titleLabel.textAlignment = UITextAlignmentCenter;
        textDisplayAlertWithTitle.titleLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        textDisplayAlertWithTitle.titleLabel.textColor = [UIColor whiteColor];
        textDisplayAlertWithTitle.titleLabel.frame = CGRectMake(0, 5, 260, 30);
        textDisplayAlertWithTitle.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        
        
        // Textview
        textDisplayAlertWithTitle.textView.text = message;
        textDisplayAlertWithTitle.textView.frame = CGRectMake(5, 5+30, 250, 60);
        textDisplayAlertWithTitle.textView.layer.cornerRadius = CORNER_RADIUS;
        textDisplayAlertWithTitle.textView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        textDisplayAlertWithTitle.textView.textColor =  [UIColor whiteColor];
        textDisplayAlertWithTitle.textView.font = [UIFont fontWithName:textDisplayAlertWithTitle.textView.font.fontName size:18];
        textDisplayAlertWithTitle.textView.textAlignment = UITextAlignmentCenter;
        
        
        // Button
        textDisplayAlertWithTitle.cancelButton.frame = CGRectMake( 5, 5+30+60+5, 250, 45);
        [textDisplayAlertWithTitle.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
        [self changeButtonStyleToTransparent:textDisplayAlertWithTitle.cancelButton];
        
        textDisplayAlertWithTitle.delegate = delegate;
    }
    else{
        
        // Background
        textDisplayAlertWithTitle = [[UITextDisplayPopupView alloc]initWithFrame:CGRectMake(0, 0, 260, 5+80+5+45+5)];
        
        textDisplayAlertWithTitle.backgroundColor = [UIColor colorWithWhite:0.0f alpha:BACKGROUND_ALPHA];
        textDisplayAlertWithTitle.layer.cornerRadius = CORNER_RADIUS;
        
        // Textview
        textDisplayAlertWithTitle.textView.text = message;
        textDisplayAlertWithTitle.textView.frame = CGRectMake(5, 5, 250, 80);
        textDisplayAlertWithTitle.textView.layer.cornerRadius = CORNER_RADIUS;
        textDisplayAlertWithTitle.textView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        textDisplayAlertWithTitle.textView.textColor =  [UIColor whiteColor];
        textDisplayAlertWithTitle.textView.font = [UIFont fontWithName:textDisplayAlertWithTitle.textView.font.fontName size:14];
        //popupView.textView.textAlignment = UITextAlignmentCenter;
        
        
        // Button
        textDisplayAlertWithTitle.cancelButton.frame = CGRectMake( 5, 5+80+5, 250, 45);
        [textDisplayAlertWithTitle.cancelButton setTitle:@"OK" forState:UIControlStateNormal];
        [self changeButtonStyleToTransparent:textDisplayAlertWithTitle.cancelButton];
        
         textDisplayAlertWithTitle.delegate = delegate;
    }
    
    [textDisplayAlertWithTitle show];
}

+ (void) dismiss
{
    if(waitingAlert)
    {
        [waitingAlert hide];
        waitingAlert = nil;
    }
}

+ (void) textInputDismiss
{
    if(textInputAlert)
    {
        [textInputAlert hide];
        textInputAlert = nil;
    }
}

@end
*/

#else

@implementation AlertView
@synthesize alertView;
@synthesize progressView;

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super init];
    
    if (self)
    {
        alertView = [[UIActivityIndicatorPopupView alloc] initWithFrame:CGRectMake(0, 0, 260, 110)];
        
        alertView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:BACKGROUND_ALPHA];
        alertView.layer.cornerRadius = CORNER_RADIUS;
        
        alertView.titleLabel.text = title;
        alertView.titleLabel.textAlignment = NSTextAlignmentCenter;
        alertView.titleLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        alertView.titleLabel.textColor = [UIColor whiteColor];
        alertView.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        alertView.titleLabel.frame = CGRectMake(0, 20, CGRectGetWidth(alertView.frame), floorf(CGRectGetHeight(alertView.frame) / 3.0f));
        
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [progressView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        
        CGRect alertViewFrame = [alertView frame];
        CGRect progressViewFrame = [progressView frame];
        
        [progressView setFrame:CGRectMake(22, CGRectGetMaxY(alertViewFrame) - (progressViewFrame.size.height) - 20, CGRectGetWidth(alertView.frame) -40, progressViewFrame.size.height)];
        [alertView addSubview:progressView];
        
    }
    
    return self;
}

- (void)show
{
    [self.alertView show];
}

- (void)dismiss:(BOOL)animated
{    
    if(self.alertView)
    {
        [self.alertView hide];
        self.alertView = nil;
    }
}


#pragma mark - Progress

- (float)progress {
    
    return [self.progressView progress];
}

- (void)setProgress:(float)progress {
    
    [self.progressView setProgress:progress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.progressView setProgress:progress animated:animated];
    });
}

@end

#endif

@interface UIPopupView()
{
@protected  NSMutableArray *_arrayButtons;
}
@property(nonatomic, strong) UIWindow *window;
@end

@implementation UIPopupView
@synthesize window;

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){        
        _arrayButtons = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void) buttonTouchUpInside:(id)sender
{
    NSUInteger clickedNo = [_arrayButtons indexOfObject:sender];
    
    [_delegate popupView:self clickedButtonAtIndex:clickedNo];
    
    switch (clickedNo) {
        case 0: // Cancel
        case 1: // OK
            [_delegate popupView:self willDismissWithButtonIndex:clickedNo];
            [self hide];
            [_delegate popupView:self didDismissWithButtonIndex:clickedNo];
            break;
        case 2:
            [self hide];
            break;
            
        default:
            break;
    }
}

- (void) show {
	[self showAnimated:YES];
}

- (void) showAnimated:(BOOL)animated {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
	
	self.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
	
	[self.window addSubview:self];
	[self.window makeKeyAndVisible];
	
    [self.delegate willPresentPopupView:self];
    
	if (animated) {
		self.window.transform = CGAffineTransformMakeScale(1.5, 1.5);
		self.window.alpha = 0.0f;
		
		__block UIWindow *animationWindow = self.window;
		
		[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^() {
			animationWindow.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
			animationWindow.alpha = 1.0f;
		} completion:nil];
	}
    
    [self.delegate didPresentPopupView:self];

}

- (void) hide {
	[self hideAnimated:YES];
}

- (void) hideAnimated:(BOOL)animated {
    
    [_delegate popupViewCancel:self];
    
	if (animated) {
		__block UIWindow *animationWindow = self.window;
		
		[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^() {
			animationWindow.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
			animationWindow.alpha = 0.0f;
		} completion:^(BOOL finished) {
            self.window.hidden = YES;
            self.window = nil;
        }];
	} else {
		self.window.hidden = YES;
		self.window = nil;
	}
}

@end

#pragma mark checkState

@interface UICheckStateView ()
{
  UILabel     *_titleLabel;
  UITextView  *_textView;
  UIButton    *_okButton;
  UIButton    *_cancelButton;
  UIButton    *_circleCancelButton;
}
@end

@implementation UICheckStateView
@synthesize titleLabel=_titleLabel;
@synthesize textView=_textView;
@synthesize okButton=_okButton;
@synthesize cancelButton=_cancelButton;
@synthesize circleCancelButton =_circleCancelButton;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
    {
        _titleLabel = [[UILabel alloc]init];
        _textView = [[UITextView alloc]init];
        _textView.editable = NO;
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _circleCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrayButtons insertObject:_cancelButton atIndex:0];
        [_arrayButtons insertObject:_okButton atIndex:1];
        [_arrayButtons insertObject:_circleCancelButton atIndex:2];
        [_cancelButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_okButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_circleCancelButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_textView];
        [self addSubview:_titleLabel];
        [self addSubview:_cancelButton];
        [self addSubview:_okButton];
        [self addSubview:_circleCancelButton];
    }
	return self;
}
@end
#pragma mark UIActivityIndicatorPopupView
@interface UIActivityIndicatorPopupView ()
{
    UIActivityIndicatorView *_activityView;
    UILabel *_titleLabel;
}
@end

@implementation UIActivityIndicatorPopupView

@synthesize activityIndicatorView = _activityView;
@synthesize titleLabel = _titleLabel ;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        _titleLabel = [[UILabel alloc]init];
		//if(!timer)
        {
            //_activityView = [[UIActivityIndicatorView alloc]
            //             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
            //[self addSubview:_activityView];
        }
        [self addSubview:_titleLabel];
    }
	return self;
}

- (void) showAnimated:(BOOL)animated
{
	//[_activityView startAnimating];
	[super showAnimated:animated];
}

@end

#pragma mark UITextSignleInputPopupView
@interface UITextSignleInputPopupView ()
{
    UILabel     *_titleLabel;
    UITextView  *_textView;
    UIButton    *_cancelBtn;
    UIButton    *_okBtn;
}
@end

@implementation UITextSignleInputPopupView

@synthesize titleLabel  = _titleLabel;
@synthesize textView    = _textView;
@synthesize cancelButton = _cancelBtn;
@synthesize okButton    = _okBtn;
@synthesize textHint = _textHint;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        _titleLabel = [[UILabel alloc]init];
        _textView = [[UITextView alloc]init];
        _textView.delegate=self;
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:_textView];
        [self addSubview:_titleLabel];
        [self addSubview:_cancelBtn];
        [self addSubview:_okBtn];
        
        [_arrayButtons insertObject:_cancelBtn atIndex:0];
        [_arrayButtons insertObject:_okBtn atIndex:1];
        
        [_cancelBtn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewShouldBeginEditing)
                                                     name:UITextViewTextDidBeginEditingNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidEndEditing)
                                                     name:UITextViewTextDidEndEditingNotification
                                                   object:nil];
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidEndEditing)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        */
    }
	return self;
}

- (void) textViewShouldBeginEditing
{
    _textView.text = @"";
    _textView.textColor = [UIColor blackColor];
}

- (void) textViewDidEndEditing
{
    if(_textView.text.length == 0){
        _textView.textColor = [UIColor lightGrayColor];
        _textView.text = _textHint;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{  
    if ([text isEqualToString:@"\n"])
    {
        [_textView resignFirstResponder];
        return NO;
    }
    if(range.location>21)
    {
        return NO;
    }
    return YES;
}

-(void)keyboardWillShow {
    
    // 暫時解決鍵盤遮住 popup view的問題，但並非治本方法。
    [self setTransform: CGAffineTransformMakeTranslation(0.0, -60)];
}

- (void) hide {
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:nil];
    
    [self endEditing:YES];
    [super hide];
}

@end


#pragma mark UITextInputPopupView
@interface UITextInputPopupView ()
{
    UILabel     *_titleLabel;
    UITextView  *_textView;
    UIButton    *_cancelBtn;
    UIButton    *_okBtn;
}
@end

@implementation UITextInputPopupView

@synthesize titleLabel  = _titleLabel;
@synthesize textView    = _textView;
@synthesize cancelButton = _cancelBtn;
@synthesize okButton    = _okBtn;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        
        _titleLabel = [[UILabel alloc]init];
        _textView = [[UITextView alloc]init];
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [self addSubview:_textView];
        [self addSubview:_titleLabel];
        [self addSubview:_cancelBtn];
        [self addSubview:_okBtn];
    
        [_arrayButtons insertObject:_cancelBtn atIndex:0];
        [_arrayButtons insertObject:_okBtn atIndex:1];
        
        [_cancelBtn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
    }
	return self;
}
    
-(void)keyboardWillShow {
    
    // 暫時解決鍵盤遮住 popup view的問題，但並非治本方法。
    [self setTransform: CGAffineTransformMakeTranslation(0.0, -120)];
}

- (void) hide {
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [self endEditing:YES];
    [super hide];
}

@end


#pragma mark UITextDisplayPopupView
@interface UITextDisplayPopupView()
{
    UILabel     *_titleLabel;
    UITextView  *_textView;
    UIButton    *_cancelBtn;
}
@end

@implementation UITextDisplayPopupView

@synthesize titleLabel  = _titleLabel;
@synthesize textView    = _textView;
@synthesize cancelButton    = _cancelBtn;

- (id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        
        _titleLabel = [[UILabel alloc]init];
        _textView = [[UITextView alloc]init];
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _textView.editable = NO;
        
        [self addSubview:_textView];
        [self addSubview:_titleLabel];
        [self addSubview:_cancelBtn];
        
        [_arrayButtons insertObject:_cancelBtn atIndex:0];
        
        [_cancelBtn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
	return self;
}

@end

