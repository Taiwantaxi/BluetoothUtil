//
//  ViewController.m
//  BluetoothUtil
//
//  Created by Bo-Rong on 2017/12/29.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private init function

-(void)initData{
    
    [kBluetoothDeviceManager setDelegate:self];
    
}

-(void)initUI{
        
    [self.view setBackgroundColor:[UIColor whiteColor]];

    //標題
    CGSize sizeLabelTitle = CGSizeMake(rWidth(300), rHeight(30));
    UILabel *labelTitle = [[UILabel alloc] init];
    [labelTitle setFrame:CGRectMake((kWinSizeWidth - sizeLabelTitle.width) / 2.0f, UIStatusBarHeight + UINavigationBarHeight + rHeight(10), sizeLabelTitle.width, sizeLabelTitle.height)];
    [labelTitle setText:@"Discover BLE Device"];
    [labelTitle setFont:[UIFont systemFontOfSize:24]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:labelTitle];
    
    //Scan Button
    CGSize sizeBtn = CGSizeMake(rWidth(200), rHeight(36));
    UIButton *btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake((kWinSizeWidth - sizeBtn.width) / 2.0f, labelTitle.frame.origin.y + labelTitle.frame.size.height + rHeight(50), sizeBtn.width, sizeBtn.height)];
    [btn setBackgroundImage:[MHImageUtil imageFromColor:[UIColor grayColor] forSize:sizeBtn withCornerRadius:rWidth(10)] forState:UIControlStateNormal];
    [btn setTitle:@"Scan" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:rWidth(16)]];
    [btn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //TableView
    CGSize sizeTableView = CGSizeMake(kWinSizeWidth, kWinSizeHeight - btn.frame.origin.y - btn.frame.size.height - rHeight(100));
    m_tableView = [[UITableView alloc] init];
    [m_tableView setFrame:CGRectMake(0, btn.frame.origin.y + btn.frame.size.height + rHeight(50), sizeTableView.width, sizeTableView.height)];
    [m_tableView setDelegate:self];
    [m_tableView setDataSource:self];
    [m_tableView setBackgroundColor:[UIColor whiteColor]];
    [m_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.view addSubview:m_tableView];
    
}

#pragma mark - private action function

-(void)actionBtn:(id)sender{
    
    [self.view makeToast:@"Scan"];
    
    [kBluetoothDeviceManager scanBluetoothDevice];
    
}

#pragma mark - private function

-(BOOL)checkIndexVaildByIndex:(NSInteger)index withArray:(NSArray *)array{
    
    BOOL result = (index < array.count) ? YES : NO;
    
    return result;
    
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [m_arrayTableViewData count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"Mycell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
    }
    
    BluetoothDevice *device = [m_arrayTableViewData objectAtIndex: indexPath.row];

    //設備名稱
    if(device.peripheral.name){
        [cell.textLabel setText:device.peripheral.name];
    }else{
        [cell.textLabel setText:@"Unknow Device"];
    }
    
    //設備訊號強度
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd dBm", device.signalStrength];

    //設備連線狀態
    if(device.peripheral.state == CBPeripheralStateConnected){
        cell.imageView.image = [UIImage imageNamed:@"ConnectIcon"];
    }else {
        cell.imageView.image = [UIImage imageNamed:@"DisconnectIcon"];
    }
    
    return cell;
    
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self checkIndexVaildByIndex:indexPath.row withArray:m_arrayTableViewData]){
        
        BluetoothDevice *device = [[BluetoothDevice alloc] init];
        device = [m_arrayTableViewData objectAtIndex: indexPath.row];
        
        if(device.peripheral.state == CBPeripheralStateDisconnected){
            
            //連線藍牙設備
            [kBluetoothDeviceManager connectBluetoothDevice:device];
            
        }else if (device.peripheral.state == CBPeripheralStateConnected){
            
            //取消藍芽設備連線
            [kBluetoothDeviceManager disconnectBluetoothDevice:device];
            
        }
        
    }
    
}

#pragma mark - BluetoothDeviceManagerDelegate

-(void)getBluetoothDidUpdateState:(NSString *)string{
    
    [self.view makeToast:string];
    
}

-(void)getDiscoverPeripheral:(NSMutableArray *)arrayBluetoothDevice{
    
    m_arrayTableViewData = arrayBluetoothDevice;
    [m_tableView reloadData];
    
}

-(void)getConnectToPeripheralSuccess:(CBPeripheral *)peripherals{
    
    [self.view makeToast:@"Connect To Peripheral Success"];
    [m_tableView reloadData];
    
    [kBluetoothDeviceManager discoverServicesWithPeripheral:peripherals];
}

-(void)getFailToConnectPeripheral:(CBPeripheral *)peripheralctPeripheral{
    
    [self.view makeToast:@"Fail To Connect Peripheral"];
    [m_tableView reloadData];

}

-(void)getDisconnectToPeripheralFinish:(CBPeripheral *)peripheralnectToPeripheralFinish{
    
    [self.view makeToast:@"Disconnect To Peripheral Finish"];
    [m_tableView reloadData];
    
}

-(void)getDiscoverServices:(NSMutableArray *)arrayCBService withPeripheral:(CBPeripheral *)peripheral{
    
    for(CBService *service in arrayCBService){
        
        [self.view makeToast:[service.UUID description]];
        //計費器 service UUID = 0003CDD0-0000-1000-8000-00805F9B0131
        if([[service.UUID description] containsString:@"0003CDD0-0000-1000-8000-00805F9B0131"]){
            
            [kBluetoothDeviceManager startServiceDiscoverCharacteristic:service withPeripheral:peripheral];
            
        }
        
    }
    
}

-(void)getDiscoverCharacteristics:(NSMutableArray *)arrayCharacteristic withCBService:(CBService *)service withPeripheral:(CBPeripheral *)peripheral{
    
    for (CBCharacteristic *c in arrayCharacteristic){
        
        //計費器 Characteristic UUID = 0003CDD1-0000-1000-8000-00805F9B0131
        if([[c.UUID description] containsString:@"0003CDD1-0000-1000-8000-00805F9B0131"]){
            
            [self.view makeToast:[c description]];
            [kBluetoothDeviceManager readCharacteristic:c withService:service withPeripheral:peripheral];
            
        }
        
    }
    
}

-(void)getUpdateValueForCharacteristic:(NSData *)data{
    
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [self.view makeToast:result];
    
}

-(void)getCarMeterActivity{
    
    [self.view makeToast:@"藍牙車錶啟動"];
    
}

-(void)getCarMeterStartTiming{
    
    [self.view makeToast:@"藍牙車錶開始計費"];
    
}

-(void)getCarMeterEndPrice:(NSInteger)price{
    
    [self.view makeToast:[NSString stringWithFormat:@"本趟車資已結束，車資為%zd", price]];
    
}


@end
