//
//  HPolygonalRadarConfig.m
//  HPolygonalRadar
//
//  Created by 何正道 on 2019/4/22.
//  Copyright © 2019 何正道. All rights reserved.
//

#import "HPolygonalRadarConfig.h"

#define HPolygonalColorRGB(_red, _green, _blue) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:1]
#define HPolygonalColorRGBA(_red, _green, _blue, _alpha) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:(_alpha)]

#define HPolygonalColorRed HPolygonalColorRGB(235, 35, 35)
#define HPolygonalColorOrange HPolygonalColorRGBA(255, 148, 53, .9)
#define HPolygonalColorYellow HPolygonalColorRGB(229, 230, 0)
#define HPolygonalColorGreen HPolygonalColorRGB(164, 230, 78)
#define HPolygonalColorCyan HPolygonalColorRGBA(38, 172, 235, .9)
#define HPolygonalColorBlue HPolygonalColorRGBA(1, 139, 242, .9)
#define HPolygonalColorPurple HPolygonalColorRGB(99, 91, 151)
#define HPolygonalColorGray HPolygonalColorRGB(153, 153, 153)
#define HPolygonalColorBlack HPolygonalColorRGB(10, 10, 10)

@implementation HPolygonalRadarBgStyleConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _bgStyle = ENUM_HPOLYGONALRADAR_BG_STYLE_DEFAULT;
        
        //刻度线
        _showScaleLine = YES;
        _scaleLineCount = 7;
        _scaleLineStyles = @[@(ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE),
                             @(ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE),
                             @(ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE),
                             @(ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE),
                             @(ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE),
                             @(ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE),
                             @(ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE)];
        _scaleLineColors = @[HPolygonalColorBlack,
                             HPolygonalColorBlack,
                             HPolygonalColorBlack,
                             HPolygonalColorBlack,
                             HPolygonalColorBlack,
                             HPolygonalColorBlack,
                             HPolygonalColorBlack];
        _scaleLineWidths = @[@1.f,@1.f,@1.f,@1.f,@1.f,@1.f,@1.f];
        _scaleDashLineLengths = @[@4.f,@0.f,@8.f,@0.f,@20.f,@.0f,@40.f];
        _scaleDashLineSpacings = @[@2.f,@0.f,@4.f,@0.f,@10.f,@0.f,@20.f];
        
        //对称轴
        _showSymmetryAxis = YES;
        _symmetryAxisStyle = ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE;
        _symmetryAxisColor = HPolygonalColorBlue;
        _symmetryAxisWidth = 1.f;
        _symmetryAxisDashLineLength = 2.f;
        _symmetryAxisDashLineSpacing = 2.f;
        
        //刻度线间隔区颜色
        _showScaleLineSection = YES;
        _scaleLineSectionColors = @[HPolygonalColorRed,
                                    HPolygonalColorOrange,
                                    HPolygonalColorYellow,
                                    HPolygonalColorGreen,
                                    HPolygonalColorCyan,
                                    HPolygonalColorBlue,
                                    HPolygonalColorPurple];
        
        _customBgImage = [UIImage imageNamed:@"custombg"];
        
        //标题
        _showTitleLabel = YES;
    }
    return self;
}

@end

@implementation HPolygonalRadarStyleConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        //动画时长
        _animationDuration = 1.5f;
        
        //边框
        _showPolygonalBorder = YES;
        _borderStyleConfig = [HPolygonalRadarBorderStyleConfig new];
        
        //填充
        _showPolygonalFill = YES;
        _fillStyleConfig = [HPolygonalRadarFillStyleConfig new];
        
        //顶点
        _showPolygonalVertexIcon = YES;
        _vertexStyleConfig = [HPolygonalRadarVertexStyleConfig new];
    }
    return self;
}

@end

@implementation HPolygonalRadarBorderStyleConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _borderStyle = ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE;
        _borderColor = HPolygonalColorPurple;
        _borderWidth = 1.5f;
        _borderDashLineLength = 4.f;
        _borderDashLineSpacing = 1.f;
    }
    return self;
}

@end

@implementation HPolygonalRadarFillStyleConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _fillStyle = ENUM_HPOLYGONALRADAR_FILL_STYLE_GRADIENT_COLOR;
        _solidColor = HPolygonalColorOrange;
        _gradientColors = @[HPolygonalColorRed,
                            HPolygonalColorOrange,
                            HPolygonalColorYellow];
        
        CGFloat d = 1.f / _gradientColors.count;
        NSMutableArray *arrLocations = [NSMutableArray array];
        for (NSInteger i = 0; i < _gradientColors.count; i++) {
            [arrLocations addObject:@(i*d)];
        }
        
        _gradientLocations = @[@.25,@.5,@.75];
        _gradientStartPoint = CGPointMake(0.2, 0.2);
        _gradientEndPoint = CGPointMake(1, 1);
    }
    return self;
}

@end

@implementation HPolygonalRadarVertexStyleConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _vertexStyle = ENUM_HPOLYGONALRADAR_VERTEX_ICON_STYLE_HOLLOW_CIRCLE;
        _vertexColor = HPolygonalColorPurple;
        _vertexCircleRadius = 5.f;
        _vertexHollowCircleWidth = 2.f;
    }
    return self;
}

@end
