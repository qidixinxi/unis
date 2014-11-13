//
//  FaceSignListViewController.m
//  UNITOA
//
//  Created by qidi on 14-11-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FaceSignListViewController.h"
#import "CreatSignViewController.h"
#import "CreateSginListViewController.h"
#import "SignInJoinListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
@interface FaceSignListViewController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UITableView *_tableView;
    NSArray *dataList;
    NSString *address;
    
    BMKLocationService *_locationServer;
}
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation FaceSignListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //[self getMyLocation];
    [self navigation];
    dataList = @[LOCALIZATION(@"scan_signin"),LOCALIZATION(@"creat_signin"),LOCALIZATION(@"my_creat_signin"),LOCALIZATION(@"partin_signin")];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.editing = NO;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}
#pragma mark -------------UITableViewDelegate----------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataList count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"Fcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = dataList[indexPath.row];
    cell.textLabel.textColor = GETColor(109, 109, 109);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
           // [self scanBtnAction];
            [self geoCodeSearch];
        }
            
            break;
        case 1:{
            CreatSignViewController *createSign = [[CreatSignViewController alloc]init];
            [self.navigationController pushViewController:createSign animated:YES];
        }
            
            break;
        case 2:
        {
            CreateSginListViewController *signList = [CreateSginListViewController new];
            [self.navigationController pushViewController:signList animated:YES];
        }
            break;
        case 3:
        {
            SignInJoinListViewController *joinSign = [[SignInJoinListViewController alloc]init];
            [self.navigationController pushViewController:joinSign animated:YES];
        }
            break;
            
        default:
            break;
    }
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
    loginLabel.text = LOCALIZATION(@"face_sign_in");
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
#pragma mark -------- setExtraCellLineHidden -----------
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    view = nil;
}
- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];

    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    [reader setAllowsEditing:NO];
    reader.showsHelpOnFail = NO;
    reader.readerView.torchMode = 0;
    reader.scanCrop = CGRectMake(0.12, 0.18, 0.8, 0.8);//扫描的感应框
    reader.readerView.scanCrop =  CGRectMake(((SCREEN_WIDTH - 260)/2)/SCREEN_WIDTH, 80/SCREEN_WIDTH, 260/SCREEN_WIDTH, 260/SCREEN_HEIGHT);
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.image = [UIImage imageNamed:@"pick_bbg"];
    
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] init];
    image.frame = CGRectMake((SCREEN_WIDTH - 260)/2, 80, 260, 260);
    image.backgroundColor = [UIColor clearColor];
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    [self presentViewController:reader animated:YES completion:nil];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(20, 2*num, 220, 2);
        if (2*num == 244) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(20, 2*num, 220, 2);
        if (num == 10) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //初始化
    ZBarReaderController * read = [ZBarReaderController new];
    //设置代理
    read.readerDelegate = self;
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol * symbol = nil;
    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
    for (symbol in results)
    {
        break;
    }
    NSString * result;
    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
        
    {
        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    else
    {
        result = symbol.data;
    }
    if (result.length != 0) {
    // result可能取值为空的处理
    NSDictionary *parameter = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"barcode":result,@"latitude":[SingleInstance shareManager].latitude,@"longitude":[SingleInstance shareManager].longitude,@"address":address};
    [AFRequestService responseData:FACE_SIGNIN_URL andparameters:parameter andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if (CODE_NUM == CODE_SUCCESS) {
            [timer invalidate];
            [picker dismissViewControllerAnimated:YES completion:^{
                [ZSTool presentAlert:@"签到成功！"];
                [picker removeFromParentViewController];
                
            }];
        }
        else if(CODE_NUM == 1){
            [ZSTool presentAlert:@"用户验证参数错误!"];
        }
        else if (CODE_NUM == 2){
            [ZSTool presentAlert:@"签到已经过期!"];
        }
        else if (CODE_NUM == 3){
            [ZSTool presentAlert:@"签到已经过期!"];
        }
    }];
     }
    else{
        [ZSTool presentAlert:@"扫描失败，请重新扫描！"];
    }
    
}
#pragma mark -------- BMKGeoCodeSearchDelegate -------------
- (void)geoCodeSearch{
    BMKGeoCodeSearch *geoCode = [[BMKGeoCodeSearch alloc]init];
    geoCode.delegate = self;
    BMKReverseGeoCodeOption *rever = [[BMKReverseGeoCodeOption alloc]init];
    CLLocationCoordinate2D location;
    Float64 lat = [[SingleInstance shareManager].latitude floatValue];
    Float64 logi = [[SingleInstance shareManager].longitude floatValue];
    location.latitude = lat;
    location.longitude = logi;
    rever.reverseGeoPoint = location;
    [geoCode reverseGeoCode:rever];
}
//- (void)getMyLocation{
//    if (IOS8_LATER) {
//        //由于IOS8中定位的授权机制改变 需要进行手动授权
//       CLLocationManager *_locationManager = [[CLLocationManager alloc] init];
//        //获取授权认证
//        [_locationManager requestAlwaysAuthorization];
//        [_locationManager requestWhenInUseAuthorization];
//    }
//    _locationServer = [[BMKLocationService alloc]init];
//    _locationServer.delegate = self;
//    [_locationServer startUserLocationService];
//}
//// 用户方向更新后调用的方法
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
//    
//    if (userLocation.location.coordinate.latitude == 0.0 || userLocation.location.coordinate.longitude == 0.0) {
//        [_locationServer stopUserLocationService];
//        [_locationServer startUserLocationService];
//    }
//    else{
//        [_locationServer stopUserLocationService];
//
//    }
//    
//}
// 用户位置更新后调用的方法
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation.location.coordinate.latitude == 0.0 || userLocation.location.coordinate.longitude == 0.0) {
        [_locationServer stopUserLocationService];
        [_locationServer startUserLocationService];
    }
    else{
        [_locationServer stopUserLocationService];
    }
    
    
}
#pragma mark 获取到物理地址信息
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    address = result.address;
    [self scanBtnAction];
}
- (void)dealloc{
    _locationServer.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
