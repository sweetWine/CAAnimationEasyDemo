//
//  BasicAnimationViewController.m
//  核心动画
//
//  Created by ios on 16/6/25.
//
//

#import "BasicAnimationViewController.h"

@interface BasicAnimationViewController ()
{
    UIImageView *_imgView;
    BOOL isAnimation;
}
@end

@implementation BasicAnimationViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"点击屏幕开始动画";
    self.view.backgroundColor = [UIColor cyanColor];
    
    isAnimation = NO;
    /*
     图片地址：http://img.kumi.cn/photo/db/47/60/db47608fcacafd86_610x455.jpg?1225
     */
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    [self.view addSubview:_imgView];
    
    // 多线程添加图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.kumi.cn/photo/db/47/60/db47608fcacafd86_610x455.jpg?1225"]];
        UIImage *img = [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _imgView.image = img;
        });
    });
    
    // 添加按钮
    UIButton *startOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startOrPauseBtn.tag = 1001;
    startOrPauseBtn.frame = CGRectMake(100, 300, 80, 40);
    [startOrPauseBtn setTitle:@"暂停/继续" forState:UIControlStateNormal];
    [startOrPauseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startOrPauseBtn];
}

- (void)btnClick:(UIButton *)btn
{
    if (!isAnimation) {
        return;
    }
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self pauseAnimation];
    }else {
        [self startAnimation];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isAnimation = YES;

    // 创建动画对象
    // 翻转动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设置属性
    basicAnimation.fromValue = 0;
    basicAnimation.toValue = @(M_PI);
    basicAnimation.duration = 3;
    basicAnimation.repeatCount = MAXFLOAT;
    
    // 设置锚点位置
    _imgView.layer.position = _imgView.frame.origin;
    _imgView.layer.anchorPoint = CGPointMake(0, 0);
    
    // 不移除动画，保持动画最后状态
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    // 设置视图恢复的时候也有动画
    basicAnimation.autoreverses = YES;
    
    [_imgView.layer addAnimation:basicAnimation forKey:@"BasicAnimation"];
    
    // 缩放动画
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    basicAnimation1.fromValue = @1;
    basicAnimation1.toValue = @2;
    basicAnimation1.duration = .35;
    basicAnimation1.repeatCount = MAXFLOAT;
    basicAnimation1.autoreverses = YES;
    [_imgView.layer addAnimation:basicAnimation1 forKey:nil];
}

- (void)startAnimation
{
    NSLog(@"startAnimation");
    
    // 获取共停止了多久
    CFTimeInterval stopTime = CACurrentMediaTime() - _imgView.layer.timeOffset;
    
    // 开始动画
    _imgView.layer.beginTime = stopTime;
    _imgView.layer.timeOffset = 0;
    _imgView.layer.speed = 1;
}

- (void)pauseAnimation
{
    NSLog(@"pauseAnimation");
    
    // 获取暂停的时间点
    CFTimeInterval pauseTime = [_imgView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 停止动画
    _imgView.layer.timeOffset = pauseTime;
    
    // 设置速度
    _imgView.layer.speed = 0;
}


@end
