//
//  LoadingIndicatorView.h
//  SOLAROMobile
//
//  Created by Kumar Sharma on 21/09/10.
//  Copyright 2010 Castle Rock Research Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LoadingIndicatorViewDelegate <NSObject>

@optional

- (void)didCancelIndicatorView;

@end

@interface LoadingIndicatorView : UIView {
	UILabel	*messageLabel;
    BOOL _didIgnoreInteractionEvents;
    
    __weak id <LoadingIndicatorViewDelegate> delegate_;
}
- (id)initWithFrame:(CGRect)frame;
- (void)updateStatusMessage:(NSString*)statusMessage;

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message;
+ (void)removeLoadingIndicator:(LoadingIndicatorView *)liv;

+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message shouldIgnoreEvents:(BOOL)shouldIgnore;
+ (LoadingIndicatorView *)showLoadingIndicatorInView:(UIView *)view withMessage:(NSString *)message isFullViewMessageMode:(BOOL)fullViewMessageMode cancelOptionTitle:(NSString *)cancelTitle;

-(id)initWithFrame:(CGRect)frame isFullViewMessageMode:(BOOL)fullViewMessageMode cancelOptionTitle:(NSString *)cancelTitle;
@property (nonatomic, assign) BOOL didIgnoreInteractionEvents, isDirectCancelMode;
@property (nonatomic, weak) id <LoadingIndicatorViewDelegate> delegate;
@property (nonatomic, strong) NSString *initialStatusMessage;

@end
