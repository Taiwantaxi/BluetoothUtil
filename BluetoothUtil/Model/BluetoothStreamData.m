//
//  BluetoothStreamData.m
//  BluetoothUtil
//
//  Created by Bo-Rong on 2018/1/3.
//  Copyright © 2018年 Bo-Rong. All rights reserved.
//

#import "BluetoothStreamData.h"

@implementation BluetoothStreamData


-(instancetype)init{
    
    self = [super init];
    
    if(self){
        [self initData];
    }
    return self;
    
}

#pragma mark - private init function

-(void)initData{
    
    self.dataHeader = [[NSMutableData alloc] init];
    
    self.dataDocumentId = [[NSMutableData alloc] init];
    
    self.dataBodyLength = [[NSMutableData alloc] init];
    
    self.dataBody = [[NSMutableData alloc] init];
    
    self.dataFooter = [[NSMutableData alloc] init];
    
}


#pragma mark - public init function

-(instancetype)initWithData:(NSData *)data{
    
    self = [self init];
    if(self){
        
        [self updateData:data withIsInitial:YES];
        
    }
    return self;
    
}

#pragma mark - public function

-(void)updateData:(NSData *)data withIsInitial:(BOOL)isInitial{
    
    NSLog(@"%s, isInitial = %d", __FUNCTION__, isInitial);
    
    BluetoothStreamDataType type = 0;
    
    if(isInitial){
        
        //目前封包Index
        NSInteger byteIndex = 0;
        
        for(NSInteger i = BluetoothStreamDataType_Header; i < BluetoothStreamDataType_Max; i++){
            
            type = i;
            NSInteger lengthTargetData = [self getLengthByType:type];
            NSInteger lengthAlreadyGetData = [self getCurrentDataLengthWithType:type];
            NSInteger lengthNeedToGetData = lengthTargetData - lengthAlreadyGetData;
            NSInteger lengthCurrentData = data.length;
            
            if(lengthAlreadyGetData < lengthTargetData){
                //封包尚未填滿

                NSInteger lengthRestData = lengthCurrentData - byteIndex; //剩餘封包長度
                
                if(lengthRestData < lengthNeedToGetData){
                    
                    //若剩餘封包長度不夠
                    NSRange rangeData = NSMakeRange(byteIndex, lengthRestData);
                    byteIndex += lengthRestData;
                    NSData *dataShouldBeAppend = [data subdataWithRange:rangeData];
                    NSMutableData *dataTarget = [self getDataByType: type];
                    [dataTarget appendData: dataShouldBeAppend];
                    
                    //跳出迴圈，資料無法填滿為起始半包
                    self.structType = BluetoothStreamDataStructType_HalfStart;
                    
                    break;

                    
                }else{
                    
                    //若資料長度夠
                    NSRange rangeData = NSMakeRange(byteIndex, lengthNeedToGetData);
                    byteIndex += lengthNeedToGetData;
                    NSData *dataShouldBeAppend = [data subdataWithRange:rangeData];
                    NSMutableData *dataTarget = [self getDataByType: type];
                    [dataTarget appendData: dataShouldBeAppend];
                    
                }
                
            }else{
                
                //封包已填滿
                
            }
            
            //取得Body長度
            if(type == BluetoothStreamDataType_BodyLength){
                self.lengthBody = [self returnByteLengthByData:self.dataBodyLength];
            }
            
            
        }
        
    }else{
        
        //目前封包Index
        NSInteger byteIndex = 0;

        for(NSInteger i = BluetoothStreamDataType_Header; i < BluetoothStreamDataType_Max; i++){
            
            type = i;
            NSInteger lengthTargetData = [self getLengthByType:type];
            NSInteger lengthAlreadyGetData = [self getCurrentDataLengthWithType:type];
            NSInteger lengthNeedToGetData = lengthTargetData - lengthAlreadyGetData;
            NSInteger lengthCurrentData = data.length;
            
            if(lengthAlreadyGetData < lengthTargetData){
                //封包尚未填滿
                
                NSInteger lengthRestData = lengthCurrentData - byteIndex; //剩餘封包長度
                
                if(lengthRestData < lengthNeedToGetData){
                    
                    //若剩餘封包長度不夠
                    NSRange rangeData = NSMakeRange(byteIndex, lengthRestData);
                    byteIndex += lengthRestData;
                    NSData *dataShouldBeAppend = [data subdataWithRange:rangeData];
                    NSMutableData *dataTarget = [self getDataByType: type];
                    [dataTarget appendData: dataShouldBeAppend];
                    
                    //跳出迴圈，資料無法填滿為純半包
                    self.structType = BluetoothStreamDataStructType_Half;
                    
                    break;
                    
                    
                }else{
                    
                    //若資料長度夠
                    NSRange rangeData = NSMakeRange(byteIndex, lengthNeedToGetData);
                    byteIndex += lengthNeedToGetData;
                    NSData *dataShouldBeAppend = [data subdataWithRange:rangeData];
                    NSMutableData *dataTarget = [self getDataByType: type];
                    [dataTarget appendData: dataShouldBeAppend];
                    
                    if(type == BluetoothStreamDataType_Footer){
                        self.structType = BluetoothStreamDataStructType_HalfEnd;
                        
                        //如果長度相同
                        self.structType = BluetoothStreamDataStructType_Complete;
                        self.complete = YES;
                    }
                    
                    
                }
                
            }else{
                
                //封包已填滿
                
            }
            
            
            
        }
        
    }
    
    
    
}

#pragma mark - private function

- (NSMutableData *)getDataByType:(BluetoothStreamDataType)type{
    
    NSMutableData *result = nil;
    
    if(type == BluetoothStreamDataType_Header){
        
        result = self.dataHeader;
        
    }else if (type == BluetoothStreamDataType_DocumentId){
        
        result = self.dataDocumentId;
        
    }else if (type == BluetoothStreamDataType_BodyLength){
        
        result = self.dataBodyLength;
        
    }else if (type == BluetoothStreamDataType_Body){
        
        result = self.dataBody;
        
    }else if (type == BluetoothStreamDataType_Footer){
        
        result = self.dataFooter;
        
    }
    
    return result;
    
}

- (NSInteger)getCurrentDataLengthWithType:(BluetoothStreamDataType)type{
    
    NSInteger result = 0;
    
    if(type == BluetoothStreamDataType_Header){
        
        result = self.dataHeader.length;
        
    }else if (type == BluetoothStreamDataType_DocumentId){
        
        result = self.dataDocumentId.length;
        
    }else if (type == BluetoothStreamDataType_BodyLength){
        
        result = self.dataBodyLength.length;
        
    }else if (type == BluetoothStreamDataType_Body){
        
        result = self.dataBody.length;
        
    }else if (type == BluetoothStreamDataType_Footer){
        
        result = self.dataFooter.length;
        
    }
    
    return result;
    
}

- (NSInteger)getLengthByType:(BluetoothStreamDataType)type{
    
    NSInteger result = 0;
    
    if(type == BluetoothStreamDataType_Header){
        
        result = kBLUETOOTH_DATA_LENGTH_HEADER;
        
    }else if(type == BluetoothStreamDataType_DocumentId){
        
        result = kBLUETOOTH_DATA_LENGTH_DOCUMENT_ID;
        
    }else if (type == BluetoothStreamDataType_BodyLength){
        
        result = kBLUETOOTH_DATA_LENGTH_BODY;
        
    }else if (type == BluetoothStreamDataType_Body){
        
        result = self.lengthBody;
        
    }else if (type == BluetoothStreamDataType_Footer){
        
        result = kBLUETOOTH_DATA_LENGTH_FOOTER;
        
    }
    
    return result;
    
}

- (int)returnByteLengthByData:(NSMutableData *)data{
    
    return (int)[data hash];
    
}

- (NSInteger)getCurrentTotalByte{
    
    return self.dataHeader.length + self.dataDocumentId.length + self.dataBodyLength.length + self.dataBody.length + self.dataFooter.length;
    
}

@end
