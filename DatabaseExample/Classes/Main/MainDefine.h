//
//  MainDefine.h
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#ifndef MainDefine_h
#define MainDefine_h

#ifdef DEBUG
#define DebugLog(...)   NSLog(__VA_ARGS__)
#elif
#define DebugLog(...)
#endif

#define MainAlertMsg(msg)                   {UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];[alert show];}
#define Color_RGB(r, g, b)                  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define Color_Random                        Color_RGB(arc4random()%256, arc4random()%256, arc4random()%256)

//间距
#define SPACING     8.0
//屏幕的范围
#define MainScreen_Bounds                   [UIScreen mainScreen].bounds
//屏幕的宽
#define MainScreen_Width                    MainScreen_Bounds.size.width
//屏幕的高
#define MainScreen_Height                   MainScreen_Bounds.size.height

//通知中心
#define Notification_Default_Center         [NSNotificationCenter defaultCenter]

#define AddStudentNotifiction               @"AddStudentNotification"
#define DeleteStudentNotifiction               @"DeleteStudentNotification"
#define ChangeStudentNotifiction               @"ChangeStudentNotification"


#endif /* MainDefine_h */
