//
//  GIFAnimationView.m
//  SuperWatch
//
//  Created by pro on 17/2/15.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "GIFAnimationView.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
//#import <ImageIO/ImageIO.h>
#import "UIView+CLExtension.h"

@interface GIFAnimationView ()
{
    CGFloat height;
    CGFloat width;
}
@property (nonatomic , strong) UILabel * connectStatus;
@property (nonatomic , strong) UILabel * BM;
@property (nonatomic, strong) NSTimer * timer;

@property (nonatomic , strong) UIImageView * GIFimg;
//@property (nonatomic , strong) UILabel * GIFlabel;

//@property (nonatomic , strong) OLImageView * GIFimg;

@end
@implementation GIFAnimationView

-(void)startTimer{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePromitLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];


    [_GIFimg startAnimating];
}
- (void)pauserTimer{
    [self.timer invalidate];
    self.timer = nil;

    [_GIFimg stopAnimating];
}
- (void)setStatus:(NSString *)status{
    _status = status;
    _connectStatus.text = [NSString stringWithFormat:@"连接状态:%@",status];
}

- (void)updatePromitLabel{


    if ([_BM.text isEqualToString:@"BM:计算中·"]) {
        _BM.text = @"BM:计算中··";
//        _GIFlabel.text = @"测量中···";
    } else if ([_BM.text isEqualToString:@"BM:计算中··"]){
        _BM.text = @"BM:计算中···";
//        _GIFlabel.text = @"测量中·";
    } else if ([_BM.text isEqualToString:@"BM:计算中···"]){
        _BM.text = @"BM:计算中·";
//        _GIFlabel.text = @"测量中··";
    }else{
        _BM.text = @"BM:计算中·";
//        _GIFlabel.text = @"测量中··";
    }
    
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.backgroundColor = RGBA(0, 0, 0, 0.7);

        [self setupGIFView];

        self.hidden = YES;
    }
    return self;
}


- (void)setupGIFView{

    _connectStatus = [[UILabel alloc] init];
    _connectStatus.text = @"连接状态:未连接";
    _connectStatus.font = [UIFont systemFontOfSize:15.0];
    _connectStatus.textAlignment = NSTextAlignmentLeft;
    _connectStatus.textColor =[UIColor colorWithHexString:@"#737f7f"]; //[UIColor colorWithHexString:@"#9aa9a9"];
    [self addSubview:_connectStatus];



    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cl_width, self.cl_height)];
//    view.backgroundColor = RGBA(0, 0, 0, 0.7);
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];

    _GIFimg = [[UIImageView alloc] init];
    [_GIFimg sizeToFit];
    _GIFimg.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"measure_icon_thin"],[UIImage imageNamed:@"measure_icon_normal"],[UIImage imageNamed:@"measure_icon_fat"],[UIImage imageNamed:@"measure_icon_overweight"], nil];
    _GIFimg.animationDuration = 0.7;
    [view addSubview:_GIFimg];

    _BM = [[UILabel alloc] init];
    _BM.text = @"BM:计算中·";
    _BM.textColor =[UIColor colorWithHexString:@"#737f7f"];// [UIColor colorWithHexString:@"#9aa9a9"];
    _BM.font = [UIFont systemFontOfSize:15.0];
    _BM.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_BM];


//    _GIFlabel = [[UILabel alloc] init];
//    _GIFlabel.text = @"测量中··";
//    _GIFlabel.textColor = [UIColor colorWithHexString:@"eeffff"];
//    _GIFlabel.font = [UIFont systemFontOfSize:15];
//    _GIFlabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:_GIFlabel];
//    [self setupGIFimg:view];


}
- (void)layoutSubviews{
    [super layoutSubviews];

    [_connectStatus mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(11);
        make.width.equalTo(self);
        make.height.mas_equalTo(21);
    }];

    [_GIFimg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
//        make.bottom.equalTo(_BM.mas_top).offset(-20);
        make.height.mas_equalTo(self.cl_height/2);
        make.width.mas_equalTo(self.cl_width/2-50);
    }];


    [_BM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_GIFimg.mas_bottom).offset(20);
//        make.centerY.equalTo(self).offset(100);
        make.width.equalTo(self);
        make.height.mas_equalTo(21);
    }];



//    [_GIFlabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.equalTo(_BM);
//        make.height.width.equalTo(_BM);
//    }];

}

//- (void)setupGIFimg:(UIView *)superView{



//    _GIFimg = [[OLImageView alloc] initWithImage:[OLImage imageNamed:@"measure_icon_loading.gif"]];
//    [superView addSubview:_GIFimg];
//#pragma clang diagnostic ignored "-Wnonnull"
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"measure_icon_loading@3x" ofType:@"gif"];
//    NSData *gifData = [NSData dataWithContentsOfFile:path];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.frame];
//
//    webView.scalesPageToFit = YES;
//    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    webView.backgroundColor = [UIColor clearColor];
//    webView.opaque = NO;
//    [superView addSubview:webView];



//    NSURL * fileUrl = [[NSBundle mainBundle] URLForResource:@"measure_icon_loading@3x" withExtension:@"gif"];
//    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);
//    size_t frameCout = CGImageSourceGetCount(gifSource);
//    NSMutableArray * frame = [[NSMutableArray alloc] init];
//
//    for (size_t i = 0; i < frameCout; i++) {
//        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
//        UIImage * imageName = [UIImage imageWithCGImage:imageRef];
////        height = imageName.size.height;
////        width = imageName.size.width;
//        [frame addObject:imageName];
//        CGImageRelease(imageRef);
//    }
//    _GIFimg = [[UIImageView alloc] init];
//    _GIFimg.animationImages = frame;
//    _GIFimg.animationDuration = 1;
//
//    [superView addSubview:_GIFimg];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
