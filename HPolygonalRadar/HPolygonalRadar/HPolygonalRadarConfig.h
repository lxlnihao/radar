//
//  HPolygonalRadarConfig.h
//  HPolygonalRadar
//
//  Created by 何正道 on 2019/4/22.
//  Copyright © 2019 何正道. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPolygonalRadarEnumDefine.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 雷达图背景风格
@interface HPolygonalRadarBgStyleConfig : NSObject

@property (nonatomic, assign) ENUM_HPOLYGONALRADAR_BG_STYLE          bgStyle;/**< 背景风格 */

@property (nonatomic, assign) BOOL                                   showSymmetryAxis;/**< 显示对称轴线 */
@property (nonatomic, assign) ENUM_HPOLYGONALRADAR_LINE_STYLE        symmetryAxisStyle;/**< 对称轴线风格 */
@property (nonatomic, assign) CGFloat                                symmetryAxisWidth;/**< 对称轴线宽 */
@property (nonatomic, strong) UIColor                                *symmetryAxisColor;/**< 对称轴线颜色 */
@property (nonatomic, assign) CGFloat                                symmetryAxisDashLineLength;/**< 对称轴线虚线段长度 */
@property (nonatomic, assign) CGFloat                                symmetryAxisDashLineSpacing;/**< 对称轴线虚线段间隔 */

@property (nonatomic, assign) BOOL                                   showScaleLine;/**< 显示刻度线 */
@property (nonatomic, assign) NSInteger                              scaleLineCount;/**< 刻度线数 */
@property (nonatomic, copy  ) NSArray<NSNumber *>                    *scaleLineStyles;/**< 刻度线风格组(中心->边缘) */
@property (nonatomic, copy  ) NSArray<NSNumber *>                    *scaleLineWidths;/**< 刻度线宽组(中心->边缘) */
@property (nonatomic, copy  ) NSArray<UIColor  *>                    *scaleLineColors;/**< 刻度线颜色组(中心->边缘) */
@property (nonatomic, copy  ) NSArray                                *scaleDashLineLengths;/**< 刻度线虚线段长度组(中心->边缘) */
@property (nonatomic, copy  ) NSArray                                *scaleDashLineSpacings;/**< 刻度线虚线段间隔组(中心->边缘) */

@property (nonatomic, assign) BOOL                                   showScaleLineSection;/**< 显示刻度线间隔区 */
@property (nonatomic, copy  ) NSArray<UIColor *>                     *scaleLineSectionColors;/**< 刻度线间隔区域颜色组(中心->边缘) */

@property (nonatomic, strong) UIImage                                *customBgImage;/**< 自定义背景图 */

@property (nonatomic, assign) BOOL                                   showTitleLabel;/**< 显示标题 */

@end

#pragma mark - 雷达图风格

@class HPolygonalRadarBorderStyleConfig;
@class HPolygonalRadarFillStyleConfig;
@class HPolygonalRadarVertexStyleConfig;

@interface HPolygonalRadarStyleConfig : NSObject

@property (nonatomic, assign) CGFloat                                animationDuration;/**< 显示动画时长 */

@property (nonatomic, assign) BOOL                                   showPolygonalBorder;/**< 显示多边形边框 */
@property (nonatomic, strong) HPolygonalRadarBorderStyleConfig       *borderStyleConfig;/**< 边框风格 */

@property (nonatomic, assign) BOOL                                   showPolygonalFill;/**< 显示多边形填充 */
@property (nonatomic, strong) HPolygonalRadarFillStyleConfig         *fillStyleConfig;/**< 填充风格 */

@property (nonatomic, assign) BOOL                                   showPolygonalVertexIcon;/**< 显示多边形顶点Icon */
@property (nonatomic, strong) HPolygonalRadarVertexStyleConfig       *vertexStyleConfig;/**< 顶点风格 */

@end

#pragma mark - 雷达图边框风格
@interface HPolygonalRadarBorderStyleConfig : NSObject

@property (nonatomic, assign) ENUM_HPOLYGONALRADAR_LINE_STYLE        borderStyle;/**< 边框线风格 */

@property (nonatomic, strong) UIColor                                *borderColor;/**< 边框颜色 */
@property (nonatomic, assign) CGFloat                                borderWidth;/**< 边框宽度 */
@property (nonatomic, assign) CGFloat                                borderDashLineLength;/**< 虚线每段长度 */
@property (nonatomic, assign) CGFloat                                borderDashLineSpacing;/**< 虚线段间隔 */

@end

#pragma mark - 雷达图填充风格
@interface HPolygonalRadarFillStyleConfig : NSObject

@property (nonatomic, assign) ENUM_HPOLYGONALRADAR_FILL_STYLE        fillStyle;/**< 填充风格 */

@property (nonatomic, strong) UIColor                                *solidColor;/**< 纯色填充颜色 */

@property (nonatomic, copy  ) NSArray<UIColor *>                     *gradientColors;/**< 渐变颜色组 */
@property (nonatomic, copy  ) NSArray<NSNumber *>                    *gradientLocations;/**< 颜色渐变位置组 */
@property (nonatomic, assign) CGPoint                                gradientStartPoint;/**< 渐变起始点 */
@property (nonatomic, assign) CGPoint                                gradientEndPoint;/**< 渐变终止点 */

@end

#pragma mark - 雷达图顶点风格
@interface HPolygonalRadarVertexStyleConfig : NSObject

@property (nonatomic, assign) ENUM_HPOLYGONALRADAR_VERTEX_ICON_STYLE vertexStyle;/**< 顶点风格 */

@property (nonatomic, strong) UIColor                                *vertexColor;/**< 顶点颜色 */
@property (nonatomic, assign) CGFloat                                vertexCircleRadius;/**< 顶点圆形半径 */
@property (nonatomic, assign) CGFloat                                vertexHollowCircleWidth;/**< 空心圆环宽度 */

@end

NS_ASSUME_NONNULL_END
