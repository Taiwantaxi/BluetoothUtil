//
//  MHArrangeUtil.h
//  AutoLayoutByCode
//
//  Created by Bo-Rong on 2017/12/27.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MHArrangeUtil : NSObject

typedef void (^MHArrangeBlock)(CGRect rect, NSInteger index);

/**
 * @brief 快速二維陣列排列，產生對應frame
 * 需帶入col, row, size, offset, gap
 *
 * @param col
 * 橫向數量
 * 
 * @param row
 * 縱向數量
 *
 * @param size
 * 排列物件尺寸
 * 
 * @param offset
 * 排列物件起始座標
 * 
 * @param gap
 * 排列物件間距
 *
 * @return arrangeBlock
 * 回傳物件frame, 以及順序編號，index從0開始
 *
 */
+ (void)arrangeTileWithCol:(NSInteger)col withRow:(NSInteger)row withSize:(CGSize)size withOffset:(CGPoint)offset withGap:(CGPoint)gap withOzArrangeBlock:(MHArrangeBlock)arrangeBlock;

@end
