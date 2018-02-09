//
//  BluetoothDeviceManager.m
//  BluetoothUtil
//
//  Created by Bo-Rong on 2017/12/29.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import "BluetoothDeviceManager.h"

static BluetoothDeviceManager *instance = nil;
@implementation BluetoothDeviceManager

-(instancetype)init{
    
    self = [super init];
    
    if(self){
        
        [self initData];
        
    }
    
    return self;
    
}


#pragma mark - private init function

-(void)initData{
    
    //初始化 CBCentralManager
    //將啟動 CBCentralManagerDelegate Method 監控中心藍牙狀態 -> centralManagerDidUpdateState
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.arrayBluetoothDevice = [[NSMutableArray alloc] init];
    self.arrayCBService = [[NSMutableArray alloc] init];
    self.arrayCharacteristic = [[NSMutableArray alloc] init];
}

#pragma mark - public function

+(BluetoothDeviceManager *)sharedInstance{
    
    @synchronized ([BluetoothDeviceManager class]) {
        if(!instance){
            
            instance = [[self alloc] init];
            
        }
        return instance;
    }
    
    return nil;
    
}

-(void)scanBluetoothDevice{
    
    //搜尋藍牙設備
    //將啟動 CBCentralManagerDelegate Method 搜尋到的藍牙設備-> didDiscoverPeripheral
    [self resetBluetoothManagerData];
    [self.CM scanForPeripheralsWithServices:nil options:nil];
    
    [self performSelector:@selector(scanTimeout) withObject:nil afterDelay:3.0f];
    
}

-(void)connectBluetoothDevice:(BluetoothDevice *) device{
    
    //連線到藍牙設備
    //將啟動 CBCentralManagerDelegate Method 成功連線到設備 -> didConnectPeripheral
    //將啟動 CBCentralManagerDelegate Method 無法連線設備 -> didFailToConnectPeripheral
    [self.CM connectPeripheral:device.peripheral options:nil];
    
}

-(void)disconnectBluetoothDevice:(BluetoothDevice *)device{
    
    //取消藍牙設備連線
    //將啟動 CBCentralManagerDelegate Method 到取消設備連線 -> didDisconnectPeripheral
    [self.CM cancelPeripheralConnection:device.peripheral];

}

-(void)discoverServicesWithPeripheral:(CBPeripheral *)peripheral{
    
    //搜尋該設備提供的服務
    //將啟動 CBPeripheralDelegate Method 取得設備可能提供的服務 -> didDiscoverServices
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
}

-(void)startServiceDiscoverCharacteristic:(CBService *)service withPeripheral:(CBPeripheral *)peripheral{

    //搜尋特定服務的屬性
    //將啟動 CBPeripheralDelegate Method 取得服務可能提供的特徵 -> didDiscoverCharacteristicsForService
    [peripheral discoverCharacteristics:nil forService:service];
}

-(void)readCharacteristic:(CBCharacteristic *)characteristic withService:(CBService *)service withPeripheral:(CBPeripheral *)peripheral{
    
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];

    //讀取該特徵值
    //將啟動 CBPeripheralDelegate Method 取得服務可能提供的屬性 -> didUpdateValueForCharacteristic
    [peripheral readValueForCharacteristic:characteristic];

}


#pragma mark - private function

-(void)scanTimeout{
    
    //停止搜尋藍牙設備
    [self.CM stopScan];
    
}

-(void)resetBluetoothManagerData{
    
    [self.arrayBluetoothDevice removeAllObjects];
    [self.arrayCBService removeAllObjects];
    [self.arrayCharacteristic removeAllObjects];
    
}

-(BOOL)checkNotRepeatForDevice:(BluetoothDevice *)device withArrayBluetoothDevice:(NSMutableArray *)arrayDevice{
    
    BOOL result = YES;
    
    for(NSInteger i = 0; i < arrayDevice.count; i++){
        
        BluetoothDevice *BLE = [arrayDevice objectAtIndex:i];
        
        if(BLE.peripheral.identifier == device.peripheral.identifier){
            
            result =  NO;
            
        }
        
    }
    
    return result;
}

-(void)readBluetoothDataHandler:(NSData *)data{
    
    NSLog(@"%s", __FUNCTION__);
    
    if(self.bluetoothStreamData){
        
        if(self.bluetoothStreamData.complete){
            
            //上ㄧ包封包已是完整封包 重新New一個
            self.bluetoothStreamData = nil;
            self.bluetoothStreamData = [[BluetoothStreamData alloc] initWithData:data];
            
        }else{
            
            //上一個封包 非完整封包 繼續加入資料
            [self.bluetoothStreamData updateData:data withIsInitial:NO];
            
        }
        
    }else{
        
        self.bluetoothStreamData = [[BluetoothStreamData alloc] initWithData:data];
        
    }
    
    if(!self.bluetoothStreamData.complete){
        //非完整封包
        
        
    }else{
        
        //更新完資料後為完整封包
        
        Byte BluetoothAPIFunction1 = 0xc1;  //按下空白鍵       (輸出計費表最後一次載客紀錄資料)
        Byte BluetoothAPIFunction2 = 0xc2;  //按下計程計時鍵    (輸出計費表當前狀態資料)
        Byte BluetoothAPIFunction3 = 0xb4;  //按下列印鍵       (輸出計費表每趟結束後載客資料)

        if([self.bluetoothStreamData.dataDocumentId isEqualToData:[NSData dataWithBytes:&BluetoothAPIFunction1 length:sizeof(BluetoothAPIFunction1)]]){
            
            NSLog(@" Find 0xc1 ");
            
            if(self.delegate){
                if([self.delegate respondsToSelector:@selector(getCarMeterActivity)]){
                    [self.delegate getCarMeterActivity];
                }
            }
            
            //待撰寫
            
        }else if([self.bluetoothStreamData.dataDocumentId isEqualToData:[NSData dataWithBytes:&BluetoothAPIFunction2 length:sizeof(BluetoothAPIFunction2)]]){
            
            NSLog(@" Find 0xc2 ");
            
            if(self.delegate){
                if([self.delegate respondsToSelector:@selector(getCarMeterStartTiming)]){
                    [self.delegate getCarMeterStartTiming];
                }
            }
            //待撰寫
            
        }else if([self.bluetoothStreamData.dataDocumentId isEqualToData:[NSData dataWithBytes:&BluetoothAPIFunction3 length:sizeof(BluetoothAPIFunction3)]]){
            
            NSLog(@" Find 0xb4 ");
            
            //解析車資
            NSInteger metterPrice = -1;
            metterPrice = [self getCarMeterPrice:self.bluetoothStreamData.dataBody];
            
            if(self.delegate){
                if([self.delegate respondsToSelector:@selector(getCarMeterEndPrice:)]){
                    [self.delegate getCarMeterEndPrice:metterPrice];
                }
            }
            
        }else{
            
            NSLog(@"Not define this function");
            
        }
        
    }
    
    
}

-(NSInteger)getCarMeterPrice:(NSMutableData *) data{
    
    //依規格，車資為 28..29 bit
    NSRange rangeData = NSMakeRange(28, 2);
    NSData *dataTarget = [data subdataWithRange:rangeData];
    
    return dataTarget.hash;
    
}

#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    //目前中心藍牙狀態
    
    NSMutableString *nsmstring = [NSMutableString stringWithString:@"BluetoothState "];
    BOOL isWork = NO;
    
    switch (central.state) {
        case CBManagerStateUnknown:
            [nsmstring appendString:@"Unknown"];
            break;
            
        case CBManagerStateUnsupported:
            [nsmstring appendString:@"Unsupported"];
            break;
            
        case CBManagerStateUnauthorized:
            [nsmstring appendString:@"Unauthorized"];
            break;
            
        case CBManagerStateResetting:
            [nsmstring appendString:@"Resetting"];
            break;
        
        case CBManagerStatePoweredOff:
            [nsmstring appendString:@"PoweredOff"];
            break;
            
        case CBManagerStatePoweredOn:
            [nsmstring appendString:@"PoweredOn"];
            isWork = YES;
            break;
            
        default:
            [nsmstring appendString:@"none"];
            break;
            
    }
    
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getBluetoothDidUpdateState:)]){
            [self.delegate getBluetoothDidUpdateState:nsmstring];
        }
    }
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    //取得搜尋到的 BLE Devices
    
    BluetoothDevice *device = [[BluetoothDevice alloc] init];
    
    [device updata:peripheral withAdvertisementData:advertisementData withSingalStrength:RSSI];
    
    if([self checkNotRepeatForDevice:device withArrayBluetoothDevice:self.arrayBluetoothDevice]){
        [self.arrayBluetoothDevice addObject:device];
    }
    
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getDiscoverPeripheral:)]){
            [self.delegate getDiscoverPeripheral:self.arrayBluetoothDevice];
        }
    }
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    //成功連線到設備
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getConnectToPeripheralSuccess:)]){
            [self.delegate getConnectToPeripheralSuccess:peripheral];
        }
    }
    
    
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    //無法連線到設備
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getFailToConnectPeripheral:)]){
            [self.delegate getFailToConnectPeripheral:peripheral];
        }
    }
    
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    //取消藍牙設備連線完成
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getDisconnectToPeripheralFinish:)]){
            [self.delegate getDisconnectToPeripheralFinish:peripheral];
        }
    }
    
}

#pragma mark - CBPeripheralDelegate

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    //發現連接設備可能提供哪些服務
    
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getDiscoverServices:withPeripheral:)]){
            
            [self.arrayCBService removeAllObjects];
            [self.arrayCBService setArray:peripheral.services];
            [self.delegate getDiscoverServices:self.arrayCBService withPeripheral:peripheral];
            
        }
    }
    
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    //發現服務可能提供的特徵
    
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getDiscoverCharacteristics:withCBService:withPeripheral:)]){
            
            [self.arrayCharacteristic removeAllObjects];
            [self.arrayCharacteristic setArray:service.characteristics];
            [self.delegate getDiscoverCharacteristics:self.arrayCharacteristic withCBService:service withPeripheral:peripheral];
            
        }
    }
    
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    //收到最新的特徵值資料
    NSLog(@"%s, bluetoothData = %@", __FUNCTION__, [characteristic description]);
    
    NSData *sensorData = [characteristic value];
    
    if(sensorData){
        
        [self readBluetoothDataHandler:sensorData];
        
    }
    
    /*
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(getUpdateValueForCharacteristic:)]){
            [self.delegate getUpdateValueForCharacteristic:sensorData];
        }
    }
    */
}
@end
