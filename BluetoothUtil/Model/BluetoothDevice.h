//
//  BluetoothDevice.h
//  BluetoothDemo
//
//  Created by Bo-Rong on 2017/9/21.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface BluetoothDevice : NSObject

/**
 * @brief 設備實體
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 * @brief 詳細資訊
 */
@property (nonatomic, strong) NSDictionary *dicAdvertisementData;

/**
 * @brief 訊號強度
 */
@property (nonatomic) NSInteger signalStrength;

#pragma mark - public Method

-(void) updata :(CBPeripheral *)peripheral withAdvertisementData : (NSDictionary *) advertisementData withSingalStrength : (NSNumber *) RSSI;


@end
