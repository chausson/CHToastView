//
//  CHToastView.h
//  CHToastView
//
//  Created by chausson on 2018/12/28.
//

#import <UIKit/UIKit.h>

@class CHToastView;
@protocol CHToastViewDelegate

- (UIView *)presentView:(CHToastView *)container;

@optional

- (void)toastWillAppear;
- (void)toastDidAppear;
- (void)toastDidClosed;

@end
@interface CHToastView : UIView

@property (weak, nonatomic) NSObject<CHToastViewDelegate> *delegate;
@property (assign, nonatomic) CGFloat alpha; // defult is 0.3f
@property (strong, nonatomic) UIColor *color; // defult is black
@property (assign, nonatomic) BOOL canDismissOnEmptyArea; // defult is Yes
@property (assign, nonatomic) CGFloat duration; // defult is .3f

+ (CHToastView *)sharedInstance;

- (void)show;
- (void)showAnimation;
- (void)dismiss;
- (void)dismissAnimation;


@end
