//
//  ViewController.h
//  BluetoothUtil
//
//  Created by Bo-Rong on 2017/12/29.
//  Copyright © 2017年 Bo-Rong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MHToolKit_Framwork/MHToolKit_Framwork.h>

#import "UIView+Toast.h"

#import "BluetoothDeviceManager.h"

#define UIStatusBarHeight           20.0f
#define UINavigationBarHeight       64.0f

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BluetoothDeviceManagerDelegate>

{
    NSMutableArray *m_arrayTableViewData;
    
    UITableView *m_tableView;
    
}


@end

