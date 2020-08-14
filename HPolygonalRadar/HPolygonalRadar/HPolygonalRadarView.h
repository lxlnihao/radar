//
//  HPolygonalRadarView.h
//  HPolygonalRadar
//
//  Created by 何正道 on 2019/4/19.
//  Copyright © 2019 何正道. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPolygonalRadarEnumDefine.h"
#import "HPolygonalRadarConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HPolygonalRadarViewDataSource <NSObject>

- (CGFloat)HPolygonalRadarValueAtIndex:(NSInteger)index radarIndex:(NSInteger)radarIndex;

@optional
- (UILabel *)HPolygonalRadarTitleLabelAtIndex:(NSInteger)index;

@end

@interface HPolygonalRadarView : UIView

/**
 初始化方法

 @param center 中心点
 @param dataSource 数据源
 @param isVertexUp 顶点朝上
 @param radius 半径
 @param edgeCount 多边形边数
 @param bgStyleConfig 背景风格配置项
 @param radarStyleConfig 雷达图风格配置项
 @return HPolygonalRadarView
 */
- (instancetype)initWithCenter:(CGPoint)center
                    dataSource:(id<HPolygonalRadarViewDataSource>)dataSource
                    isVertexUp:(BOOL)isVertexUp
                        radius:(CGFloat)radius
                     edgeCount:(NSInteger)edgeCount
                 bgStyleConfig:(HPolygonalRadarBgStyleConfig *)bgStyleConfig
              radarStyleConfig:(NSArray<HPolygonalRadarStyleConfig *> *)radarStyleConfig;

@end

NS_ASSUME_NONNULL_END
