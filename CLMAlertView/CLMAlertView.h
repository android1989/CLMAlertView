//
//  CLMAlertView.h
//  Todo
//
//  Created by Andrew Hulsizer on 7/14/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol CLMAlertViewDelegate;
@class CLMAlertView;

typedef NS_ENUM(NSInteger, CLMAlertViewAnimationStyle)
{
    CLMAlertViewAnimationStyleVertical, //Default
    CLMAlertViewAnimationStyleHorizontal,
    CLMAlertViewAnimationStyleGrowth
};

typedef void(^CLMAlertViewDidSelectItemBlock)(CLMAlertView * alertView, NSInteger buttonIndex);
typedef void(^CLMAlertViewShowAnimation)(CLMAlertView * alertView);
typedef void(^CLMAlertViewDismissAnimation)(CLMAlertView * alertView);
typedef void(^CLMAlertViewDismissAnimationCompletion)(CLMAlertView * alertView);

@interface CLMAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (instancetype)initWithView:(UIView *)view delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock;
- (instancetype)initWithView:(UIView *)view buttonTitles:(NSArray *)buttonTitles selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock;

- (void)show;
- (void)dismiss;

/****** NOTE ********
 If you plan on using this you are responsible for removing the alert view when finished animation in the dismissal block!!!!
 ****** FIN ********/
- (void)setCustomShowAnimationBlock:(CLMAlertViewShowAnimation)showAnimationBlock dismissBlock:(CLMAlertViewDismissAnimation)dismissAnimationBlock;

@property (nonatomic, weak) id<CLMAlertViewDelegate> delegate;
@property (nonatomic, assign) CLMAlertViewAnimationStyle animationStyle;

//Apperance Properties
@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *buttonImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *buttonHighlightedImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *buttonBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *buttonHighlightedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *seperatorColor UI_APPEARANCE_SELECTOR;
@end

//CLMAlertViewDelegate
@protocol CLMAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(CLMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(CLMAlertView *)alertView;

- (void)willPresentAlertView:(CLMAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(CLMAlertView *)alertView;  // after animation

- (void)alertView:(CLMAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(CLMAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

// Called after edits in any of the default fields added by the style
- (BOOL)alertViewShouldEnableFirstOtherButton:(CLMAlertView *)alertView;

@end
