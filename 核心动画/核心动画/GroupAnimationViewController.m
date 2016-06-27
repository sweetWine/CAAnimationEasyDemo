//
//  GroupAnimationViewController.m
//  核心动画
//
//  Created by ios on 16/6/27.
//
//

#import "GroupAnimationViewController.h"

@interface GroupAnimationViewController ()
{
    UIImageView *_imgView;
}
@end

@implementation GroupAnimationViewController

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
    
    // 抖动
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.ratation.z"];
    basicAnimation.duration = .35;
    basicAnimation.fromValue = @(-2);
    basicAnimation.toValue = @2;
    basicAnimation.repeatCount = MAXFLOAT;
    basicAnimation.autoreverses = YES;
    // 设置加速方式
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 移动
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.duration = 2.5;
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat width = point.x - _imgView.center.x;
    CGFloat height = point.y - _imgView.center.y;
    CGPathAddRect(path, nil, CGRectMake(_imgView.center.x, _imgView.center.y, width, height));
    keyFrameAnimation.path = path;
    CGPathRelease(path);
    
    // 组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[basicAnimation, keyFrameAnimation];
    groupAnimation.duration = 2.5;
    [_imgView.layer addAnimation:groupAnimation forKey:nil];
}


@end
