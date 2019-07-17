//
//  PLFTitleView.h
//  XSSYH
//
//  Created by ccia on 2019/7/17.
//  Copyright © 2019 ccia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PLFTitleViewBottomViewType) {
    kBottomViewWidthEqualButton,      //  下划线与按钮等宽
    kBottomViewWidthEqualText,        //  下划线与按钮文字等宽
    kBottomViewWidthCustom,           //  下划线宽度自定义
};

typedef void(^titleBtnClick)(NSInteger index);

@interface PLFTitleView : UIScrollView

/** 存放所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtons;

@property (nonatomic, copy) titleBtnClick titleBtnClick;

/**  下划线宽度样式，默认与按钮等宽  */
@property (nonatomic, assign) PLFTitleViewBottomViewType bottomViewWidthType;

/**  下划线宽度，只有设置kBottomViewWidthCustom时生效  */
@property (nonatomic, assign) CGFloat bottomViewWidth;

/**  分隔线高度  */
@property (nonatomic, assign) CGFloat separatorHeight;

/**
 按钮是否等宽，默认为YES
 标题按钮较多或者文字总体长度超过屏幕宽度可设为NO使用按钮宽度自适应
 */
@property (nonatomic, assign) BOOL isEqualWidth;



- (instancetype)initWithTitleArray:(NSArray *)array;
//  设置选中第几个按钮
- (void)selectIndex:(int)index;

/**
 设置样式
 
 @param normalColor     按钮文字默认颜色
 @param selectColor     按钮文字选中颜色
 @param separatorColor  分隔线颜色
 @param font 字体
 */
- (void)setNormalColor:(UIColor *)normalColor
           selectColor:(UIColor *)selectColor
        separatorColor:(UIColor *)separatorColor
                  font:(UIFont *)font;

- (void)setNormalColor:(UIColor *)normalColor
           selectColor:(UIColor *)selectColor
                  font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
