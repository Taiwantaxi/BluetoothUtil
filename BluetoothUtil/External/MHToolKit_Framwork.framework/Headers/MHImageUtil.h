//
//  MHImageUtil.h
//  AutoLayoutByCode
//
//  Created by Bo-Rong on 2017/12/27.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MHImageUtil : NSObject

/**
 * @brief 取得實色Image
 *
 * @param color
 * 目標顏色
 *
 * @param size
 * 目標尺寸
 *
 * @param radius
 * 目標導角
 *
 * @return UIImage
 * 回傳實色Image
 *
 */
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;

@end
