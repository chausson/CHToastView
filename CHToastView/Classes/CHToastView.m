//
//  CHToastView.m
//  CHToastView
//
//  Created by chausson on 2018/12/28.
//

#import "CHToastView.h"
@interface CHToastView ()<CAAnimationDelegate>
@property (strong, nonatomic) UIView *toaskBgView;
@end
@implementation CHToastView

+ (CHToastView *)sharedInstance {
    static CHToastView *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CHToastView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        shareInstance.toaskBgView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        shareInstance.toaskBgView.backgroundColor = [UIColor blackColor];
        shareInstance.alpha = 0.3f;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:shareInstance action:@selector(closeTap:)];
        [shareInstance.toaskBgView addGestureRecognizer:tap];
        shareInstance.toaskBgView.layer.shouldRasterize = YES;
        [shareInstance addSubview:shareInstance.toaskBgView];
    });
    return shareInstance;
}
- (void)setAlpha:(CGFloat)alpha {
    _alpha = 1;
    _toaskBgView.alpha = alpha;
}
- (void)setColor:(UIColor *)color {
    _color = color;
    _toaskBgView.backgroundColor = color;
}
- (void)setCanDismissOnEmptyArea:(BOOL)canDismissOnEmptyArea {
    _canDismissOnEmptyArea = canDismissOnEmptyArea;
    _toaskBgView.userInteractionEnabled = NO;
}
- (void)show:(BOOL)animation {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(toastWillAppear)]) {
            [_delegate toastWillAppear];
        }
        for (UIView *view in UIApplication.sharedApplication.windows[0].subviews) {
            if ([view isEqual:self]) {
                return;
            }
        }
        UIView *presentView = [self.delegate presentView:self];
        presentView.center = _toaskBgView.center;
        [self addSubview:presentView];
        [UIApplication.sharedApplication.windows[0] addSubview:self];
        if (animation) {
            [self startAnimation:presentView];
        }else {
            if ([_delegate respondsToSelector:@selector(toastDidAppear)]) {
                [_delegate toastDidAppear];
            }
        }
    }
}
- (void)show {
    [self show:NO];
}
- (void)showAnimation {
    [self show:YES];
}
- (void)startAnimation:(UIView *)view {
    CABasicAnimation* caBaseBounds = [CABasicAnimation animation];
    caBaseBounds.delegate = self;
    caBaseBounds.duration = self.duration;
    caBaseBounds.keyPath = @"bounds";
    [caBaseBounds setValue:@"DidAppear" forKey:@"AnimationType"];
    caBaseBounds.removedOnCompletion = NO;
    caBaseBounds.fillMode = kCAFillModeForwards;
    caBaseBounds.fromValue = [NSValue valueWithCGRect:CGRectMake(self.center.x, self.center.y, 0, 0)];
    caBaseBounds.toValue = [NSValue valueWithCGRect:view.frame];
    [view.layer addAnimation:caBaseBounds forKey:nil];

}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *value = [anim valueForKey:@"AnimationType"];
    if (flag) {
        if ([_delegate respondsToSelector:@selector(toastDidAppear)] && [value isEqualToString:@"DidAppear"]) {
            [_delegate toastDidAppear];
        }
        if ([_delegate respondsToSelector:@selector(toastDidClosed)] && [value isEqualToString:@"DidClosed"]) {
            [_delegate toastDidClosed];
        }
    }
}
//  重写HitTest 来捕获事件
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha < 0.01) {
//        return nil;
//    }
//    if (![self pointInside:point withEvent:event]) {
//        return nil;
//    }
//    if (_delegate) {
//        UIView *presentView = [self.delegate presentView:self];
//        CGPoint presentPoint = [self convertPoint:point toView:presentView];
//        UIView *view = [presentView hitTest:presentPoint withEvent:event];
//        if (view) {
//            return nil;
//        }
//    }
//    return self;
//}

- (void)closeTap:(UITapGestureRecognizer *)tap {
    [self dismiss];
}
- (void)dismissAnimation {
    [self dismiss:YES];
}
- (void)dismiss:(BOOL)animation {
    if (_delegate) {
        if (animation ) {
            UIView *view = [self.delegate presentView:self];
            CABasicAnimation* caBaseBounds = [CABasicAnimation animation];
            caBaseBounds.duration = self.duration;
            caBaseBounds.keyPath = @"bounds";
            [caBaseBounds setValue:@"DidClosed" forKey:@"AnimationType"];
            caBaseBounds.delegate = self;
            caBaseBounds.removedOnCompletion = NO;
            caBaseBounds.fillMode = kCAFillModeForwards;
            caBaseBounds.fromValue = [NSValue valueWithCGRect:view.frame];
            caBaseBounds.toValue = [NSValue valueWithCGRect:CGRectMake(self.center.x, self.center.y, 0, 0)];
            [view.layer addAnimation:caBaseBounds forKey:nil];
        }else {
            if ([_delegate respondsToSelector:@selector(toastDidClosed)]) {
                [_delegate toastDidClosed];
            }
        }
    }
    [self removeFromSuperview];

}
- (void)dismiss {
    [self dismiss:NO];
}
@end
