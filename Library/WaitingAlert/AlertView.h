//
//  UIPopupView.h
//  CustomAlertViewDemo
//
//  Created by Joey Chung on 12/12/18.
//  Copyright (c) 2012年 Joey Chung. All rights reserved.
//

#import <Foundation/Foundation.h>

// Frank Liu
// #define DEFAULT_STYLE

//
// Base on Design Patterns : "Singleton" and "Abstract Factory".
//

@class UIPopupView;
@class UIActivityIndicatorPopupView;
@class UITextInputPopupView;
@class UITextSignleInputPopupView;
@class UITextDisplayPopupView;
@class UICheckStateView;

#ifdef DEFAULT_STYLE


#else

@interface AlertView : NSObject


//+ (void) activityIndicatorWithTitle: (NSString *) title withDelegate:(id) delegate;

@property (strong, nonatomic) UIActivityIndicatorPopupView *alertView;
@property (strong, nonatomic) UIProgressView *progressView;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;
- (void)dismiss:(BOOL)animated;
- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

#endif

@protocol UIPopupViewDelegate <NSObject>

@optional
/// Responding to Actions
- (void)popupView:(UIPopupView *)popupView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Custom Behavior
- (void)willPresentPopupView:(UIPopupView *)popupView;
- (void)didPresentPopupView:(UIPopupView *)popupView;
- (void)popupView:(UIPopupView *)popupView willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)popupView:(UIPopupView *)popupView didDismissWithButtonIndex:(NSInteger)buttonIndexCanceling;

//// Canceling
- (void)popupViewCancel:(UIPopupView *)popupView;

@end


#pragma mark UIPopupView
@interface UIPopupView : UIView

@property(nonatomic, weak) id<UIPopupViewDelegate> delegate;

- (void) show;
- (void) showAnimated:(BOOL)animated;

- (void) hide;
- (void) hideAnimated:(BOOL)animated;

@end


#pragma mark UIActivityIndicatorPopupView
@interface UIActivityIndicatorPopupView : UIPopupView

@property(nonatomic, readonly) UIActivityIndicatorView    *activityIndicatorView;
@property(nonatomic, readonly) UILabel                    *titleLabel;

@end


#pragma mark UITextInputPopupView
@interface UITextInputPopupView : UIPopupView

@property (nonatomic, readonly) UILabel       *titleLabel;
@property (nonatomic, readonly) UITextView    *textView;
@property (nonatomic, readonly) UIButton      *okButton;
@property (nonatomic, readonly) UIButton      *cancelButton;

@end

@interface UITextSignleInputPopupView : UIPopupView <UITextViewDelegate>

@property (nonatomic, readonly) UILabel       *titleLabel;
@property (nonatomic, readonly) UITextView    *textView;
@property (nonatomic, strong)   NSString      *textHint;
@property (nonatomic, readonly) UIButton      *okButton;
@property (nonatomic, readonly) UIButton      *cancelButton;

@end


#pragma mark UITextDisplayPopupView
@interface UITextDisplayPopupView : UIPopupView

@property (nonatomic, readonly) UILabel       *titleLabel;
@property (nonatomic, readonly) UITextView    *textView;
@property (nonatomic, readonly) UIButton      *cancelButton;

@end


@interface UICheckStateView : UIPopupView

@property (nonatomic, readonly) UILabel       *titleLabel;
@property (nonatomic, readonly) UITextView    *textView;
@property (nonatomic, readonly) UIButton      *okButton;
@property (nonatomic, readonly) UIButton      *cancelButton;
@property (nonatomic, readonly) UIButton      *circleCancelButton;
@end

