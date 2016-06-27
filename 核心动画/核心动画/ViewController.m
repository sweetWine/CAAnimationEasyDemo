//
//  ViewController.m
//  核心动画
//
//  Created by ios on 16/6/25.
//
//

#import "ViewController.h"
#import "BasicAnimationViewController.h"
#import "KeyFrameAnimationViewController.h"
#import "GroupAnimationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)basicAnimationAction:(id)sender {
    
    BasicAnimationViewController *basicAnimationVCtrl = [[BasicAnimationViewController alloc] init];
    [self.navigationController pushViewController:basicAnimationVCtrl animated:YES];
}

- (IBAction)keyFrameAnimationAction:(id)sender {
    
    KeyFrameAnimationViewController *keyFrameAnimationCtrl = [[KeyFrameAnimationViewController alloc] init];
    [self.navigationController pushViewController:keyFrameAnimationCtrl animated:YES];
}

- (IBAction)groupAnimationAction:(id)sender {
    
    GroupAnimationViewController *groupAnimationCtrl = [[GroupAnimationViewController alloc] init];
    [self.navigationController pushViewController:groupAnimationCtrl animated:YES];
}
@end
