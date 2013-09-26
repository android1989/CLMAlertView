//
//  CLMAlertView.m
//  Todo
//
//  Created by Andrew Hulsizer on 7/14/13.
//  Copyright (c) 2013 Andrew Hulsizer. All rights reserved.
//

#import "CLMAlertView.h"

static const CGFloat kCLMAlertViewPadding = 8.0f;
static const CGFloat kCLMAlertViewVerticalPadding = 20.0f;
static const CGFloat kCLMAlertViewDefaultButtonHeight = 44.0f;
static const CGFloat kCLMAlertViewMinimumHeight = 60.0f;
static const CGFloat kCLMAlertViewWidth = 260.0f;
@interface CLMAlertView ()

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, copy) CLMAlertViewShowAnimation showAnimation;
@property (nonatomic, copy) CLMAlertViewDismissAnimation dismissAnimation;
@property (nonatomic, copy) CLMAlertViewDidSelectItemBlock selectionBlock;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation CLMAlertView

#pragma mark - Inits
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self)
    {
        _title = title ?: @"";
        _message = message ?: @"";
        _delegate = delegate;
        _buttonTitles = [buttonTitles copy];
        [self CLMAlertViewCommonInit];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view delegate:(id)delegate buttonTitles:(NSArray *)buttonTitles
{
    self = [super init];
    if (self)
    {
        _customView = view;
        _delegate = delegate;
        _buttonTitles = [buttonTitles copy];
        [self CLMAlertViewCommonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock
{
    self = [super init];
    if (self)
    {
        _title = title ?: @"";
        _message = message ?: @"";
        _selectionBlock = selectionBlock;
        _buttonTitles = [buttonTitles copy];
        [self CLMAlertViewCommonInit];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view buttonTitles:(NSArray *)buttonTitles selectionBlock:(CLMAlertViewDidSelectItemBlock)selectionBlock
{
    self = [super init];
    if (self)
    {
        _customView = view;
        _selectionBlock = selectionBlock;
        _buttonTitles = [buttonTitles copy];
        [self CLMAlertViewCommonInit];
    }
    return self;
}

//Obscure name on purpose to prevent namespace collisions with subclasses
- (void)CLMAlertViewCommonInit
{
	[self setDefaults];
	
    [self setAnimationStyle:CLMAlertViewAnimationStyleVertical];
    self.buttons = [[NSMutableArray alloc] init];
    [self buildView];
}

- (void)setDefaults
{
	_backgroundImage = nil;
	_titleFont = [UIFont boldSystemFontOfSize:17];
	_messageFont = [UIFont systemFontOfSize:14];
	_buttonFont = [UIFont systemFontOfSize:17];
	_buttonImage = nil;
    _buttonHighlightedImage = nil;
	_buttonBackgroundColor = [UIColor clearColor];
    _buttonHighlightedBackgroundColor = [UIColor colorWithWhite:.75 alpha:.9];
	self.backgroundColor = [UIColor colorWithWhite:.9 alpha:.9];
    
}

#pragma mark - Builders

- (void)buildView
{
	for (UIView *view in self.subviews)
	{
		[view removeFromSuperview];
	}
	
    if (self.customView)
    {
		[self buildCustomView];
    }else{
		[self buildInternalView];
	}
}

- (void)buildInternalView
{
	//build title label
	[self buildTitleLabelWithFrame:CGRectZero];
	CGRect titleFrame = self.titleLabel.frame;
	
	//build message label
	[self buildMessageLabelWithFrame:CGRectZero];
	CGRect messageFrame = self.messageLabel.frame;
	
	//Size the entire view
	CGFloat maxHeight = MAX(CGRectGetHeight(titleFrame)+CGRectGetHeight(messageFrame)+ 2*kCLMAlertViewVerticalPadding+kCLMAlertViewPadding, kCLMAlertViewMinimumHeight);
	
	if (CGRectGetHeight(messageFrame) == 0)
	{
		titleFrame.size.height = maxHeight-2*kCLMAlertViewVerticalPadding;
		self.titleLabel.frame = titleFrame;
	}else if (CGRectGetHeight(titleFrame) == 0) {
		messageFrame.size.height = maxHeight-2*kCLMAlertViewVerticalPadding-CGRectGetHeight(self.titleLabel.frame);
		self.messageLabel.frame = messageFrame;
	}
	
	CGRect frame = CGRectMake(0, 0, kCLMAlertViewWidth, maxHeight);

	[self buildSeperatorWithFrame:frame];
	[self buildButtonsForFrame:frame];
		
	//Add the button height
	frame.size.height += kCLMAlertViewDefaultButtonHeight;
	self.frame = frame;

	self.layer.cornerRadius = 5;
}

- (void)buildTitleLabelWithFrame:(CGRect)frame
{
	//Add title Label
	self.titleLabel = [[UILabel alloc] initWithFrame:frame];
	self.titleLabel.text = _title;
	self.titleLabel.font = self.titleFont;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.numberOfLines = 0; 
	[self adjustTitleFrame];
	
	[self addSubview:self.titleLabel];
}

- (void)buildMessageLabelWithFrame:(CGRect)frame
{
	//Add message Label
	self.messageLabel = [[UILabel alloc] init];
	self.messageLabel.text = _message;
	self.messageLabel.font = self.messageFont;
	self.messageLabel.textAlignment = NSTextAlignmentCenter;
	self.messageLabel.numberOfLines = 0;
	[self adjustMessageFrame];
	
	[self addSubview:self.messageLabel];
}

- (void)buildSeperatorWithFrame:(CGRect)frame
{
	UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame), CGRectGetWidth(frame), .5)];
	[seperator setBackgroundColor:[UIColor colorWithWhite:0 alpha:.2]];
	[self addSubview:seperator];
}

- (void)buildVerticalSeperator:(CGRect)frame
{
	UIView *seperator = [[UIView alloc] initWithFrame:frame];
	[seperator setBackgroundColor:[UIColor colorWithWhite:0 alpha:.2]];
	[self addSubview:seperator];
}

- (void)buildButtonsForFrame:(CGRect)frame
{
	//Add the buttons
	CGFloat buttonWidth = (kCLMAlertViewWidth)/[self.buttonTitles count];
	__block CGFloat runningX = 0;
	
	[self.buttonTitles enumerateObjectsUsingBlock:^(NSString *newTitle, NSUInteger idx, BOOL *stop)
	{
		//Create New button and adjust x position
		UIButton *newButton = [self buildButtonWithTitle:newTitle];
		newButton.frame = CGRectMake(runningX, frame.size.height, buttonWidth, kCLMAlertViewDefaultButtonHeight);
		runningX += buttonWidth;
		
		//add button to button array for later
		[self.buttons addObject:newButton];
		[self addSubview:newButton];
		
		//add seperator line between button
		if (idx != [self.buttonTitles count]-1)
		{
			[self buildVerticalSeperator:CGRectMake(runningX, frame.size.height, .5, kCLMAlertViewDefaultButtonHeight)];
		}
		
	}];
}

- (UIButton *)buildButtonWithTitle:(NSString *)title
{
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [newButton setTitle:title forState:UIControlStateNormal];
	[newButton.titleLabel setFont:self.buttonFont];
    [newButton setBackgroundColor:self.buttonBackgroundColor];
	[newButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    [newButton setBackgroundImage:self.buttonImage forState:UIControlStateNormal];
    [newButton setBackgroundImage:self.buttonHighlightedImage forState:UIControlStateHighlighted];
    [newButton addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [newButton addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [newButton addTarget:self action:@selector(buttonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [newButton addTarget:self action:@selector(buttonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [newButton addTarget:self action:@selector(buttonTouchDownInside:) forControlEvents:UIControlEventTouchDown];

    return newButton;
}

- (void)buildCustomView
{
	CGRect frame = CGRectInset(self.customView.frame, -kCLMAlertViewPadding, -kCLMAlertViewPadding);
	
	UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, kCLMAlertViewDefaultButtonHeight)];
	frame.size.height += CGRectGetHeight(cancel.frame);
	self.frame = frame;
	[self addSubview:self.customView];
	[self addSubview:cancel];
}

#pragma mark - Helpers

- (void)adjustTitleFrame
{
	CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(kCLMAlertViewWidth-(kCLMAlertViewPadding*2), CGRectGetHeight(self.bounds))];
	CGRect titleFrame = self.titleLabel.frame;
	
	titleFrame.size.width = kCLMAlertViewWidth-(kCLMAlertViewPadding*2);
	titleFrame.size.height = titleSize.height;
	titleFrame.origin.y = kCLMAlertViewVerticalPadding;
	titleFrame.origin.x = kCLMAlertViewPadding;
	
	self.titleLabel.frame = titleFrame;
}

- (void)adjustMessageFrame
{
	CGSize messageSize = [self.messageLabel sizeThatFits:CGSizeMake(kCLMAlertViewWidth-(kCLMAlertViewPadding*2), CGRectGetHeight(self.bounds))];
	CGRect messageFrame = self.messageLabel.frame;
	messageFrame.origin.x = kCLMAlertViewPadding;
	messageFrame.origin.y  = CGRectGetHeight(self.titleLabel.frame) == 0 ? CGRectGetMaxY(self.titleLabel.frame) : CGRectGetMaxY(self.titleLabel.frame)+kCLMAlertViewPadding;
	messageFrame.size.height = messageSize.height;
	messageFrame.size.width = kCLMAlertViewWidth-(kCLMAlertViewPadding*2);
	
	self.messageLabel.frame = messageFrame;
}

#pragma mark - Adjust the view based on property change

- (void)adjustView
{
	if (self.customView)
    {
		[self adjustCustomView];
    }else{
		[self adjustInternalView];
	}
	
}

- (void)adjustCustomView
{
	
}

- (void)adjustInternalView
{
	[self adjustTitleFrame];
	self.titleLabel.font = self.titleFont;
	
	[self adjustMessageFrame];
	self.messageLabel.font = self.messageFont;
}

#pragma mark - Actions

- (void)show
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.center = window.center;
    [self setClipsToBounds:YES];
    
    [window addSubview:self];
    
    self.showAnimation(self);
}

- (void)dismiss
{
    if (self.dismissAnimation)
    {
        self.dismissAnimation(self);
    }else{
        [self removeFromSuperview];
    }
}

- (void)buttonTouchUpInside:(UIButton *)sender
{
    [sender setBackgroundColor:self.buttonBackgroundColor];
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (obj == sender)
        {
            self.selectionBlock(self,idx);
            *stop = YES;
        }
    }];
}

- (void)buttonTouchUpOutside:(UIButton *)sender
{
    [sender setBackgroundColor:self.buttonBackgroundColor];
}

- (void)buttonTouchDownInside:(UIButton *)sender
{
    [sender setBackgroundColor:self.buttonHighlightedBackgroundColor];
}

- (void)buttonTouchDragExit:(UIButton *)sender
{
    [sender setBackgroundColor:self.buttonBackgroundColor];
}

- (void)buttonTouchDragEnter:(UIButton *)sender
{
    [sender setBackgroundColor:self.buttonHighlightedBackgroundColor];
}

#pragma mark - Custom Setters

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
	_backgroundImage = backgroundImage;
}

- (void)setTitleFont:(UIFont *)titleFont
{
	_titleFont = titleFont;
	[self adjustView];
}

- (void)setMessageFont:(UIFont *)messageFont
{
	_messageFont = messageFont;
	[self adjustView];
}

#pragma mark - Animations
- (void)setAnimationStyle:(CLMAlertViewAnimationStyle)animationStyle
{
    _animationStyle = animationStyle;
    switch (_animationStyle) {
        case CLMAlertViewAnimationStyleGrowth:
            [self setGrowthAnimation];
            break;
        case CLMAlertViewAnimationStyleHorizontal:
            [self setHorizontalAnimation];
            break;
        case CLMAlertViewAnimationStyleVertical:
            [self setVerticalAnimation];
            break;
    }
}

- (void)setCustomShowAnimationBlock:(CLMAlertViewShowAnimation)showAnimationBlock dismissBlock:(CLMAlertViewDismissAnimation)dismissAnimationBlock
{
    self.showAnimation = showAnimationBlock;
    self.dismissAnimation = dismissAnimationBlock;
}

#pragma mark - InHouse Animation blocks

- (void)setGrowthAnimation
{
    [self setShowAnimation:^(CLMAlertView *alertView){
        alertView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            alertView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        [UIView animateWithDuration:0.5 animations:^{
            alertView.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];
}

- (void)setVerticalAnimation
{
    [self setShowAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        startFrame.origin.y = -startFrame.size.height;
        alertView.frame = startFrame;
        [UIView animateWithDuration:0.5 animations:^{
            alertView.frame = endFrame;
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        endFrame.origin.y = CGRectGetHeight(alertView.superview.frame)+startFrame.size.height;

        [UIView animateWithDuration:0.65 animations:^{
            alertView.frame = endFrame;
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];
}

- (void)setHorizontalAnimation
{
    [self setShowAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        startFrame.origin.x = -startFrame.size.width;
        alertView.frame = startFrame;
        [UIView animateWithDuration:0.5 animations:^{
            alertView.frame = endFrame;
        }];
    }];
    
    [self setDismissAnimation:^(CLMAlertView *alertView){
        CGRect endFrame = alertView.frame;
        CGRect startFrame = alertView.frame;
        endFrame.origin.x = CGRectGetWidth(alertView.superview.frame)+startFrame.size.width;
        
        [UIView animateWithDuration:0.5 animations:^{
            alertView.frame = endFrame;
        } completion:^(BOOL finished) {
            [alertView removeFromSuperview];
        }];
    }];

}
@end
