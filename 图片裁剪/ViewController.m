//
//  ViewController.m
//  图片裁剪
//
//  Created by SethYin on 2017/1/10.
//  Copyright © 2017年 yanhuihui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self photoChange];
    [self photoChangeWithBorder];
}
//截屏
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //把控制器的view生成一张图片
    //1.开启一张位图上下文（和当前控制器view一样大小的尺寸）
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    //2.把控制器的view绘制到上下文当中
      //想要把view上的东西绘制到上下文当中，必须使用渲染的方式
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    //3.从上下文当中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭上下文
    UIGraphicsEndImageContext();
//    self.image.image = newImage;
    //把生成的图片写入到桌面（以文件的方式进行传输： 二进制:NSData）
    //把图片转成二进制流NSData
//   NSData *data = UIImageJPEGRepresentation(newImage, 1);
    NSData *data = UIImagePNGRepresentation(newImage);
    [data writeToFile:@"/Users/sethyin/Desktop/newImage.png" atomically:YES];
}
//带边框的裁剪
-(void)photoChangeWithBorder
{
    //0.加载图片
    UIImage *image = [UIImage imageNamed:@"3"];
    //1.确定边框宽度
    CGFloat borderW = 10;
    //开启一个上下文
    CGSize size = CGSizeMake(image.size.width + 2* borderW, image.size.height + 2 * borderW);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //2.绘制大圆，显示出来
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    [[UIColor redColor] set];
    [path fill];
    //3.绘制一个小圆，把小圆设置成剪裁区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderW, borderW, image.size.width, image.size.height)];
    [clipPath addClip];
    //4.把图片绘制到上下文当中
    [image drawAtPoint:CGPointZero];
    //5.从上下文当中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //6.关闭上下文
    UIGraphicsEndImageContext();
    self.image.image = newImage;
}
//不带边框的裁剪
-(void)photoChange{
    //0. 加载图片
    UIImage *image = [UIImage imageNamed:@"3"];
    //1.开启和原始图片一样大小的上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.设置一个图形裁剪区域
    //2.1绘制一个圆形
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //2.2 把圆形路径设置成裁剪区域
    [path addClip];
    //3.把图片绘制到上下文当中（超过剪裁区域以外的内容都剪裁掉）
    [image drawAtPoint:CGPointZero];
    //4.从上下文当中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭上下文
    UIGraphicsEndImageContext();
    self.image.image = newImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
