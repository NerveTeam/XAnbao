//
//  Basic.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/22.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#ifndef Basic_h
#define Basic_h

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#define HKControllerViewWidth         self.view.frame.size.width
#define HKControllerViewHeight        self.view.frame.size.height

#define HKViewWidth                   self.frame.size.width
#define HKViewHeight                  self.frame.size.height


#define kNavBarHeight 64.0
#define kBottomBarHeight 49.0
#define TTagNull -1

#define HKUIColorC1            [CJCommonit setColorWithInt: 0x312f2a]
#define HKUIColorC2            [CJCommonit setColorWithInt: 0x6d6d6d]
#define HKUIColorC3            [CJCommonit setColorWithInt: 0xffffff]
#define HKUIColorC4            [CJCommonit setColorWithInt: 0xaf1700]
#define HKUIColorC5            [CJCommonit setColorWithInt: 0xf7f3ad]
#define HKUIColorC6            [CJCommonit setColorWithInt: 0xdfdfdf]
#define HKUIColorC7            [CJCommonit setColorWithInt: 0x777777]
#define HKUIColorC8            [CJCommonit setColorWithInt: 0xfeb4a9]
#define HKUIColorC9            [CJCommonit setColorWithInt: 0xaf2559]
#define HKUIColorC10           [CJCommonit setColorWithInt: 0xde8181]
#define HKUIColorC11           [CJCommonit setColorWithInt: 0x64ccf6]
#define HKUIColorC12           [CJCommonit setColorWithInt: 0xaad71f]
#define HKUIColorC13           [CJCommonit setColorWithInt: 0xff0000]
#define HKUIColorC14           [CJCommonit setColorWithInt: 0xf8f8f8]
#define HKUIColorC15           [CJCommonit setColorWithInt: 0xf5f4e7]
#define HKUIColorC16           [CJCommonit setColorWithInt: 0xedead8]
#define HKUIColorC17           [CJCommonit setColorWithInt: 0xfe71a2]
#define HKUIColorC18           [CJCommonit setColorWithInt: 0xececec]
#define HKUIColorC19           [CJCommonit setColorWithInt: 0xbdbdbd]
#define HKUIColorC20           [CJCommonit setColorWithInt: 0xacacac]
#define HKUIColorC21           [CJCommonit setColorWithInt: 0x29b6fd]
#define HKUIColorC22           [CJCommonit setColorWithInt: 0x92db2c]
#define HKUIColorC23           [CJCommonit setColorWithInt: 0x8f9299]
#define HKUIColorC24           [CJCommonit setColorWithInt: 0xdde0e5]
#define HKUIColorC25           [CJCommonit setColorWithInt: 0xc9c9c9]
#define HKUIColorC26           [CJCommonit setColorWithInt: 0x000000]


#define HKUISystemFontT1        [UIFont systemFontOfSize: 1]
#define HKUISystemFontT2        [UIFont systemFontOfSize: 2]
#define HKUISystemFontT3        [UIFont systemFontOfSize: 3]
#define HKUISystemFontT4        [UIFont systemFontOfSize: 4]
#define HKUISystemFontT5        [UIFont systemFontOfSize: 5]
#define HKUISystemFontT6        [UIFont systemFontOfSize: 6]
#define HKUISystemFontT7        [UIFont systemFontOfSize: 7]
#define HKUISystemFontT8        [UIFont systemFontOfSize: 8]
#define HKUISystemFontT9        [UIFont systemFontOfSize: 9]
#define HKUISystemFontT10       [UIFont systemFontOfSize: 10]
#define HKUISystemFontT11       [UIFont systemFontOfSize: 11]
#define HKUISystemFontT12       [UIFont systemFontOfSize: 12]
#define HKUISystemFontT13       [UIFont systemFontOfSize: 13]
#define HKUISystemFontT14       [UIFont systemFontOfSize: 14]
#define HKUISystemFontT15       [UIFont systemFontOfSize: 15]
#define HKUISystemFontT16       [UIFont systemFontOfSize: 16]
#define HKUISystemFontT17       [UIFont systemFontOfSize: 17]
#define HKUISystemFontT18       [UIFont systemFontOfSize: 18]
#define HKUISystemFontT19       [UIFont systemFontOfSize: 19]
#define HKUISystemFontT20       [UIFont systemFontOfSize: 20]


#define HKUISystemFontT1H        [HKCommonUtil getFontHeight: HKUISystemFontT1]
#define HKUISystemFontT2H        [HKCommonUtil getFontHeight: HKUISystemFontT2]
#define HKUISystemFontT3H        [HKCommonUtil getFontHeight: HKUISystemFontT3]
#define HKUISystemFontT4H        [HKCommonUtil getFontHeight: HKUISystemFontT4]
#define HKUISystemFontT5H        [HKCommonUtil getFontHeight: HKUISystemFontT5]
#define HKUISystemFontT6H        [HKCommonUtil getFontHeight: HKUISystemFontT6]
#define HKUISystemFontT7H        [HKCommonUtil getFontHeight: HKUISystemFontT7]
#define HKUISystemFontT8H        [HKCommonUtil getFontHeight: HKUISystemFontT8]
#define HKUISystemFontT9H        [HKCommonUtil getFontHeight: HKUISystemFontT9]
#define HKUISystemFontT10H       [HKCommonUtil getFontHeight: HKUISystemFontT10]
#define HKUISystemFontT11H       [HKCommonUtil getFontHeight: HKUISystemFontT11]
#define HKUISystemFontT12H       [HKCommonUtil getFontHeight: HKUISystemFontT12]
#define HKUISystemFontT13H       [HKCommonUtil getFontHeight: HKUISystemFontT13]

#define HKUISystemFontCommonH    [HKCommonUtil getFontHeight: HKUISystemFontT7]



#define THalfTime  0.5
#define TOneThird 1.f / 3.f
#define TOneFour 1.f / 4.f

#define TFourthTime 0.25
#define TFifth  1.f / 5.f
#define TSixfh 1.f / 6.f
#define TSevenfh 1.f / 7.f
#define TEightfh 1.f / 8.f
#define TNinth   1.f / 9.f
#define TTenfh 1.f / 10.f
#define TEleventh 1.f / 11.f
#define TTwelfth 1.f / 12.f

#define TOneAndHalf 1.5
#define TTwoTime 2
#define TTwoOrTwoTime 2.2
#define TTwoAndHalf 2.5
#define TTwoOrSixTime 2.6
#define TTwoOrSevenTime 2.7
#define TTwoOrEightTime 2.8
#define TThreeTime 3
#define TThreeAndHalf 3.5
#define TThreeOrSevenTime 3.7
#define TFourTime 4
#define FourAndHalf 4.5
#define TFiveTime 5
#define TSixTime 6
#define TTenTime 10

#define TScaleDoneButtonBorderWidth    1
#define TScaleDoneButtonBorderHeight   5
#define TScaleCenterWorH  [HKResource scaleCenterWorH]

#define HKZero 0
#define HKOne  1
#define HKTwo  2
#define HKThree 3
#define HKFour 4
#define HKFive 5
#define HKSeven 7
#define HKEight 8
#define HKTen   10
//*********************lixiang*******************************

//将屏幕高度宽度进行等分
#define kScreenHeight_2 (kScreenHeight/2)
#define kScreenHeight_3 (kScreenHeight/3)
#define kScreenHeight_4 (kScreenHeight/4)
#define kScreenHeight_5 (kScreenHeight/5.5)
#define kScreenHeight_6 (kScreenHeight/6.5)
#define kScreenHeight_8 (kScreenHeight/8)
#define kScreenHeight_10 (kScreenHeight/10)
#define kScreenHeight_16 (kScreenHeight/16)
#define kScreenHeight_32 (kScreenHeight/32)

#define kScreenWidth_2 (kScreenWidth/2)
#define kScreenWidth_3 (kScreenWidth/3)
#define kScreenWidth_4 (kScreenWidth/4)
#define kScreenWidth_5 (kScreenWidth/5)
#define kScreenWidth_10 (kScreenWidth/10)
#define kScreenWidth_16 (kScreenWidth/16)
#define kScreenWidth_18 (kScreenWidth/18)

//时间
#define kDaysNumberOfOneWeek 7
#define kOneMinuteTimeInterval (60.0)
#define kOneHourTimeInterval (60*kOneMinuteTimeInterval)
#define kEightHourTimeInterval (8*kOneHourTimeInterval)
#define kOneDayTimeInterval (24*kOneHourTimeInterval)
#define kOneWeekTimeInterval (7*kOneDayTimeInterval)
#define kPregnancyDurationTimeInterval (280*kOneDayTimeInterval)
#define kPregnancyWeekNumber 40
#define kOneYearTimeInterval (365*kOneDayTimeInterval)
#define kThreeYearTimeInterval 365 * 3
//半径
#define kRadius (kScreenWidth*1.5/2)
#define kRadiusPlus2 (kScreenWidth*1.5)

//体重
#define kLineDiagramTextWidth 30
#define kLineDiagramTextHeight 20
#define kLineDiagramXCoordinateTextWidth 40
#define kViewTopMargin 20
#define kViewBottomMargin 20
#define kLineDiagramPointRadius 10
#define kLineDiagramScrollViewLeftMargin 30.0
#define kLineDiagramScrollViewRightMargin 20
#define kXCoordinateMomInterval 74.6
#define kXCoordinateBabyInterval 320
#define kXCoordinateIntervalPerDay 70    //按次绘制曲线每天的长度

//柱状图
#define kHistogramTopMargin 10
#define kHistogramBottomMargin 15
#define kHistogramLeftMargin 30
#define kHistogramRightMargin 8
#define kHistogramYLineNumber 9
#define kHistogramTextWidth 30
#define kHistogramTextHeight 15
#define kHistogramXCoordinateLeftMargin 20
#define kHistogramXCoordinateWidth ((kScreenWidth - kHistogramLeftMargin - kHistogramRightMargin - kHistogramXCoordinateLeftMargin*2)/6)

#define HKDateFormat1 @"yyyy-MM-dd HH:mm:ss"
#define HKDateFormat2 @"yyyy-MM-dd HH:mm"
#define HKDateFormat3 @"yyyy.MM.dd HH:mm"
#define HKDateFormat4 @"yyyy-MM-dd"
#define HKDateFormat5 @"HH:mm:ss"
#define HKDateFormat7 @"yyyy:MM:dd"
#define HKDateFormat8 @"yyyy"
#define HKDateFormat9 @"MM:dd"
#define HKDateFormat10 @"yyyy.MM.dd"
#define HKDateFormat11 @"HH:mm"
#define HKDateFormat12 @"yyyy:MM:dd:HH:mm"
#define HKDateFormat13 @"MM.dd"
#define HKDateFormat14 @"yyyyMM"
#define HKDateFormat15 @"dd"

#endif /* Basic_h */
