//
//  LaunchView.m
//  SuperWatch
//
//  Created by pro on 17/2/10.
//  Copyright © 2017年 pro. All rights reserved.
//

#import "LaunchView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//static NSString *const adImageName = @"adImageName";
@interface  LaunchView()

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, strong) UIImageView *aDImgView;

///跳过按钮 可自定义
@property (nonatomic, strong) UIButton *skipBtn;

@property (nonatomic, assign) int count;


@property (nonatomic , strong) UIView * logoView;

@end


// 广告显示的时间
static int const showtime = 3;

@implementation LaunchView

- (NSTimer *)countTimer
{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (UIView *)logoView{

    if (!_logoView) {
        _logoView = [[UIView alloc] initWithFrame:CGRectMake(0, mainHeight*0.84, mainWidth, mainHeight*0.16)];
        _logoView.backgroundColor = [UIColor whiteColor];
        UIImageView * img = [[UIImageView alloc] init];
        img.backgroundColor = [UIColor brownColor];
        img.image =[UIImage imageNamed:@"logo"];
        [_logoView addSubview:img];

        UILabel * topLabel = [[UILabel alloc] init];
        topLabel.text = @"地尔体脂秤";
        topLabel.font = [UIFont systemFontOfSize:16];
        topLabel.textColor = [UIColor colorWithHexString:@"#303434"];
        [_logoView addSubview:topLabel];

        UILabel * underLabel = [[UILabel alloc] init];
        underLabel.text = @"关注您的健康";
        underLabel.font = [UIFont systemFontOfSize:14];
        underLabel.textColor = [UIColor colorWithHexString:@"#737f7f"];
        [_logoView addSubview:underLabel];

        [img mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_logoView.mas_centerX).offset(-20);
            make.height.width.mas_equalTo(48);
            make.centerY.equalTo(_logoView);
        }];

        [topLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_logoView.mas_centerX);
            make.bottom.equalTo(img.mas_centerY).offset(-4);
        }];

        [underLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topLabel);
            make.top.equalTo(img.mas_centerY).offset(4);
        }];

    }
    return _logoView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
     


//        self.frame = CGRectMake(0, 0, mainWidth, mainHeight);

        self.aDImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight*0.84)];
        [self addSubview:_aDImgView];
        _aDImgView.userInteractionEnabled = YES;
        [self addSubview:self.logoView];
//
//
//
//
//        // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
//        NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
//
//
//        BOOL isExist = [self isFileExistWithFilePath:filePath];
//        if (isExist) {// 图片存在
//
//            _aDImgView.image = [UIImage imageWithContentsOfFile:filePath];
//        }else{
//            _aDImgView.image = [UIImage imageNamed:@"01_启动页.jpg"];
//
//        }
//
//        // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
//        [self getAdvertisingImage];

        self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.skipBtn.backgroundColor = RGBA(241, 242, 248, 0.5);
        self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _skipBtn.layer.cornerRadius = 12.0;
        _skipBtn.layer.masksToBounds = YES;
        self.skipBtn.layer.borderWidth = 0.5f;
        self.skipBtn.layer.borderColor = [UIColor colorWithHexString:@"#c9cdcd"].CGColor;
        [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%d秒",showtime] forState:UIControlStateNormal];
        [_skipBtn setTitleColor:[UIColor colorWithHexString:@"#565c5c"] forState:UIControlStateNormal];

        [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.aDImgView addSubview:_skipBtn];



        [_skipBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_aDImgView).offset(-12);
//            make.bottom.equalTo(adImageName).offset(-12);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(68);
        }];


    }

    return self;

}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    if ([filePath containsString:@".jpg"]) {
        _aDImgView.image = [UIImage imageNamed:filePath];
    }else{
        _aDImgView.image = [UIImage imageWithContentsOfFile:filePath];
    }

}


- (void)countDown
{
    _count --;
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%d秒",_count] forState:UIControlStateNormal];
    if (_count == 0) {

        [self skipBtnClick];
    }
}

- (void)show{
    // 倒计时方法2：定时器
    [self startTimer];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

}

// 定时器倒计时
- (void)startTimer
{
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}



// 移除广告页面
- (void)skipBtnClick{

    [self.countTimer invalidate];
    self.countTimer = nil;

    [UIView animateWithDuration:0.3f animations:^{

        self.alpha = 0.f;

    } completion:^(BOOL finished) {

        [self removeFromSuperview];

    }];


}



/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage
{

    // TODO 请求广告接口

    // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];

    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;

    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片

        [self downloadAdImageWithUrl:imageUrl imageName:imageName];

    }

}


/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];

        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称

        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }

    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}


/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];

        return filePath;
    }

    return nil;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
