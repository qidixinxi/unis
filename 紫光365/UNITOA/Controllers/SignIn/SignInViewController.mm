//
//  SignInViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SignInViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SignInTableViewCell.h"
@interface SignInViewController ()<UITableViewDataSource,UITableViewDelegate,BMKPoiSearchDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>
{
    UITableView *_tableView;
    BMKPoiSearch *_poisearch;
    NSMutableArray *locationArray;
    CLLocationManager  *_locationManager;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     locationArray = [[NSMutableArray alloc]init];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (IOS8_LATER && self.locationManager == nil) {
        //由于IOS8中定位的授权机制改变 需要进行手动授权
        self.locationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self navigation];
    [self getMyLocation];
    [self creatTable];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    
    
    
    
    [_locService stopUserLocationService];
}
#pragma mark -------- navigation---------------
- (void)navigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 40)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"return_unis_logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:image];
    
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, (44 - image.size.height)/2, image.size.width, image.size.height);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(image.size.width + 5, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"sign_in");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgNavi addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getMyLocation{
    _mapView = [BMKMapView new];
    _mapView.backgroundColor = [UIColor redColor];
     _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _mapView.mapType=BMKMapTypeStandard;
    _mapView.zoomLevel = 18;
    
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _locService.delegate = self;
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层

}
- (void)creatTable{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:self.tableView];
}
#pragma mark -------------Get Near Location -----------------
- (void)GetLocationNear:(CLLocationCoordinate2D)loction{
     NSLog(@"%.7f === %.7f",loction.longitude,loction.latitude);
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    _poisearch =[[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    BMKNearbySearchOption *nearSearchOption = [[BMKNearbySearchOption alloc]init];
    nearSearchOption.pageIndex = 1;
    nearSearchOption.pageCapacity = 50;
    nearSearchOption.location = loction;
    NSLog(@"%.2f === %.2f",nearSearchOption.location.longitude,nearSearchOption.location.latitude);
    nearSearchOption.radius = 1000;
    nearSearchOption.keyword =@"科技大厦，公司";
    BOOL flag = [_poisearch poiSearchNearBy:nearSearchOption];
    if(flag){
     
    }
    else{
    }
}
#pragma mark -------------UITableViewDelegate----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [locationArray count] + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 400;
    }
    else{
        return 50;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName;
    if (indexPath.row == 0) {
        cellName = @"Fcell";
    }
    else{
         cellName = @"Fcell1";
    }
   
    SignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SignInTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.nameLable.hidden = YES;
        cell.detailNameLable.hidden = YES;
        cell.signBtn.hidden = YES;
        _mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 400);
        [cell addSubview:_mapView];
        return cell;
    }
    else{
        cell.nameLable.hidden = NO;
        cell.detailNameLable.hidden = NO;
        cell.signBtn.hidden = NO;
        BMKPoiInfo *model = (BMKPoiInfo *)locationArray[indexPath.row - 1];
        cell.nameLable.text = model.name;
        cell.detailNameLable.text = model.address;
        cell.signBtn.tag = 100 +indexPath.row - 1;
        [cell.signBtn addTarget:self action:@selector(signBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (void)signBtn:(UIButton *)sender{
    NSInteger btnTag = sender.tag - 100;
    BMKPoiInfo *model = (BMKPoiInfo *)locationArray[btnTag];
    NSString *latitude = [NSString stringWithFormat:@"%.7f",model.pt.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.7f",model.pt.longitude];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"latitude":latitude,@"longitude":longitude,@"address":model.address,@"name":model.name};
    [AFRequestService responseData:SIGN_IN_URL andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if (CODE_NUM == CODE_SUCCESS) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshData)]) {
                [self.delegate refreshData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -----------CLLocationManagerDelegate--------------------
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self GetLocationNear:newLocation.coordinate];
}
#pragma mark 在地图View停止定位后，会调用此函数
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
}
#pragma mark 定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
#pragma mark -----------BMKLocationServiceDelegate--------------------
//  开始启动定位
- (void)willStartLocatingUser{
    
}
// 在停止定位后调用测方法
- (void)didStopLocatingUser{
}
// 用户方向更新后调用的方法
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{

    if (userLocation.location.coordinate.latitude == 0.0 || userLocation.location.coordinate.longitude == 0.0) {
//        [_locService stopUserLocationService];
//        [_locService startUserLocationService];
    }
    else{
        [_locService stopUserLocationService];
        [_mapView updateLocationData:userLocation];
    }
    
}
// 用户位置更新后调用的方法
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude == 0.0 || userLocation.location.coordinate.longitude == 0.0) {
        [_locService stopUserLocationService];
        [_locService startUserLocationService];
    }
    else{
        [_locService stopUserLocationService];
        [_mapView updateLocationData:userLocation];
        [self GetLocationNear:userLocation.location.coordinate];
    }
    
    
}
#pragma mark --------- PoiSearchDeleage-----------------------------

- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    NSLog(@"%@",poiDetailResult.name);
}
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    [locationArray addObjectsFromArray:poiResult.poiInfoList];
    [self.tableView reloadData];
    
}

#pragma mark 获取到物理地址信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result.address);
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"%@",result.address);
}
@end
