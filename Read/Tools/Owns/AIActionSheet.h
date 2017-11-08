//
//  AIActionSheet.h
//  CommonProject
//
//  Created by wuyoujian on 16/8/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>


// 如果工程中使用了AIBase.framework，就请定义宏AISHARE
// 主要用于解决类冲突的问题，AIActionSheet属于框架AIBase里的代码
#ifdef AISHARE
#define AIActionSheet               AIActionSheetForShare
#define AISheetItem                 AISheetItemForShare
#define AIActionSheetBlock          AIActionSheetBlockForShare
#define AIActionSheetDelegate       AIActionSheetDelegateForShare
#define inline_AIActionSheetCell    inline_AIActionSheetCellForShare
#endif

@class AIActionSheet ;
typedef void(^ AIActionSheetBlock )( AIActionSheet *actionSheet, NSInteger buttonIndex);

@protocol AIActionSheetDelegate <NSObject>
- (void)didSelectedActionSheet:( AIActionSheet *)actionSheet buttonIndex:(NSInteger)buttonIndex;
@end

@interface AISheetItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *iconPath;
@end

@interface AIActionSheet : UIView
@property (nonatomic, readonly, assign) NSInteger cancelButtonIndex;

//
- (instancetype)initInParentView:(UIView*)parentView block:( AIActionSheetBlock )block;
- (instancetype)initInParentView:(UIView*)parentView delegate:(id < AIActionSheetDelegate >)delegate;
- (void)addActionItem:( AISheetItem *)item;
- (void)clearAllItems;
- (void)show;


@end
