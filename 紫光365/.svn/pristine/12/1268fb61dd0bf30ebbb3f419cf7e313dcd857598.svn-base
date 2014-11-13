//
//  CreateInfoDetailCell.m
//  GUKE
//
//  Created by soulnear on 14-10-6.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CreateInfoDetailCell.h"
#import "imgUploadModel.h"
#import "VideoUploadModel.h"
#import "VoiceRecorderBaseVC.h"

@interface MyAudioPlayer ()

@end

@implementation MyAudioPlayer
@synthesize aCell = _aCell;


@end


@implementation CreateInfoDetailCell
@synthesize delegate = _delegate;
@synthesize data_object = _data_object;
@synthesize player = _player;




- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filesImageViewTap:)];
    [self.files_imageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setInfoWith:(id)object
{
    _data_object = object;
    
    _files_label.frame = CGRectMake(110, 15,150, 15);
    _files_label.backgroundColor = [UIColor whiteColor];
    _files_label.font = [UIFont systemFontOfSize:13.0f];
    _files_label.textAlignment = NSTextAlignmentLeft;
    
    _files_size_label.frame = CGRectMake(110, 35, 80, 15);
    _files_size_label.backgroundColor = [UIColor whiteColor];
    _files_size_label.font = [UIFont systemFontOfSize:13.0f];
    _files_size_label.textColor = GETColor(156, 156, 156);
    _files_size_label.textAlignment = NSTextAlignmentLeft;
    
    if ([object isKindOfClass:[NSDictionary class]])///语音
    {
        NSDictionary * aDic = (NSDictionary *)object;
        
        if ([aDic objectForKey:@"fileurl"])
        {
            NSString * url = [aDic objectForKey:@"fileurl"];
            if([ZSTool judgeFileSuffixVoice:url])///声音
            {
                UIImage *image = [UIImage imageNamed:@"voice_L0.png"];
                self.voice_icon.frame = CGRectMake(8, (30 - image.size.height)/2, image.size.width, image.size.height);
                self.voice_icon.image = image;
                self.files_imageView.frame = CGRectMake(30,16, 60, 30);
                [self.files_imageView setImage:[UIImage imageNamed:@"task_voice"]];
                
                self.files_label.text = [aDic objectForKey:@"filename"];
                self.files_size_label.text = [NSString stringWithFormat:@"%.2f k",[[aDic objectForKey:@"filesize"] intValue]/1024.00];
                
            }else if ([ZSTool judgeFileSuffixImage:url])
            {
                [self.files_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[aDic objectForKey:@"previewurl"]]] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
                
                self.files_label.text = [aDic objectForKey:@"filename"];
                self.files_size_label.text = [NSString stringWithFormat:@"%.2f k",[[aDic objectForKey:@"filesize"] intValue]/1024.00];
                
            }else///视频
            {
                [self.files_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[aDic objectForKey:@"previewurl"]]] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
                self.files_label.text = [aDic objectForKey:@"filename"];
                self.files_size_label.text = [NSString stringWithFormat:@"%.2f k",[[aDic objectForKey:@"filesize"] intValue]/1024.00];
            }
            
        }else
        {
            self.voice_icon.frame = CGRectMake(38, 25, 20,33/27*20);
            self.voice_icon.image = [UIImage imageNamed:@"voice_L0.png"];
            self.files_imageView.frame = CGRectMake(30,20, 60, 30);
            [self.files_imageView setImage:[UIImage imageNamed:@"task_voice"]];
            
            self.files_label.text = [(NSMutableDictionary *)object objectForKey:@"content"];
            self.files_size_label.text = [NSString stringWithFormat:@"%@ k",[(NSMutableDictionary *)object objectForKey:@"length"]];
        }
        
    }else if ([object isKindOfClass:[imgUploadModel class]])///图片
    {
        imgUploadModel * model = (imgUploadModel*)object;
        UIImage * image = [UIImage imageWithData:model.imageData];
        
        self.files_imageView.image = image;
        
        self.files_label.text = model.imageName;
        self.files_size_label.text = [NSString stringWithFormat:@"%d k",model.imageData.length/1024];
        
    }else if ([object isKindOfClass:[VideoUploadModel class]])///视频
    {
        self.files_imageView.image = [UIImage imageNamed:@"guke_type_btn_zhantie_press"];
        
        self.files_label.text = ((VideoUploadModel *)object).fileName;
        self.files_size_label.text = [NSString stringWithFormat:@"%d k",((VideoUploadModel *)object).fileData.length/1024];
    }
    self.files_size_label.textColor = GETColor(156, 156, 156);
}

- (void)filesImageViewTap:(id)sender
{
    
    if ([_data_object isKindOfClass:[NSDictionary class]])///语音
    {
        NSDictionary * aDic = (NSDictionary *)_data_object;
        
        if ([aDic objectForKey:@"fileurl"])
        {
            NSString * url = [aDic objectForKey:@"fileurl"];
            if([ZSTool judgeFileSuffixVoice:url])///声音
            {
                PlayerModel * model = [[PlayerModel alloc] init];
                model.fileId = url;
                [self playNetWorkVoiceWith:model];
                
            }else if ([ZSTool judgeFileSuffixImage:url])
            {
                
                [self playNetworkPhotoWith:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]];
            }else///视频
            {
                [self playVideWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]];
            }
        }else///本地声音
        {
           NSString *path = [VoiceRecorderBaseVC getPathByFileName:[(NSMutableDictionary *)_data_object objectForKey:@"fid"]  ofType:@"wav"];
            [self playLocalVoiceWithPath:path];
        }
    }else if ([_data_object isKindOfClass:[imgUploadModel class]])///图片
    {
        imgUploadModel * model = (imgUploadModel*)_data_object;
        UIImage * image = [UIImage imageWithData:model.imageData];
        
        [self playLoacalPhotoWithData:image];
        
    }else if ([_data_object isKindOfClass:[VideoUploadModel class]])///视频
    {
        VideoUploadModel * model = (VideoUploadModel *)_data_object;
        [self playButtonTappedWihtPath:model.filePath];
    }
}

- (IBAction)deleteButtonTap:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteFilesTap:)]) {
        [_delegate deleteFilesTap:self];
    }
    
    
}



#pragma mark - 播放声音
///播放网络语音
-(void)playNetWorkVoiceWith:(PlayerModel *)model
{
    if (isAnimationVoice) {
        return;
    }
    
    [self startVoicePlaybalck];
    
    __weak typeof(self)bself = self;
    
    voicePlayCenter = [[VoicePlayCenter alloc] init];
    voicePlayCenter.playDelegate = self;// 播放声音的代理方法
    [voicePlayCenter downloadPlayVoice:model];
    voicePlayCenter.block = ^()
    {
        [bself stopVocicePlaybalck];
    };
}
///播放本地语音
-(void)playLocalVoiceWithPath:(NSString *)path
{
    
//    if (_delegate && [_delegate respondsToSelector:@selector(playVoiceTap:WithPath:)]) {
//        [_delegate playVoiceTap:self WithPath:path];
//    }
//    
    NSLog(@"点击播放录音的按钮----%d！----%@",[[NSFileManager defaultManager] fileExistsAtPath:path],path);

 
    if (isAnimationVoice) {
        return;
    }
    
    [self startVoicePlaybalck];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.player = [[MyAudioPlayer alloc] initWithData:data error:nil];
    self.player.delegate = self;
    self.player.aCell = self;
    [self.player prepareToPlay];
    [self.player play];
    self.player.volume = 1;
    
}

// 开始播放背景（动画）
-(void)startVoicePlaybalck
{
    if (!_voiceLeftImageArr) {
        _voiceLeftImageArr = [[NSArray alloc] initWithObjects:
                              [UIImage imageNamed:@"voice_L1.png"],
                              [UIImage imageNamed:@"voice_L2.png"],
                              [UIImage imageNamed:@"voice_L3.png"],nil];
    }
    
    
    
    self.voice_icon.animationImages = _voiceLeftImageArr;
    self.voice_icon.animationDuration = 1;
    isAnimationVoice = YES;
    [self.voice_icon startAnimating];
}

// 停止播放背景
-(void)stopVocicePlaybalck{
    isAnimationVoice = NO;
    [self.voice_icon stopAnimating];
    self.voice_icon.image = [UIImage imageNamed:@"voice_L0.png"];
}

#pragma mark player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (player == self.player)
    {
        [self stopVocicePlaybalck];
    }
    self.player = nil;
    self.player.delegate = nil;
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (player == self.player) {
        [self stopVocicePlaybalck];
    }
    self.player = nil;
    self.player.delegate = nil;
}


#pragma mark - 查看图片
///查看本地图片
-(void)playLoacalPhotoWithData:(UIImage *)data
{
    [self TapImageClickWith:data];
}

///查看网络图片
-(void)playNetworkPhotoWith:(NSString *)imageUrl
{
    [self TapImageClickWith:imageUrl];
}

#pragma mark - "分享图片"的放大以及保存 -
- (void)TapImageClickWith:(id)image_url
{
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    imgSaveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    if ([image_url isKindOfClass:[NSString class]])
    {
        [imgSaveView sd_setImageWithURL:[NSURL URLWithString:(NSString *)image_url]];
    }else
    {
        imgSaveView.image = (UIImage *)image_url;
    }
    
    
    imgSaveView.contentMode = UIViewContentModeScaleAspectFit;
    imgSaveView.userInteractionEnabled = YES;
    [background addSubview:imgSaveView];
    [self shakeToShow:imgSaveView];//放大过程中的动画
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suoxiao)];
    tap.numberOfTapsRequired = 1;
    [imgSaveView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [imgSaveView addGestureRecognizer:longPressGestureRecognizer];
    
    [self.window.rootViewController.view addSubview:background];
}

-(void)suoxiao
{
    [background removeFromSuperview];
}

-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)_longpress
{
    if (_longpress.state == UIGestureRecognizerStateCancelled) {
        return;
    }
    [self handleLongTouch];
    
}

//*************放大过程中出现的缓慢动画*************
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)handleLongTouch {
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    [sheet showInView:background];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        UIImageWriteToSavedPhotosAlbum(imgSaveView.image, nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储图片成功"
                                                        message:@"您已将图片存储于照片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZATION(@"dialog_ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
}



#pragma mark - 播放视频
///播放本地视频
-(void)playButtonTappedWihtPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    MPMoviePlayerViewController *movieVc=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //        //弹出播放器
    [[self returnVC] presentMoviePlayerViewControllerAnimated:movieVc];
}

///播放网络视频
-(void)playVideWithString:(NSString *)thestrUrl{
    NSLog(@"url --------   %@",thestrUrl);
    NSURL *videoUrl=[NSURL URLWithString:thestrUrl];
    MPMoviePlayerViewController *movieVc=[[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
    //弹出播放器
    
    [[self returnVC] presentMoviePlayerViewControllerAnimated:movieVc];
}

-(UIViewController *)returnVC
{
    UIViewController * vc = (UIViewController *)self.delegate;
    return vc;
}

@end
