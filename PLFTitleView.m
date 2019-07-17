//
//  PLFTitleView.m
//  XSSYH
//
//  Created by ccia on 2019/7/17.
//  Copyright © 2019 ccia. All rights reserved.
//

#import "PLFTitleView.h"

@interface PLFTitleView()
@property (nonatomic, weak) UIView *titleBottomView;

@property (nonatomic, weak) UIButton *selectedButton;
//  分割线
@property (nonatomic, strong) NSMutableArray *separators;

@end

@implementation PLFTitleView

#pragma mark - lazy
- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (NSMutableArray *)separators {
    if (!_separators) {
        _separators = [NSMutableArray array];
    }
    return _separators;
}

- (instancetype)initWithTitleArray:(NSArray *)array {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.isEqualWidth = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorHeight = 12;
        
        // 标签栏内部的标签按钮
        NSUInteger count = array.count;
        for (int i = 0; i < count; i++) {
            // 创建
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleButton];
            [self.titleButtons addObject:titleButton];
            titleButton.tag = i;
            
            // 文字
            NSString *title = array[i];
            [titleButton setTitle:title forState:UIControlStateNormal];
            //            [titleButton.titleLabel sizeToFit];
            
            if (i > 0) {
                //  从第二个按钮开始添加分割线
                UIView *separator = [[UIView alloc]init];
                [self addSubview:separator];
                [self.separators addObject:separator];
            }
        }
        
        // 标签栏底部的指示器控件
        UIView *titleBottomView = [[UIView alloc] init];
        titleBottomView.backgroundColor = [UIColor colorWithHex:0xF572A2];
        [self addSubview:titleBottomView];
        self.titleBottomView = titleBottomView;
        
        //  设置默认样式
        [self setNormalColor:[UIColor colorWithHexString:@"66"]
                 selectColor:[UIColor colorWithHex:0xF572A2]
                        font:[UIFont systemFontOfSize:15]];
        
        //  默认选中第0个按钮
        [self titleClick:self.titleButtons[0]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonW = 0, buttonH = self.height;
    
    if (self.isEqualWidth) {
        buttonW = self.width / self.titleButtons.count;
    }
    
    CGFloat separatorY = (self.height - self.separatorHeight) / 2;
    CGFloat x = 0;
    for (int i = 0; i < self.titleButtons.count; i++) {
        UIButton *button = self.titleButtons[i];
        [button.titleLabel sizeToFit];
        if (!self.isEqualWidth) {
            buttonW = button.titleLabel.width + 30;
        }
        button.frame = CGRectMake(x, 0, buttonW, buttonH);
        
        if (i > 0) {
            UIView *separator = self.separators[i - 1];
            separator.frame = CGRectMake(x, separatorY, 1, self.separatorHeight);
        }
        
        x += buttonW;
    }
    
    self.contentSize = CGSizeMake(x, 0);
    
    CGFloat bottomViewW = 0;
    switch (self.bottomViewWidthType) {
        case kBottomViewWidthEqualButton:
            if (self.titleButtons.count > 0) {
                bottomViewW = self.titleButtons[0].width;
            }
            break;
        case kBottomViewWidthEqualText:
            bottomViewW = self.selectedButton.titleLabel.width;
            break;
        case kBottomViewWidthCustom:
            bottomViewW = self.bottomViewWidth;
            break;
        default:
            break;
    }
    self.titleBottomView.frame = CGRectMake(0, self.height - 1, bottomViewW, 1);
    self.titleBottomView.centerX = self.selectedButton.centerX;
    
    //  所有按钮不能铺满
    if (x < self.width) {
        //  使所有按钮等宽
        self.isEqualWidth = YES;
        [self layoutSubviews];
    }
}

- (void)titleClick:(UIButton *)button {
    //  去掉按钮重复点击
    if (self.selectedButton == button) return;
    
    //  判断点了左边的按钮还是右边的按钮
    BOOL leftClick = button.tag < self.selectedButton.tag;
    
    // 控制按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    [button.titleLabel sizeToFit];
    // 底部控件的宽度
    switch (self.bottomViewWidthType) {
        case kBottomViewWidthEqualText:
            //  适应文字宽度
            self.titleBottomView.width = button.titleLabel.width;
            break;
        case kBottomViewWidthEqualButton:
            //  适应按钮宽度
            self.titleBottomView.width = button.width;
            break;
        default:
            break;
    }
    
    CGPoint offset = self.contentOffset;
    if (leftClick) {    // 点了左侧的按钮
        //  需要显示的按钮
        UIButton *showButton = button;
        if (button.tag > 0) {  //  点击的不是第一个按钮
            showButton = self.titleButtons[button.tag - 1];
        }
        
        //  需要显示的按钮未完全显示出来
        if (self.contentOffset.x > showButton.x) {
            offset = CGPointMake(showButton.x, 0);
        }
    } else  {   // 点了右侧的按钮
        //  需要显示的按钮
        UIButton *showButton = button;
        if (button.tag < (self.titleButtons.count - 1)) {  //  点击的不是最后一个按钮
            showButton = self.titleButtons[button.tag + 1];
        }
        
        //  需要显示的按钮未完全显示出来
        if ((self.contentOffset.x + self.width) < showButton.right) {
            offset = CGPointMake(showButton.right - self.width, 0);
        }
    }
    
    // 底部控件的位置
    [UIView animateWithDuration:0.25 animations:^{
        self.contentOffset = offset;
        self.titleBottomView.centerX = button.centerX;
    }];
    
    if (self.titleBtnClick) {
        self.titleBtnClick(button.tag);
    }
}

- (void)setNormalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor font:(UIFont *)font {
    [self setNormalColor:normalColor selectColor:selectColor separatorColor:[UIColor clearColor] font:font];
}

- (void)setNormalColor:(UIColor *)normalColor selectColor:(UIColor *)selectColor separatorColor:(UIColor *)separatorColor font:(UIFont *)font {
    self.titleBottomView.backgroundColor = selectColor;
    for (UIButton *button in self.titleButtons) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
        [button setTitleColor:selectColor forState:UIControlStateSelected];
        button.titleLabel.font = font;
    }
    
    for (UIView *view in self.separators) {
        view.backgroundColor = separatorColor;
    }
}

- (void)selectIndex:(int)index {
    [self titleClick:self.titleButtons[index]];
}


@end
