//
//  BottomTBvc.m
//  测试推拉View
//
//  Created by andy  on 15/6/17.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "BottomTBvc.h"
#import "UIView+Extension.h"

@interface BottomTBvc ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *datas;
@property (nonatomic ,strong)UILabel *showInfoLable;
@property (nonatomic ,assign)CGFloat contentY;
@end

@implementation BottomTBvc
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = self.view.bounds;
        _tableView.height = _tableView.height - 69;
        _tableView.y = 69;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
}
-(void)setupView{
    UIView *naviView = [[UIView alloc]init];
    naviView.height = 69;
    naviView.width = self.view.width;
    naviView.backgroundColor = [UIColor redColor];
    [self.view addSubview:naviView];
    self.datas = @[@"1",@"2",@"3",@"4",@"5"];
    [self.view addSubview:self.tableView];
    
    UILabel *showInfo = [[UILabel alloc]init];
    self.showInfoLable = showInfo;
    showInfo.y = 40;
    showInfo.width = self.view.width;
    showInfo.height = 150;
    showInfo.text = @"下拉回到“商品详情”";
    showInfo.textColor = [UIColor blackColor];
    showInfo.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:showInfo belowSubview:naviView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CEELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)contentY
{
    if (_contentY == 0) {
        _contentY = -65;
    }
    return _contentY;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@ - %f",NSStringFromClass([self class]),scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < self.contentY) {

        self.showInfoLable.text = @"释放回到“商品详情”";
    }else{
        self.showInfoLable.text = @"下拉回到“商品详情”";;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < self.contentY) {
        if ([self.delegate respondsToSelector:@selector(bottomTBvc:DidScroolTo:)]) {
            [self.tableView setScrollEnabled:NO];
            [self.delegate bottomTBvc:self DidScroolTo:self.contentY];
            [self.tableView setScrollEnabled:YES];
        }
    }
}


@end
