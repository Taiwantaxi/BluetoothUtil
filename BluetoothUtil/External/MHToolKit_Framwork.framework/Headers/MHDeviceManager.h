//
//  MHDeviceManager.h
//  AutoLayoutByCode
//
//  Created by Bo-Rong on 2017/12/22.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#include <sys/utsname.h>

#define LANG_TW                     @"zh-Hant"
#define LANG_CN                     @"zh-Hans"
#define LANG_EN                     @"en"
#define LANG_JA                     @"ja"
#define LANG_KO                     @"ko"
#define LANG_FR                     @"fr"
#define LANG_ES                     @"es"
#define LANG_DE                     @"de"
#define LANG_IT                     @"it"
#define LANG_NL                     @"nl"
#define LANG_PT                     @"pt"
#define LANG_RU                     @"ru"
#define LANG_SV                     @"sv"
#define LANG_DA                     @"da"
#define LANG_PL                     @"pl"
#define LANG_AR                     @"ar"
#define LANG_TR                     @"tr"
#define LANG_HU                     @"hu"


#define rBaseWidth          640.0f
#define rBaseHeight         1136.0f

//Value為 4 inch單位 (ref : https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions)

#define rWidth(value)           ceilf(kWinSizeWidth * (value * 2.0f / rBaseWidth))
#define rHeight(value)          ceilf(kWinSizeHeight * (value * 2.0f / rBaseHeight))

typedef NS_ENUM(NSInteger, MHDeviceType) {
    
    MHDeviceType_iPhone_3_5inch,
    MHDeviceType_iPhone_4inch,
    MHDeviceType_iPhone_4_7inch,
    MHDeviceType_iPhone_5_5inch,
    MHDeviceType_iPhone_5_8inch,
    MHDeviceType_iPad,
    
};


@interface MHDeviceManager : NSObject

/**
 * @brief 取得MHDeviceManager
 * MHDeviceManager物件實體
 * 
 * @return MHDeviceManager.
 * 回傳MHDeviceManager物件實體
 */
+ (MHDeviceManager *)sharedInstance;

/**
 * @brief 取得目前銀幕尺寸
 * 請參考HMDeviceType
 *
 */
@property CGSize winSize;

/**
 * @brief 取得目前裝置類型
 * 請參考MHDeviceType
 *
 */
@property MHDeviceType deviceType;

/**
 * @brief 取得裝置名稱
 * 
 * @return NSString
 * 回傳裝置名稱
 *
 */
-(NSString *)getDeviceName;

/**
 * @brief 取得Temp檔案路徑
 * 取得Progect temp 資料夾路徑
 * 
 * @return NSString.
 * 回傳產生的檔案路徑
 *
 */
-(NSString *)getTempPath;

/**
 * @brief 取得Document
 * 
 * @return NSString.
 * 回傳產生的檔案路徑
 *
 */

-(NSURL *)getDocumentPath;

/**
 * @brief 取得裝置目前國際設定語系
 * 
 * @return NSString.
 * 回傳裝置目前國際設定語系
 *
 */
-(NSString *)getCurrentLanguage;

/**
 * @brief 取得系統名稱 (去除空白字元)
 * 
 * @return NSString.
 * 回傳系統名稱
 *
 */
-(NSString *)getSystemNameTrimSpace;

/**
 * @brief 取得Project build 編號
 * 
 * @return NSString.
 * 回傳Project build 編號
 *
 */
-(NSString *)getAppBuild;

/**
 * @brief 取得Project版本號碼 (short)
 *
 * @return NSString.
 * 回傳Project版本編號 (short)
 *
 */
-(NSString *)getAppVersion;

/**
 * @brief 取得裝置UUID
 *
 * @return NSString.
 * 回傳裝置UUID
 *
 */
- (NSString *)getUUID;

#define kMHDeviceManager            [MHDeviceManager sharedInstance]
#define kWinSize                    [MHDeviceManager sharedInstance].winSize
#define kWinSizeWidth               [MHDeviceManager sharedInstance].winSize.width
#define kWinSizeHeight              [MHDeviceManager sharedInstance].winSize.height
#define kWinDeviceType              [MHDeviceManager sharedInstance].deviceType




@end
