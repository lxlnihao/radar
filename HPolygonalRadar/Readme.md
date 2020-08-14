#### 如何使用

* * *

**一. 拷贝文件到项目**
1. 拷贝示例工程中HPolygonalRadar目录下的5个文件到自己的项目中，5个文件如下：
    >HPolygonalRadarConfig.h
    >HPolygonalRadarConfig.m
    >HPolygonalRadarEnumDefine.h
    >HPolygonalRadarView.h
    >HPolygonalRadarView.m

* * *

**二. 引入头文件**
1. 在需要使用的文件中引入HPolygonalRadarView.h头文件
```
#import "HPolygonalRadarView.h"
```

* * *

**三. 初始化**

1. 创建背景配置类实例
```
HPolygonalRadarBgStyleConfig *bgConfig = [HPolygonalRadarBgStyleConfig new];
```

2. 创建雷达图配置类实例
```
HPolygonalRadarStyleConfig *radarConfig = [HPolygonalRadarStyleConfig new];
```
3. 创建雷达图实例
```
HPolygonalRadarView *viRadar = [[HPolygonalRadarView alloc] initWithCenter:CGPointMake(self.view.center.x, 200)
                                                    dataSource:self
                                                    isVertexUp:YES
                                                        radius:120
                                                     edgeCount:5
                                                 bgStyleConfig:bgConfig
                                              radarStyleConfig:@[radarConfig]];
```
4. 遵循HPolygonalRadarViewDataSource协议并实现协议方法
```
@interface YourClass ()<HPolygonalRadarViewDataSource>
```

```
- (CGFloat)HPolygonalRadarValueAtIndex:(NSInteger)index radarIndex:(NSInteger)radarIndex;
```