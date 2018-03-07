//
//  WZSToast.h
//  GCD定时器
//
//  Created by 吴泽松 on 2018/2/5.
//  Copyright © 2018年 吴泽松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WToast : NSObject

+ (WToast *)share;

/**
 * 展示提示框,注意:duration(提示框存在的时间)必须大于0.25
 *
 * @param message   提示框显示的文字
 * @param duration  提示框存在的时间
 */
- (void)showToastWithMessage:(NSString*)message duration:(NSTimeInterval)duration;

@end

