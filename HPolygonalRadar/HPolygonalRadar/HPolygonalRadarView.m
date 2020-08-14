//
//  HPolygonalRadarView.m
//  HPolygonalRadar
//
//  Created by 何正道 on 2019/4/19.
//  Copyright © 2019 何正道. All rights reserved.
//

#import "HPolygonalRadarView.h"

@interface HPolygonalRadarView ()

@property (nonatomic, weak  ) id<HPolygonalRadarViewDataSource>     radarDataSource;

@property (nonatomic, assign) BOOL                                  isVertexUp;/**< 顶点朝上 */
@property (nonatomic, assign) CGFloat                               radius;/**< 半径 */
@property (nonatomic, assign) NSInteger                             edgeCount;/**< 边数 */

@property (nonatomic, assign) CGPoint                               origin;/**< 坐标系原点 */
@property (nonatomic, assign) CGFloat                               radiusRadian;/**< 半径夹角 */
@property (nonatomic, assign) CGFloat                               startRadian;/**< 起始角度 */

@property (nonatomic, strong) HPolygonalRadarBgStyleConfig          *bgConfig;
@property (nonatomic, copy  ) NSArray<HPolygonalRadarStyleConfig *> *radarConfig;

@property (nonatomic, strong) HPolygonalRadarStyleConfig            *curRadarConfig;

@end

@implementation HPolygonalRadarView

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%s dealloc", __FUNCTION__);
}

#pragma mark - init
- (instancetype)initWithCenter:(CGPoint)center
                    dataSource:(id<HPolygonalRadarViewDataSource>)dataSource
                    isVertexUp:(BOOL)isVertexUp
                        radius:(CGFloat)radius
                     edgeCount:(NSInteger)edgeCount
                 bgStyleConfig:(HPolygonalRadarBgStyleConfig *)bgStyleConfig
              radarStyleConfig:(NSArray<HPolygonalRadarStyleConfig *> *)radarStyleConfig {
    NSAssert(2 < edgeCount, @"多边形的边数应大于2");
    self = [super init];
    if (self) {
        self.center = center;
        
        _isVertexUp = isVertexUp;
        _radius = radius;
        _edgeCount = edgeCount;
        _radiusRadian = M_PI * 2 / _edgeCount;
        
        _radarDataSource = dataSource;
        
        _bgConfig = bgStyleConfig;
        _radarConfig = radarStyleConfig;
        
        //初始化多边形大小和坐标原点
        [self setupBoundsAndOrigin];
        
        if (_bgConfig) {
            [self setupPolygonalBg];
        }
        
        for (HPolygonalRadarStyleConfig *radarStyleConfig in _radarConfig) {
            _curRadarConfig = radarStyleConfig;
            [self setupPolygonal];
        }
    }
    return self;
}

#pragma mark - setup
- (void)setupBoundsAndOrigin {
    if (_isVertexUp) {
        //顶点朝上，起始角度为0
        _startRadian = 0;
    } else {
        //边朝上，起始角度为半径夹角的一半
        _startRadian = _radiusRadian / 2;
    }
    
    //计算最上最下最左最右
    UIEdgeInsets rectEdge = UIEdgeInsetsZero;
    for (int i = 0; i < _edgeCount; i++) {
        CGFloat targetAngel = _startRadian + _radiusRadian * i;
        rectEdge.left = MIN(rectEdge.left, sin(targetAngel) * _radius);
        rectEdge.right = MAX(rectEdge.right, sin(targetAngel) * _radius);
        rectEdge.top = MIN(rectEdge.top, cos(targetAngel) * _radius);
        rectEdge.bottom = MAX(rectEdge.bottom, cos(targetAngel) * _radius);
    }
    
    //最右 - 最左 = 宽度，最下 - 最上 = 高度
    self.bounds = CGRectMake(0, 0, rectEdge.right - rectEdge.left, rectEdge.bottom - rectEdge.top);
    
    //顶点朝上，原点Y为半径长度
    if (_isVertexUp) {
        _origin = CGPointMake(self.bounds.size.width / 2, _radius);
    } else {
        //边朝上
        if (0 == _edgeCount % 2) {
            //偶数边数时，原点为中心点
            _origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        } else {
            //奇数边数时，原点Y为(高度 - 半径)
            _origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - _radius);
        }
    }
}

- (void)setupPolygonalBg {
    switch (_bgConfig.bgStyle) {
        case ENUM_HPOLYGONALRADAR_BG_STYLE_DEFAULT:{
            //刻度线
            if (_bgConfig.showScaleLine) {
                CAShapeLayer *scaleLinesLayer = [self scaleLinesLayer];
                if (scaleLinesLayer) {
                    [self.layer addSublayer:scaleLinesLayer];
                }
            }
            
            //对称轴线
            if (_bgConfig.showSymmetryAxis) {
                for (NSInteger i = 0; i < _edgeCount; i++) {
                    [self.layer addSublayer:[self symmetryAxesLayerWithIndex:i]];
                }
            }
        }break;
            
        case ENUM_HPOLYGONALRADAR_BG_STYLE_CUSTOM_IMAGE:{
            UIImageView *imgBg = [[UIImageView alloc] initWithFrame:self.bounds];
            imgBg.contentMode = UIViewContentModeScaleAspectFill;
            [imgBg setImage:_bgConfig.customBgImage];
            [self addSubview:imgBg];
        }break;
            
        default:break;
    }
    
    if (_bgConfig.showTitleLabel &&
        _radarDataSource &&
        [_radarDataSource respondsToSelector:@selector(HPolygonalRadarTitleLabelAtIndex:)]) {
        for (NSInteger i = 0; i < _edgeCount; i++) {
            CGFloat radian = _startRadian + _radiusRadian * i;
            CGPoint point = CGPointMake(_origin.x + _radius * sin(radian), _origin.y - _radius * cos(radian));
            
            UILabel *titleLabel = [_radarDataSource HPolygonalRadarTitleLabelAtIndex:i];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            CGFloat spacing = 10.f;
            CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:titleLabel.font}];
            titleSize.width = titleSize.width + spacing + 15.f;
            titleSize.height = titleSize.height + spacing;
            
            CGPoint titleCenter = CGPointMake(point.x + sin(radian) * titleSize.width / 2, point.y - cos(radian) * titleSize.height / 2);
            
            titleLabel.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
            titleLabel.center = titleCenter;
            
            [self addSubview:titleLabel];
        }
    }
}

- (void)setupPolygonal {
    //取得多边形Bezier
    UIBezierPath *polygonalBezier = [self drawPolygonalBezier];
    //填充
    if (_curRadarConfig.showPolygonalFill) {
        CAShapeLayer *fillShapeLayer = [self polygonalSolidColorFillLayerWithBezier:polygonalBezier];
        if (ENUM_HPOLYGONALRADAR_FILL_STYLE_SOLID_COLOR == _curRadarConfig.fillStyleConfig.fillStyle) {
            [self.layer addSublayer:fillShapeLayer];
        } else if (ENUM_HPOLYGONALRADAR_FILL_STYLE_GRADIENT_COLOR == _curRadarConfig.fillStyleConfig.fillStyle) {
            [self.layer addSublayer:[self addGradientLayerFor:fillShapeLayer]];
        }
    }
    
    //边框
    if (_curRadarConfig.showPolygonalBorder) {
        [self.layer addSublayer:[self polygonalBorderLayerWithBezier:polygonalBezier]];
    }
    
    //顶点
    if (_curRadarConfig.showPolygonalVertexIcon) {
        for (NSInteger i = 0; i < _edgeCount; i++) {
            [self.layer addSublayer:[self vertexLayerWithIndex:i]];
        }
    }
}

#pragma mark - 刻度线Layer & 刻度线间隔区Layer
- (CAShapeLayer *)scaleLinesLayer {
    NSInteger scaleLineCount = _bgConfig.scaleLineCount;
    if (scaleLineCount != _bgConfig.scaleLineStyles.count ||
        scaleLineCount != _bgConfig.scaleLineWidths.count ||
        scaleLineCount != _bgConfig.scaleLineColors.count) {
        return nil;
    }
    
    CAShapeLayer *scaleLinesLayer = [CAShapeLayer layer];
    
    for (NSInteger i = _bgConfig.scaleLineCount - 1; i >= 0; i--) {
        CAShapeLayer *scaleLineShapeLayer = [CAShapeLayer layer];
        scaleLineShapeLayer.path = [self drawScaleLineBezierWithIndex:i].CGPath;
        scaleLineShapeLayer.lineWidth = [_bgConfig.scaleLineWidths[i] floatValue];
        scaleLineShapeLayer.strokeColor = _bgConfig.scaleLineColors[i].CGColor;
        
        //虚线情况
        ENUM_HPOLYGONALRADAR_LINE_STYLE scaleLineStyle = [_bgConfig.scaleLineStyles[i] integerValue];
        if (ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE == scaleLineStyle &&
            i < _bgConfig.scaleDashLineLengths.count &&
            i < _bgConfig.scaleDashLineSpacings.count) {
            scaleLineShapeLayer.lineDashPattern = @[@([_bgConfig.scaleDashLineLengths[i] floatValue]),
                                                    @([_bgConfig.scaleDashLineSpacings[i] floatValue])];
        }
        
        //显示间隔区
        if (_bgConfig.showScaleLineSection &&
            i < _bgConfig.scaleLineSectionColors.count) {
            scaleLineShapeLayer.fillColor = _bgConfig.scaleLineSectionColors[i].CGColor;
        }
        
        [scaleLinesLayer addSublayer:scaleLineShapeLayer];
    }
    
    return scaleLinesLayer;
}

#pragma mark - 对称轴线Layer
- (CAShapeLayer *)symmetryAxesLayerWithIndex:(NSInteger)index {
    CAShapeLayer *symmetryAxesShapeLayer = [CAShapeLayer layer];
    symmetryAxesShapeLayer.path = [self drawSymmetryAxisBezierWithIndex:index].CGPath;
    symmetryAxesShapeLayer.lineWidth = _bgConfig.symmetryAxisWidth;
    symmetryAxesShapeLayer.strokeColor = _bgConfig.symmetryAxisColor.CGColor;
    
    if (ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE == _bgConfig.symmetryAxisStyle) {
        symmetryAxesShapeLayer.lineDashPattern = @[@(_bgConfig.symmetryAxisDashLineLength),@(_bgConfig.symmetryAxisDashLineSpacing)];
    }
    
    return symmetryAxesShapeLayer;
}

#pragma mark - 纯色填充Layer
- (CAShapeLayer *)polygonalSolidColorFillLayerWithBezier:(UIBezierPath *)polygonalBezier {
    CAShapeLayer *fillShapeLayer = [CAShapeLayer layer];
    fillShapeLayer.path = polygonalBezier.CGPath;
    fillShapeLayer.fillColor = _curRadarConfig.fillStyleConfig.solidColor.CGColor;
    [fillShapeLayer addAnimation:[self shapeAnimationFromPath:[self originPath] toPath:polygonalBezier] forKey:nil];
    return fillShapeLayer;
}

#pragma mark - 添加渐变
- (CAGradientLayer *)addGradientLayerFor:(CAShapeLayer *)shapeLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = _curRadarConfig.fillStyleConfig.gradientStartPoint;
    gradientLayer.endPoint = _curRadarConfig.fillStyleConfig.gradientEndPoint;
    
    NSMutableArray *arrCGColors = [NSMutableArray array];
    for (UIColor *color in _curRadarConfig.fillStyleConfig.gradientColors) {
        [arrCGColors addObject:(__bridge id)color.CGColor];
    }
    
    gradientLayer.colors = arrCGColors;
    gradientLayer.locations = _curRadarConfig.fillStyleConfig.gradientLocations;
    [gradientLayer setMask:shapeLayer];
    
    return gradientLayer;
}

#pragma mark - 多边形边框Layer
- (CAShapeLayer *)polygonalBorderLayerWithBezier:(UIBezierPath *)polygonalBezier {
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.path = polygonalBezier.CGPath;
    borderShapeLayer.lineWidth = _curRadarConfig.borderStyleConfig.borderWidth;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    borderShapeLayer.strokeColor = _curRadarConfig.borderStyleConfig.borderColor.CGColor;
    
    if (ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE == _curRadarConfig.borderStyleConfig.borderStyle) {
        borderShapeLayer.lineDashPattern = @[@(_curRadarConfig.borderStyleConfig.borderDashLineLength),
                                             @(_curRadarConfig.borderStyleConfig.borderDashLineSpacing)];
    }
    
    [borderShapeLayer addAnimation:[self shapeAnimationFromPath:[self originPath] toPath:polygonalBezier] forKey:nil];
    
    return borderShapeLayer;
}

#pragma mark - 顶点Layer
- (CAShapeLayer *)vertexLayerWithIndex:(NSInteger)index {
    CAShapeLayer *vertexShapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *vertexseBezier = [self drawVertexWithIndex:index];
    if (vertexseBezier) {
        vertexShapeLayer.path = vertexseBezier.CGPath;
        vertexShapeLayer.lineWidth = _curRadarConfig.vertexStyleConfig.vertexHollowCircleWidth;
        vertexShapeLayer.strokeColor = _curRadarConfig.vertexStyleConfig.vertexColor.CGColor;
        
        if (ENUM_HPOLYGONALRADAR_VERTEX_ICON_STYLE_SOLID_CIRCLE == _curRadarConfig.vertexStyleConfig.vertexStyle) {
            vertexShapeLayer.fillColor = _curRadarConfig.vertexStyleConfig.vertexColor.CGColor;
        } else if (ENUM_HPOLYGONALRADAR_VERTEX_ICON_STYLE_HOLLOW_CIRCLE == _curRadarConfig.vertexStyleConfig.vertexStyle) {
            vertexShapeLayer.fillColor = [UIColor whiteColor].CGColor;
        }
        
        [vertexShapeLayer addAnimation:[self shapeAnimationFromPath:[self originPath] toPath:vertexseBezier] forKey:nil];
    }
    
    return vertexShapeLayer;
}

#pragma mark - 绘制刻度线
- (UIBezierPath *)drawScaleLineBezierWithIndex:(NSInteger)index {
    //刻度间隔
    CGFloat scaleLineSpacing = _radius / _bgConfig.scaleLineCount;
    
    UIBezierPath *scaleLineBezier = [UIBezierPath bezierPath];
    scaleLineBezier.lineCapStyle = kCGLineCapRound;
    scaleLineBezier.lineJoinStyle = kCGLineJoinMiter;
    
    for (NSInteger j = 0; j < _edgeCount; j++) {
        CGFloat valueRadius = scaleLineSpacing * (index + 1);
        CGPoint point = CGPointMake(_origin.x + valueRadius * sin(_startRadian + _radiusRadian * j), _origin.y - valueRadius * cos(_startRadian + _radiusRadian * j));
        (0 == j) ? [scaleLineBezier moveToPoint:point] : [scaleLineBezier addLineToPoint:point];
    }
    
    [scaleLineBezier closePath];
    
    return scaleLineBezier;
}

#pragma mark - 绘制对称轴线
- (UIBezierPath *)drawSymmetryAxisBezierWithIndex:(NSInteger)index {
    UIBezierPath *symmetryAxesBezier = [UIBezierPath bezierPath];
    symmetryAxesBezier.lineCapStyle = kCGLineCapRound;
    symmetryAxesBezier.lineJoinStyle = kCGLineJoinMiter;
    
    [symmetryAxesBezier moveToPoint:_origin];
    CGPoint point = CGPointMake(_origin.x + _radius * sin(_startRadian + _radiusRadian * index), _origin.y - _radius * cos(_startRadian + _radiusRadian * index));
    [symmetryAxesBezier addLineToPoint:point];
    
    return symmetryAxesBezier;
}

#pragma mark - 绘制多边形
- (UIBezierPath *)drawPolygonalBezier {
    UIBezierPath *polygonalBezier = [UIBezierPath bezierPath];
    polygonalBezier.lineCapStyle = kCGLineCapRound;
    polygonalBezier.lineJoinStyle = kCGLineJoinMiter;
    
    if (_radarDataSource &&
        [_radarDataSource respondsToSelector:@selector(HPolygonalRadarValueAtIndex:radarIndex:)]) {
        for (NSInteger i = 0; i < _edgeCount; i++) {
            CGFloat valueRadius = [_radarDataSource HPolygonalRadarValueAtIndex:i radarIndex:[_radarConfig indexOfObject:_curRadarConfig]] * _radius;
            CGPoint point = CGPointMake(_origin.x + valueRadius * sin(_startRadian + _radiusRadian * i), _origin.y - valueRadius * cos(_startRadian + _radiusRadian * i));
            (0 == i) ? [polygonalBezier moveToPoint:point] : [polygonalBezier addLineToPoint:point];
        }
        
        [polygonalBezier closePath];
    }
    
    return polygonalBezier;
}

#pragma mark - 绘制顶点
- (UIBezierPath *)drawVertexWithIndex:(NSInteger)index {
    UIBezierPath *vertexBezier = nil;
    
    if (_radarDataSource &&
        [_radarDataSource respondsToSelector:@selector(HPolygonalRadarValueAtIndex:radarIndex:)]) {
        CGFloat valueRadius = _radius * [_radarDataSource HPolygonalRadarValueAtIndex:index radarIndex:[_radarConfig indexOfObject:_curRadarConfig]];
        CGPoint point = CGPointMake(_origin.x + valueRadius * sin(_startRadian + _radiusRadian * index), _origin.y - valueRadius * cos(_startRadian + _radiusRadian * index));
        
        vertexBezier = [UIBezierPath bezierPathWithArcCenter:point radius:_curRadarConfig.vertexStyleConfig.vertexCircleRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        vertexBezier.lineCapStyle = kCGLineCapRound;
        vertexBezier.lineJoinStyle = kCGLineJoinMiter;
    }
    
    return vertexBezier;
}

#pragma mark - 源Path
- (UIBezierPath *)originPath {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < _edgeCount; i++) {
        (0 == i) ? [path moveToPoint:_origin] : [path addLineToPoint:_origin];
    }
    [path closePath];
    return path;
}

#pragma mark - 添加动画
- (CABasicAnimation *)shapeAnimationFromPath:(UIBezierPath *)fromPath
                                      toPath:(UIBezierPath *)toPath {
    CABasicAnimation *pathAnmi = [CABasicAnimation animation];
    pathAnmi.keyPath = @"path";
    pathAnmi.fromValue = (__bridge id)fromPath.CGPath;
    pathAnmi.toValue = (__bridge id)toPath.CGPath;
    pathAnmi.duration = _curRadarConfig.animationDuration;
    pathAnmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnmi.fillMode = kCAFillModeForwards;
    pathAnmi.autoreverses = NO;
    pathAnmi.removedOnCompletion = NO;
    return pathAnmi;
}

@end
