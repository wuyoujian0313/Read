//
//  BookIntroduceView.h
//  Read
//
//  Created by wuyoujian on 2017/11/26.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookIntroduceView : UIView
- (instancetype)initWithFrame:(CGRect)frame;

- (void)loadImageUrl:(NSString *)url text:(NSString *)text;
@end
