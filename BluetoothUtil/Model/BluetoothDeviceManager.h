//
//  BluetoothDeviceManager.h
//  BluetoothUtil
//
//  Created by Bo-Rong on 2017/12/29.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import "BluetoothDevice.h"

#import "BluetoothStreamData.h"

#define kBluetoothDeviceManager                 [BluetoothDeviceManager sharedInstance]

@protocol BluetoothDeviceManagerDelegate <NSObject>

@optional

/**
 * @brief 收到手機藍牙狀態變更
 */
-(void)getBluetoothDidUpdateState:(NSString *) string;

/**
 * @brief 收到發現的藍牙設備
 */
-(void)getDiscoverPeripheral:(NSMutableArray *) arrayBluetoothDevice;

/**
 * @brief 收到藍牙設備連線成功
 */
-(void)getConnectToPeripheralSuccess:(CBPeripheral *) peripheral;

/**
 * @brief 收到取消藍牙設備連線完成
 */
-(void)getDisconnectToPeripheralFinish:(CBPeripheral *) peripheral;

/**
 * @brief 收到藍牙設備連線失敗
 */
-(void)getFailToConnectPeripheral:(CBPeripheral *) peripheral;

/**
 * @brief 收到藍牙設備所有提供的服務項目
 */
-(void)getDiscoverServices:(NSMutableArray *) arrayCBService withPeripheral:(CBPeripheral *) peripheral;

/**
 * @brief 收到藍牙設備特定服務的所有特徵項目
 */
-(void)getDiscoverCharacteristics:(NSMutableArray *)arrayCharacteristic withCBService:(CBService *) service withPeripheral:(CBPeripheral *) peripheral;

/**
 * @brief 收到讀取的特徵值資料
 */
-(void)getUpdateValueForCharacteristic:(NSData *) data;

/**
 * @brief 收到車錶啟動
 */
-(void)getCarMeterActivity;

/**
 * @brief 收到車錶開始計時
 */
-(void)getCarMeterStartTiming;

/**
 * @brief 收到車錶結束車資
 */
-(void)getCarMeterEndPrice:(NSInteger) price;

@end


@interface BluetoothDeviceManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

/**
 * @brief BluetoothDeviceManager Delegate 對象
 */
@property (nonatomic, strong) id<BluetoothDeviceManagerDelegate> delegate;

/**
 * @brief 目前發現的藍牙設備
 */
@property (nonatomic, strong) NSMutableArray *arrayBluetoothDevice;

/**
 * @brief 目前連線藍牙設備所有提供的服務
 */
@property (nonatomic, strong) NSMutableArray *arrayCBService;

/**
 * @brief 目前藍牙設備服務的所有特徵
 */
@property (nonatomic, strong) NSMutableArray *arrayCharacteristic;

/**
 * @brief Bluetooth 中心
 */
@property (nonatomic, strong) CBCentralManager *CM;

/**
 * @brief Bluetooth Stream 資料
 */
@property (nonatomic, strong) BluetoothStreamData *bluetoothStreamData;

#pragma mark - public function

+(BluetoothDeviceManager *)sharedInstance;

/**
 * @brief 搜尋藍牙設備
 */
-(void)scanBluetoothDevice;

/**
 * @brief 連線到藍牙設備
 */
-(void)connectBluetoothDevice:(BluetoothDevice *) device;

/**
 * @brief 取消藍牙設備連線
 */
-(void)disconnectBluetoothDevice:(BluetoothDevice *) device;

/**
 * @brief 搜尋藍牙設備的提供服務
 */
-(void)discoverServicesWithPeripheral:(CBPeripheral *) peripheral;

/**
 * @brief 啟動藍牙設備的服務搜尋所有特徵值
 */
-(void)startServiceDiscoverCharacteristic:(CBService *) service withPeripheral:(CBPeripheral *) peripheral;

/**
 * @brief 讀取藍牙設備的特徵值
 */
-(void)readCharacteristic:(CBCharacteristic *) characteristic withService:(CBService *) service withPeripheral:(CBPeripheral *) peripheral;



@end
