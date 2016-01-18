//
//  QSHistogramView.m
//  QiCheApp
//
//  Created by IOS_Doctor on 14-6-8.
//  Copyright (c) 2014年 青山. All rights reserved.
//

#import "QSHistogramView.h"

#define RGBCOLOR(R,G,B) [[UIColor alloc]initWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]

@implementation QSHistogramView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _DVDIC = [NSMutableDictionary new];
        [_DVDIC setObject:@"1" forKey:@"1"];
        [_DVDIC setObject:@"2" forKey:@"2"];
        [_DVDIC setObject:@"3" forKey:@"3"];
        [_DVDIC setObject:@"4" forKey:@"4"];
        [_DVDIC setObject:@"5" forKey:@"5"];
        [_DVDIC setObject:@"6" forKey:@"6"];
        [_DVDIC setObject:@"7" forKey:@"7"];
        _histogramNumber = 7;
        _maxPrice = 100;
        _minPrice = 10;
    }
    return self;
}

- (void)removeAllSubviews
{
    NSUInteger number = [self.subviews count];
    for (int i = 0; i < number; i ++) {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
    }
}

- (void)display
{
    // remove all.
    [self removeAllSubviews];
    
    //13.99
    float width = self.frame.size.width / (_histogramNumber * 2 + 1);
    float start = 10;
    float top = 45;
    float texthei = 17;
    float numHei = 20;
    /**
     *   求最高数量_值
     */
    NSMutableArray *ARR = [NSMutableArray new];
    for (NSString *s in [_DVDIC allKeys]) {
        id value = [_DVDIC objectForKey:s];
        if ([ARR count] == 0) {
            [ARR addObject:value];
        }
        if ([value floatValue] > [[ARR objectAtIndex:0] floatValue]) {
            [ARR insertObject:value atIndex:0];
        }
    }
    /**
     *   核心_算法
     */
    float MAX = [[ARR objectAtIndex:0] floatValue];//            最大_数
    float SPE = MAX / 2.5;//                                     动画_平均速度
    float BFB = (self.frame.size.height - top) / MAX;//          按最高数量值_求比率
    /**
     *   柱状图_柱子
     */
    for (int i = 0;i < _histogramNumber;i ++) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0f];
        /**
         *   柱形_控件
         */
        UIView *diagram = [[UIView alloc]initWithFrame:CGRectMake(i * width * 2 + width, self.frame.size.height - texthei - start, width, start)];
        
        ///  histogram seven tint color.
        UIColor *color = RGBCOLOR(arc4random() % 150 + 0, arc4random() % 200 + 70,arc4random() % 255 + 70 );
        [diagram setBackgroundColor:color];
        [self addSubview:diagram];
        /**
         *   点击_按钮
         */
        UIButton *diagramBtn = [[UIButton alloc]initWithFrame:CGRectMake(i * width * 2 + width, 0, width, self.frame.size.height)];
        [diagramBtn setBackgroundColor:[UIColor clearColor]];
        [diagramBtn setTag:i + 1];
        [diagramBtn addTarget:self action:@selector(diagramPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:diagramBtn];
        /**
         *   价格_区间值
         */
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(i * width * 2 + width / 2, self.frame.size.height - texthei, width * 2, texthei)];
        [text setTextAlignment:NSTextAlignmentCenter];
        [text setFont:[UIFont systemFontOfSize:9.0f]];
        [text setTextColor:RGBCOLOR(4, 4, 4)];
        [text setBackgroundColor:[UIColor clearColor]];
        
        ///  histogram bottom display text.
        float textTitle = (((_maxPrice - _minPrice) / _histogramNumber) / 2) + _minPrice + i * (_maxPrice - _minPrice) / _histogramNumber;
        [text setText:[[NSString stringWithFormat:@"%0.2f",textTitle] stringByAppendingString:@"万"]];
        [self addSubview:text];
        /**
         *   商家_数量
         */
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(i * width * 2 + width / 2, self.frame.size.height - texthei - start - numHei, width * 2, numHei)];
        [num setTextAlignment:NSTextAlignmentCenter];
        [num setFont:[UIFont systemFontOfSize:9.0f]];
        [num setTextColor:RGBCOLOR(4, 4, 4)];
        [num setBackgroundColor:[UIColor clearColor]];
        
        ///  histogrm display text.
        int numTitle = [[_DVDIC objectForKey:[NSString stringWithFormat:@"%d",i + 1]]intValue];
        [num setText:[[NSString stringWithFormat:@"%d",numTitle]stringByAppendingString:@"个"]];
        [self addSubview:num];
        /**
         *   核心_动画
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:[[_DVDIC objectForKey:[NSString stringWithFormat:@"%d",(i + 1)]] intValue] / SPE];
                
                int diagramNum = [[_DVDIC objectForKey:[NSString stringWithFormat:@"%d",(i + 1)]] intValue];
                
                [diagram setFrame:CGRectMake(i * width * 2 + width, self.frame.size.height - diagramNum * BFB - texthei - start, width,  diagramNum * BFB + start)];
                
                [num setFrame:CGRectMake(i * width * 2 + width / 2, self.frame.size.height - diagramNum * BFB - texthei - start - numHei, width * 2, numHei)];
                
                [UIView commitAnimations];
            });
        });
        [UIView commitAnimations];
    }
}

- (void)diagramPress:(UIButton *)sender
{
    if (self.selectedBlock) self.selectedBlock(sender.tag - 1, [NSString stringWithFormat:@"%f",((_maxPrice - _minPrice) / _histogramNumber) * sender.tag + _minPrice], [NSString stringWithFormat:@"%f",((_maxPrice - _minPrice) / _histogramNumber) * (sender.tag - 1) + _minPrice]);
}

@end
