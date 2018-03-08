//
//  WZSToast.m
//  GCD定时器
//
//  Created by 吴泽松 on 2018/2/5.
//  Copyright © 2018年 吴泽松. All rights reserved.
//

#import "WToast.h"

#define kMainScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight  [UIScreen mainScreen].bounds.size.height
#define toastLabelMaxWidth (kMainScreenWidth-120)
#define toastViewMaxWidth  (kMainScreenWidth-80)
#define textFont 17.0f

@interface ToastView : UIView

@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, copy) NSString *toastMessage;

@end

@implementation ToastView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.toastLabel];
    }
    return self;
}

#pragma mark - Setter
- (void)setToastMessage:(NSString *)toastMessage {
    _toastMessage = toastMessage;
    NSDictionary *attributeDictionary = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:textFont]};
    CGFloat lineHeight = [@"单行文本高度" boundingRectWithSize:CGSizeMake(toastLabelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDictionary context:nil].size.height;
    CGSize textSize = [toastMessage boundingRectWithSize:CGSizeMake(toastLabelMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDictionary context:nil].size;
    if (textSize.height <= lineHeight){
        self.bounds = CGRectMake(0, 0, textSize.width+80, textSize.height+40);
        self.toastLabel.frame = CGRectMake((self.bounds.size.width-textSize.width)*0.5, (self.bounds.size.height-textSize.height)*0.5, textSize.width, textSize.height);
    }else{
        self.bounds = CGRectMake(0, 0, toastViewMaxWidth, textSize.height+40);
        self.toastLabel.frame = CGRectMake((toastViewMaxWidth-toastLabelMaxWidth)*0.5, (self.bounds.size.height-textSize.height)*0.5, toastLabelMaxWidth, textSize.height);
    }
    self.toastLabel.text = toastMessage;
}

#pragma mark - Accessors
- (UILabel *)toastLabel {
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _toastLabel.numberOfLines = 0;
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.font = [UIFont systemFontOfSize:textFont];
        _toastLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0];
    }
    return _toastLabel;
}

@end


@interface WToast ()

@property (nonatomic, assign) BOOL active;  //提示框是否是使用状态
/**
 提示框在渐隐的时候被再次触发,用于判断在animation动画完成的block中,是否允许移除提示框
 若提示框存在的时间设置,小于渐隐的0.25s的情况下,会出现上一个animation动画完成的block中将提示框移除的情况
 */
@property (nonatomic, assign) BOOL removeState;
@property (nonatomic, strong) dispatch_source_t GCDTimer;
@property (nonatomic, assign) NSTimeInterval tempDuration;

@property (nonatomic, strong) ToastView *toastView;

- (void)dismissSelf;

@end


@implementation WToast

#pragma mark - SingleTon
+ (WToast *)share {
    static WToast *share;
    if (!share) {
        share = [[WToast alloc] init];
    }
    return share;
}

#pragma mark - Method Public
- (void)showToastWithMessage:(NSString*)message duration:(NSTimeInterval)duration {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.removeState = NO;
        self.toastView.alpha = 1;
        if (self.active == YES) {
            self.active = NO;
            dispatch_source_cancel(self.GCDTimer);
            [self showToastWithMessage:message duration:duration];
        }else{
            self.active = YES;
            self.tempDuration = 0.0;
            self.toastView.toastMessage = message;
            self.toastView.center = [[[UIApplication sharedApplication] delegate] window].center;
            [[[[UIApplication sharedApplication] delegate] window] addSubview:self.toastView];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.GCDTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_GCDTimer,dispatch_walltime(NULL, 0),0.1*NSEC_PER_SEC, 0);
            __weak typeof(self) weakSelf = self;
            dispatch_source_set_event_handler(_GCDTimer, ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.tempDuration += 0.1;
                NSLog(@"%f",strongSelf.tempDuration);
                if (strongSelf.tempDuration >= duration) {
                    dispatch_source_cancel(strongSelf.GCDTimer);
                    strongSelf.removeState = YES;
                    [strongSelf dismissSelf];
                }
            });
            dispatch_resume(_GCDTimer);
        }    
    });
}

- (void)dismissSelf {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.toastView.alpha = 0;
        }completion:^(BOOL finished) {
            if (self.removeState) {
                self.active = NO;
                [self.toastView removeFromSuperview];
            }
        }];
    });
}

#pragma mark - Accessors
- (ToastView *)toastView {
    if (!_toastView) {
        _toastView = [[ToastView alloc] initWithFrame:CGRectZero];
        _toastView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _toastView.layer.cornerRadius = 6.0f;
        _toastView.clipsToBounds = YES;
    }
    return _toastView;
}

@end
