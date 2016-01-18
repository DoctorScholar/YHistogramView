//
//  QSHistogramView.h
//  QiCheApp
//
//  Created by IOS_Doctor on 14-6-8.
//  Copyright (c) 2014年 青山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QSHistogramSelectedBlock) (NSInteger idx, NSString * maxValue, NSString *lowValue);
@interface QSHistogramView : UIView

@property (nonatomic, assign) float                    maxPrice;
@property (nonatomic, assign) float                    minPrice;
@property (nonatomic, assign) int                      histogramNumber;// < gived a display of histogram number.
@property (nonatomic, copy  ) NSMutableDictionary      *DVDIC;
@property (nonatomic, copy  ) QSHistogramSelectedBlock selectedBlock;

- (void)display;

@end
