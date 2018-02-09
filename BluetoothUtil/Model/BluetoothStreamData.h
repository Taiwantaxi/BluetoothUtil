//
//  BluetoothStreamData.h
//  BluetoothUtil
//
//  Created by Bo-Rong on 2018/1/3.
//  Copyright © 2018年 Bo-Rong. All rights reserved.
//

#import <Foundation/Foundation.h>

//參考電文格式
typedef NS_ENUM(NSInteger, BluetoothStreamDataType) {
    
    BluetoothStreamDataType_Header,
    BluetoothStreamDataType_DocumentId,
    BluetoothStreamDataType_BodyLength,
    BluetoothStreamDataType_Body,
    BluetoothStreamDataType_Footer,
    
    BluetoothStreamDataType_Max,
    
};

typedef NS_ENUM(NSInteger, BluetoothStreamDataStructType) {
    
    BluetoothStreamDataStructType_Complete,     //完整整包 (有頭有尾)
    BluetoothStreamDataStructType_HalfStart,    //半包開頭 (有頭沒尾)
    BluetoothStreamDataStructType_HalfEnd,      //半包結尾 (沒頭有尾)
    BluetoothStreamDataStructType_Half,         //純半包   (沒頭沒尾)
    
};

@interface BluetoothStreamData : NSObject

/**
 * @brief 封包頭
 */
@property (nonatomic, strong) NSMutableData *dataHeader;

/**
 * @brief 電文編號
 */
@property (nonatomic, strong) NSMutableData *dataDocumentId;

/**
 * @brief Body Length
 */
@property (nonatomic, retain) NSMutableData *dataBodyLength;

/**
 * @brief Body
 */
@property (nonatomic, strong) NSMutableData *dataBody;

/**
 * @brief 封包尾
 */
@property (nonatomic, strong) NSMutableData *dataFooter;

/**
 * @brief Body長度
 */
@property (nonatomic) int lengthBody;

/**
 * @brief 是否完成
 */
@property (nonatomic) BOOL complete;

/**
 * @brief 封包類型，請參考 BluetoothStreamDataStructType
 */
@property (nonatomic) BluetoothStreamDataStructType structType;

#pragma mark - public init function

/**
 * @brief 自定義 初始化 Function
 * 該Function super init, 後將會執行 updateData:withIsInitial: (isInitial帶入 YES)
 * 
 * @param data
 * 初始化解析目標
 * 
 * @return instancetype
 */
-(instancetype)initWithData:(NSData *)data;

#pragma mark - public function

/**
 * @brief 自定義 初始化 Function
 * 該Function super init, 後將會執行 updateData:withIsInitial: (isInitial帶入 YES)
 *
 * @param data
 * 解析目標
 * 
 * @param isInitial
 * 是否為開頭封包
 * 
 * @return void 
 *
 */
-(void)updateData:(NSData *)data withIsInitial:(BOOL)isInitial;

#define kBLUETOOTH_DATA_LENGTH_HEADER                   1
#define kBLUETOOTH_DATA_LENGTH_DOCUMENT_ID              1
#define kBLUETOOTH_DATA_LENGTH_BODY                     4
#define kBLUETOOTH_DATA_LENGTH_FOOTER                   2

#define kBLUETOOTH_DATA_HEX_HEADER                      0x02
#define kBLUETOOTH_DATA_HEX_FOOTER                      0x03 0x10



@end
