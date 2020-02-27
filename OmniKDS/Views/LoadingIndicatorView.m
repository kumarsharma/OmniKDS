//
//  LoadingIndicatorView.m
//  SOLAROMobile
//
//  Created by Kumar Sharma on 21/09/10.
//  Copyright 2010 Castle Rock Research Corp. All rights reserved.
//

#import "LoadingIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@interface LoadingIndicatorView ()
@property(nonatomic, retain) UILabel	*messageLabel;
@property (nonatomic, assign) BOOL isFullViewMessageMode;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSString *cancelOptionTitle;
-(void)addSubviews;
@end

@implementation LoadingIndicatorView

@synthesize messageLabel;
@synthesize didIgnoreInteractionEvents = _didIgnoreInteractionEvents;
@synthesize isFullViewMessageMode;
@synthesize cancelButton;
@synthesize delegate = delegate_;
@synthesize initialStatusMessage;
@synthesize cancelOptionTitle;
@synthesize isDirectCancelMode;

-(id)initWithFrame:(CGRect)frame{
		
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		frame = CGRectMake(0, 0, 160, 160);
	else
		frame = CGRectMake(0, 0, 160, 140);	
	
	if((self = [super initWithFrame:frame])){
		self.backgroundColor = [UIColor blackColor];
		self.layer.cornerRadius = 10;
		self.alpha = 0.85;
		[self addSubviews];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame isFullViewMessageMode:(BOOL)fullViewMessageMode cancelOptionTitle:(NSString *)cancelTitle
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(cancelTitle)
            frame = CGRectMake(0, 0, 220, 220);
        else
            frame = CGRectMake(0, 0, 160, 160);
    }
    else
        frame = CGRectMake(0, 0, 160, 140);
    
    if((self = [super initWithFrame:frame])){
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
        self.alpha = 0.85;
        self.isFullViewMessageMode = fullViewMessageMode;
        self.cancelOptionTitle = cancelTitle;
        [self addSubviews];
    }
    return self;
}

-(void)addSubviews{
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[indicatorView startAnimating];	
	indicatorView.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2 - 45));

	UILabel *lbl = [[UILabel alloc] init];
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(self.isFullViewMessageMode)
        {
            indicatorView.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height/2 - 55));
            lbl.numberOfLines = 10;
            lbl.font = [UIFont boldSystemFontOfSize:17];
            lbl.frame = CGRectMake(1, indicatorView.center.y+15, self.frame.size.width-4, 21);
            
            if(self.cancelOptionTitle)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(10, self.frame.size.height-43, self.frame.size.width-20, 33);
                [btn setTitle:self.cancelOptionTitle forState:UIControlStateNormal];
                btn.titleLabel.adjustsFontSizeToFitWidth = YES;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:27];
                btn.backgroundColor = [UIColor redColor];
                btn.titleLabel.textColor = [UIColor whiteColor];
                btn.layer.cornerRadius = 5;
                btn.layer.borderColor = [[UIColor grayColor] CGColor];
                btn.layer.borderWidth = 1.0;
                btn.showsTouchWhenHighlighted = YES;
                self.cancelButton = btn;
                [btn addTarget:self action:@selector(cacncelBtnAction) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
        else
        {
            lbl.numberOfLines = 4;
            lbl.frame = CGRectMake(1, indicatorView.center.y+45, self.frame.size.width-4, 21);
        }
    }
	else
    {
        if(self.isFullViewMessageMode)
        {
            lbl.numberOfLines = 10;
            lbl.frame = CGRectMake(1, indicatorView.center.y+10, self.frame.size.width-4, 21);
        }
        else
        {
            lbl.numberOfLines = 4;
            lbl.frame = CGRectMake(1, indicatorView.center.y+45, self.frame.size.width-4, 21);
        }
    }
	
	lbl.text = @"";
    lbl.adjustsFontSizeToFitWidth = YES;
//    lbl.minimumScaleFactor = 10;
	lbl.textAlignment = NSTextAlignmentCenter;
	lbl.backgroundColor = [UIColor clearColor];
	lbl.textColor = [UIColor whiteColor];
	[self addSubview:lbl];
	[self addSubview:indicatorView];
	self.messageLabel = lbl;
}

- (void)cacncelBtnAction
{
    if(self.isDirectCancelMode)
    {
//        if([self.delegate respondsToSelector:@selector(didCancelIndicatorView)])
//            [self.delegate didCancelIndicatorView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel this transaction?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cancel for Later Upload?" message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([self.delegate respondsToSelector:@selector(didCancelIndicatorView)])
            [self.delegate didCancelIndicatorView];
    }
}

-(void)updateStatusMessage:(NSString*)statusMessage{
	
    //reposition the width
    CGRect textFrame = self.self.messageLabel.frame;
    textFrame.size.height = 21 +  (statusMessage.length / 20) * 21;
    self.messageLabel.frame = textFrame;
	self.messageLabel.text = statusMessage;
	[self.messageLabel setNeedsDisplay];
}

-(void)dealloc{
	
	self.messageLabel = nil;
}

#pragma mark - Direct call

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message
{
    return [self showLoadingIndicatorInView:view withMessage:message isFullViewMessageMode:NO cancelOptionTitle:nil];
}

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message isFullViewMessageMode:(BOOL)fullViewMessageMode cancelOptionTitle:(NSString *)cancelTitle
{
    LoadingIndicatorView *liv = [[LoadingIndicatorView alloc] initWithFrame:CGRectZero isFullViewMessageMode:fullViewMessageMode cancelOptionTitle:cancelTitle];
    liv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [liv setCenter:CGPointMake(view.bounds.size.width/2-10,(view.bounds.size.height/2 - 60))];
    [view addSubview:liv];
    
    if(cancelTitle)
        view.userInteractionEnabled = YES;
    else
        view.userInteractionEnabled = NO;
    liv.initialStatusMessage = message;
    [liv updateStatusMessage:message];
    
    return liv;
}

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message shouldIgnoreEvents:(BOOL)shouldIgnore
{
    LoadingIndicatorView *liv = [self showLoadingIndicatorInView:view withMessage:message];
    
    liv.didIgnoreInteractionEvents = shouldIgnore;
    if(shouldIgnore)
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    return liv;
}


+ (void)removeLoadingIndicator:(LoadingIndicatorView *)liv
{
    if(liv)
    {
        liv.superview.userInteractionEnabled = YES;
        [liv removeFromSuperview];
    }
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

@end
