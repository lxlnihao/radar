//
//  ViewController.m
//  HPolygonalRadar
//
//  Created by 何正道 on 2019/4/19.
//  Copyright © 2019 何正道. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "HPolygonalRadarView.h"

@interface ViewController ()<HPolygonalRadarViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    BOOL _isVertexUp;
    NSInteger _edgeCount;
}

@property (nonatomic, strong) UICollectionView    *collectionView;

@property (nonatomic, strong) HPolygonalRadarView *viRadar;
@property (nonatomic, strong) NSMutableDictionary *randomDataSource;
@property (nonatomic, copy  ) NSArray             *arrRadarTitles;
@property (nonatomic, copy  ) NSArray             *arrDemoOperations;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _randomDataSource = [NSMutableDictionary dictionary];
    _arrRadarTitles = @[@"1\n急加速1",@"2\n急转弯2",@"3\n超速行驶3",@"4\n高峰行驶4",@"5\n夜间行驶5",@"6\n急减速6"];
    _arrDemoOperations = @[@"重绘",@"边数++",@"边数--",@"切换朝向"];
    _isVertexUp = YES;
    _edgeCount = 6;
    
    [self.view addSubview:self.viRadar];
    [self.view addSubview:self.collectionView];
}

- (HPolygonalRadarView *)viRadar {
    if (!_viRadar) {
        HPolygonalRadarBgStyleConfig *bgConfig = [HPolygonalRadarBgStyleConfig new];
        bgConfig.scaleLineCount = 4;
        bgConfig.scaleLineStyles = @[@(ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE),@(ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE),@(ENUM_HPOLYGONALRADAR_LINE_STYLE_DASH_LINE),@(ENUM_HPOLYGONALRADAR_LINE_STYLE_SOLID_LINE)];
        bgConfig.scaleLineColors = @[[UIColor blackColor],[UIColor blackColor],[UIColor blackColor],[UIColor blackColor]];
        //线宽
        bgConfig.scaleLineWidths = @[@0.f,@0.f,@0.f,@0.f];
//        bgConfig.scaleDashLineLengths = @[@4.f,@0.f,@8.f,@0.f];
//        bgConfig.scaleDashLineSpacings = @[@2.f,@0.f,@4.f,@0.f];
        //对称轴不展示
        bgConfig.showSymmetryAxis = NO;
        bgConfig.showScaleLineSection = YES;
        //从里到外展示的
        bgConfig.scaleLineSectionColors = @[[UIColor colorWithRed:253/255.0 green:222/255.0 blue:202/255.0 alpha:1],
        [UIColor colorWithRed:255/255.0 green:232/255.0 blue:217/255.0 alpha:1],
        [UIColor colorWithRed:255/255.0 green:240/255.0 blue:230/255.0 alpha:1],
        [UIColor colorWithRed:255/255.0 green:248/255.0 blue:244/255.0 alpha:1]];
        
        
        HPolygonalRadarStyleConfig *radarConfig0 = [HPolygonalRadarStyleConfig new];
//        HPolygonalRadarStyleConfig *radarConfig1 = [HPolygonalRadarStyleConfig new];
        radarConfig0.animationDuration = 3;
        //不显示边框颜色
        radarConfig0.showPolygonalBorder = NO;
        //蒙层颜色 紫色
        radarConfig0.fillStyleConfig.fillStyle = ENUM_HPOLYGONALRADAR_FILL_STYLE_SOLID_COLOR;
        radarConfig0.fillStyleConfig.solidColor = [UIColor colorWithRed:252/255.0 green:175/255.0 blue:131/255.0 alpha:1];
        //顶点风格
        //空心圆
//        radarConfig0.vertexStyleConfig.vertexStyle = ENUM_HPOLYGONALRADAR_VERTEX_ICON_STYLE_HOLLOW_CIRCLE;
        radarConfig0.vertexStyleConfig.vertexColor = [UIColor redColor];
        radarConfig0.vertexStyleConfig.vertexCircleRadius = 5;
        radarConfig0.vertexStyleConfig.vertexHollowCircleWidth = 1;
        
        _viRadar = [[HPolygonalRadarView alloc] initWithCenter:CGPointMake(self.view.center.x, 200)
                                                    dataSource:self
                                                    isVertexUp:_isVertexUp
                                                        radius:120
                                                     edgeCount:_edgeCount
                                                 bgStyleConfig:bgConfig
                                              radarStyleConfig:@[radarConfig0]];
    }
    return _viRadar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(80, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_viRadar.frame) + 100, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_viRadar.frame) - 100) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
    }
    return _collectionView;
}

#pragma mark - HPolygonalRadarViewDataSource
- (CGFloat)HPolygonalRadarValueAtIndex:(NSInteger)index radarIndex:(NSInteger)radarIndex {
    NSString *key = [NSString stringWithFormat:@"%zd%zd", radarIndex, index];
    NSLog(@"key:%@",key);
    if ([_randomDataSource valueForKey:key]) {
        NSLog(@"floatValue:%f",[[_randomDataSource valueForKey:key] floatValue]);
        return [[_randomDataSource valueForKey:key] floatValue];
    } else {
        CGFloat value = (CGFloat)(arc4random() % 100 + 1) / 100;
        NSLog(@"value:%f",value);
        value = (index+1)/6.0;
        [_randomDataSource setValue:@(value) forKey:key];
        return value;
    }
}

- (UILabel *)HPolygonalRadarTitleLabelAtIndex:(NSInteger)index {
    UILabel *lb = [UILabel new];
    lb.text = _arrRadarTitles[(index % _arrRadarTitles.count)];
    lb.font = [UIFont boldSystemFontOfSize:15];
    lb.numberOfLines = 2;
    lb.textColor = [UIColor blackColor];
    return lb;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrDemoOperations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    cell.lbOperation.text = _arrDemoOperations[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *operation = _arrDemoOperations[indexPath.row];
    if ([operation isEqualToString:@"重绘"]) {
        [self resetRadar];
    } else if ([operation isEqualToString:@"边数++"]) {
        _edgeCount++;
        [self resetRadar];
    } else if ([operation isEqualToString:@"边数--"]) {
        if (3 < _edgeCount) {
            _edgeCount--;
            [self resetRadar];
        }
    } else if ([operation isEqualToString:@"切换朝向"]) {
        _isVertexUp = !_isVertexUp;
        [self resetRadar];
    }
}

#pragma mark - 自定义方法
- (void)resetRadar {
    [_viRadar removeFromSuperview];
    _viRadar = nil;
    [_randomDataSource removeAllObjects];
    [self.view addSubview:self.viRadar];
}

@end
