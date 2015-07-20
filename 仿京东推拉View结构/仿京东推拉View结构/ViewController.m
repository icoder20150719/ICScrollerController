//
//  ViewController.m
//  仿京东推拉View结构
//
//  Created by andy  on 15/6/17.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#import "BottomTBvc.h"

@interface ViewController ()<BottomTBvcDelegate>
@property(nonatomic ,weak)UIScrollView *bgView;
@property(nonatomic ,weak)UIView *topView;
@property(nonatomic ,weak)UIView *bottomView;
@property(nonatomic ,weak)UIView *midView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建View
    [self setupView];
    //添加监听
    [self.bgView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"topScontentOffset"];
}
-(void)setupView{
    //1。创建底图
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    self.bgView = bgView;
    bgView.backgroundColor = [UIColor grayColor];
    
    //2.创建上图
    UIView *topView = [[UIView alloc]initWithFrame:self.view.bounds];
    topView.height = 1000;
    topView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:topView];
    UIButton *refreshBtn = [[UIButton alloc]init];
    refreshBtn.backgroundColor = [UIColor yellowColor];
    refreshBtn.width = topView.width;
    refreshBtn.height = 60;
    refreshBtn.y = topView.height - refreshBtn.height;
    [refreshBtn setTitle:@"上拉刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [refreshBtn addTarget: self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:refreshBtn];
    self.midView = refreshBtn;
    self.topView =  topView;
    
    //3.创建下图
    BottomTBvc *bottomView = [[BottomTBvc alloc]init];
    bottomView.view.frame = self.view.bounds;
    bottomView.delegate = self;
    bottomView.view.y = CGRectGetMaxY(topView.frame);
    [self addChildViewController:bottomView];
    self.bottomView = bottomView.view;
    
    [bgView addSubview:bottomView.view];
    //设置底图的Contentsize；
    bgView.contentSize = CGSizeMake(0, CGRectGetMaxY(topView.frame));

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *ctx = [NSString stringWithFormat:@"%@",context];
    NSValue *vale = change[@"new"];
    CGPoint offset = [vale CGPointValue];
//    NSLog(@" Ccontenszie %f--- topS %f",self.bgView.contentSize.height,offset.y);
    if ([ctx isEqualToString:@"topScontentOffset"]) {
        if (offset.y > self.bgView.contentSize.height - self.view.height + 100 ) {
            [self creatBottomView];
        }
    }
}
#pragma mark - 底部View
- (void)creatBottomView {
    
    [self.bgView removeObserver:self forKeyPath:@"contentOffset"];
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat transHeight = -(self.topView.frame.size.height);
        self.topView.transform = CGAffineTransformMakeTranslation(0, transHeight + self.bgView.contentSize.height - self.view.height  );
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, transHeight + self.bgView.contentSize.height - self.view.height );
    } completion:^(BOOL finished) {
          [self.bgView setScrollEnabled:NO];
    }];
}
#pragma mark - 上部分View
- (void)creatTopView {
    self.bgView.contentOffset = CGPointMake(0, self.bgView.contentSize.height - self.view.height);
    [self.bgView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"topScontentOffset"];
     [self.bgView setScrollEnabled:YES];
    
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.topView.transform = CGAffineTransformIdentity;
        self.bottomView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - BottomTBvcDelegate
-(void)bottomTBvc:(BottomTBvc *)bottomVc DidScroolTo:(CGFloat)contentY{
    [self creatTopView];
}
- (void)refresh {
    [self creatBottomView];
}

@end
