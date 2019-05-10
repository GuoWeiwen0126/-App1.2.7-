//
//  DrawMacro.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/17.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#ifndef DrawMacro_h
#define DrawMacro_h

/*** 颜色相关 ***/
#define RGBA(r, g, b, a)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBHex(rgb)     [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF00))/255.0 alpha:1.0]
#define MAIN_RGB           RGBA( 60, 145, 249, 1.0)
#define MAIN_RGB_MainTEXT  RGBA( 51,  51,  51, 1.0)
#define MAIN_RGB_TEXT      RGBA(153, 153, 153, 1.0)
#define MAIN_RGB_LINE      RGBA(228, 228, 228, 1.0)
#define MAIN_RGB_LightLINE RGBA(247, 247, 247, 1.0)
//#define MAIN_RGB           RGBHexA(0X3c91f9,1.0)   //RGBA( 60, 145, 249, 1.0)
//#define MAIN_RGB_TEXT      RGBHexA(0X999999,1.0)   //RGBA(153, 153, 153, 1.0)
//#define MAIN_RGB_LINE      RGBHexA(0Xe4e4e4,1.0)   //RGBA(228, 228, 228, 1.0)
//夜间模式颜色
#define Night_RGB_Navigationbar RGBA( 19, 22, 31, 1.0)
#define Night_RGB_MainText      RGBA(255,255,255, 1.0)
#define Night_RGB_Text          RGBA(198,197,202, 1.0)
#define Night_RGB_BGColor       RGBA( 30, 30, 40, 1.0)

/*** Label字体大小 ***/
#define FontOfSize(a)      [UIFont systemFontOfSize:a]
#define FontOfSize_Bold(a) [UIFont boldSystemFontOfSize:a]
#define QLabelFont @"QLabelFont"  //做题界面字体大小

/*** View圆角和边框 ***/
#define VIEW_CORNER_RADIUS(View, Radius)                [View.layer setCornerRadius:(Radius)];\
                                                        [View.layer setMasksToBounds:YES];
#define VIEW_BORDER_RADIUS(View, Bgcolor, Radius, Width, BorderColor)   [View setBackgroundColor:Bgcolor];\
                                                                        [View.layer setCornerRadius:(Radius)];\
                                                                        [View.layer setMasksToBounds:YES];\
                                                                        [View.layer setBorderWidth:(Width)];\
                                                                        [View.layer setBorderColor:[BorderColor CGColor]];


#endif /* DrawMacro_h */
