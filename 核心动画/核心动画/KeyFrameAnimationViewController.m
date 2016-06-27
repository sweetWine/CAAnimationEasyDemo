//
//  KeyFrameAnimationViewController.m
//  核心动画
//
//  Created by ios on 16/6/27.
//
//

#import "KeyFrameAnimationViewController.h"

@interface KeyFrameAnimationViewController ()
{
    UIImageView *_imgView;
}
@end

@implementation KeyFrameAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];

    /*
     图片地址：http://img.kumi.cn/photo/db/47/60/db47608fcacafd86_610x455.jpg?1225
     */
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_imgView];
    
    // 多线程添加图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.kumi.cn/photo/db/47/60/db47608fcacafd86_610x455.jpg?1225"]];
        UIImage *img = [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgView.image = img;
        });
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取点击的位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // 沿着曲线运动
//    [self moveCurve:point];
    
    // 移动到指定的位置
    [self moveToTouchPoint:point];
}

// 移动到点击的位置
- (void)moveToTouchPoint:(CGPoint)touchPoint
{
    // 创建动画对象
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    keyAnimation.duration = 1;
    keyAnimation.delegate = self;
    
    NSValue *value1 = [NSValue valueWithCGPoint:_imgView.center];
    NSValue *value2 = [NSValue valueWithCGPoint:touchPoint];
    NSValue *value3 = [NSValue valueWithCGPoint:[self createRandomPoint]];
    
    // 设置values
    keyAnimation.values = @[value1, value2, value3];
    
    keyAnimation.autoreverses = YES;
    
    [_imgView.layer addAnimation:keyAnimation forKey:nil];
}

// 沿着曲线运动
- (void)moveCurve:(CGPoint)touchPoint
{
    // 创建动画对象
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    keyAnimation.duration = 1;
    
    // 创建路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 生成控制点
    CGPoint point = [self createRandomPoint];
    
    // 设置初始位置
    CGPathMoveToPoint(path, nil, _imgView.center.x, _imgView.center.y);
    CGPathAddQuadCurveToPoint(path, nil, point.x, point.y, touchPoint.x, touchPoint.y);
    
    keyAnimation.path = path;
    
    [_imgView.layer addAnimation:keyAnimation forKey:nil];
    
    // 释放路径
    CGPathRelease(path);
}

// 产生一个随机的坐标
- (CGPoint)createRandomPoint
{
    CGFloat point_x = arc4random_uniform([UIScreen mainScreen].bounds.size.width);
    CGFloat point_y = arc4random_uniform([UIScreen mainScreen].bounds.size.height);
    CGPoint point = CGPointMake(point_x, point_y);
    return point;
}

#pragma mark - 代理方法
-(void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@"animationDidStart");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop");
}


@end
