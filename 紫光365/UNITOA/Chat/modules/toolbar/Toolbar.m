//
//  Toolbar.m
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-20.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import "Toolbar.h"
#import "AppDelegate.h"
@interface Toolbar()<HPGrowingTextViewDelegate>{
    //    UIButton *btn1;
    //    UIButton *btn2;
    //    UIButton *btn3;
    //    UIButton *btn4;
    //    UIButton *btn5;
    //    UIButton *btn6;
    HPGrowingTextView *_textView;
    //UIButton *recordBtn;
    UIImageView *recordBtn;
    
    BOOL isVoice;
    
    
    // -------更改的代码开头-------
    // "小话筒"按钮
    UIButton *voiceBtn;
    // "加号"按钮
    UIButton *plusSignBtn;
    // "照片"按钮
    UIButton *photoBtn;
    // "拍照"按钮
    UIButton *cameraBtn;
    // "粘贴"按钮
    UIButton *pasteBtn;
    // "发送"按钮
    UIButton *sendBtn;
    
    BOOL isKeyBoard;
    // -------更改的代码结尾-------
}

@property (nonatomic) CGFloat validScreenHeight;
@end

@implementation Toolbar

@synthesize delegate = _delegate;
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SSRCRelease(_textView);
    SSRCSuperDealloc;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        frame.size.height = defaultToolbarHeight;
        //        frame.size.width = 320;
        //        self.frame = frame;
        //        [self initialization];
        
        // -------更改的代码开头-------
        self.backgroundColor = [UIColor whiteColor];
        frame.size.height = 40;
        frame.size.width = 320;
        self.frame = frame;
//        self.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.2];
        self.backgroundColor = GETColor(249, 249, 249);
        [self creatUIOne];
        // -------更改的代码结尾-------
        
    }
    return self;
}
- (void)layoutS:(CGRect)frame{
    CGFloat side = 50.0f;
    CGFloat margin = 10.0f;
    CGFloat margin1 =  (frame.size.height - side)/2.0f;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
}


// -------更改的代码开头-------
- (void)creatUIOne
{
    voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(-7, -6, 66, 66);
    //voiceBtn.selected = NO;
    voiceBtn.tag = kbt_tag_toolbar + 0;
    //[voiceBtn setBackgroundImage:[UIImage imageNamed:@"chatting_setmode_voice_btn_normal"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"chatting_voice_btn_normal_ico"] forState:UIControlStateNormal];
    voiceBtn.imageEdgeInsets = UIEdgeInsetsMake(16, 18, 20, 18);
    [voiceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:voiceBtn];
    
    plusSignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plusSignBtn.frame = CGRectMake(320-58-7, -7, 66, 66);
//    [plusSignBtn setBackgroundImage:[UIImage imageNamed:@"chatting_setmode_btn_add"] forState:UIControlStateNormal];
    [plusSignBtn setImage:[UIImage imageNamed:@"chatting_btn_add_ico"] forState:UIControlStateNormal];
    plusSignBtn.imageEdgeInsets = UIEdgeInsetsMake(16, 18, 20, 18);
    plusSignBtn.hidden = NO;
    plusSignBtn.tag = kbt_tag_toolbar + 9;
    [plusSignBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusSignBtn];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(320-56-1, 8, 50, 34);
    sendBtn.layer.cornerRadius = 5;
//    sendBtn.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.5];
    [sendBtn.layer setMasksToBounds:YES];
    [sendBtn.layer setCornerRadius:5.0]; //设置矩圆角半径
    [sendBtn.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 128/255.0, 128/255.0, 128/255.0, 1 });
    [sendBtn.layer setBorderColor:colorref];//边框颜色
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.hidden = YES;
    sendBtn.tag = kbt_tag_toolbar + 5;
    [sendBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendBtn];
    
    // 文本输入框（H使用了PGrowingTextView开源代码）
    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(105/2, 8, 204, 40)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.isScrollable = NO;
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	_textView.minNumberOfLines = 1;
	_textView.maxNumberOfLines = 4;
	_textView.returnKeyType = UIReturnKeySend;
	_textView.font = [UIFont systemFontOfSize:15.0f];
    _textView.tag = textView_tag_toolbar;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.cornerRadius = 5;
    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = 0.5f;
    
    [self addSubview:_textView];
    
    // 按住说话的按钮
    recordBtn = [[UIImageView alloc] init];
    recordBtn.frame = _textView.frame;
    //    [recordBtn setBackgroundImage:[UIImage imageNamed:@"toolVoice.png"] forState:UIControlStateNormal];
    //recordBtn.tag = kbt_tag_toolbar + 6;
    recordBtn.alpha = 0;
    recordBtn.backgroundColor = [UIColor clearColor];
    recordBtn.layer.cornerRadius = 5;
    recordBtn.layer.masksToBounds = YES;
    recordBtn.userInteractionEnabled = YES;
    [recordBtn.layer setBorderWidth:0.5];   //边框宽度
    CGColorSpaceRef colorSpace2 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref2 = CGColorCreate(colorSpace2,(CGFloat[]){ 0.5, 0.5, 0.5, 1 });
    [recordBtn.layer setBorderColor:colorref2];//边框颜色
    //[recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
//    recordBtn.image = [UIImage imageNamed:@"main_task_bg"];
    //[recordBtn setBackgroundImage:[UIImage imageNamed:@"main_task_bg"] forState:UIControlStateNormal];
    //[recordBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:recordBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(220/2-80/2-10, 3, 80, 30);
    label.backgroundColor = [UIColor clearColor];
    label.text = @"按住说话";
    label.userInteractionEnabled = YES;
    [label setTextColor:[UIColor grayColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    [recordBtn addSubview:label];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.1;
    [recordBtn addGestureRecognizer:longPressGestureRecognizer];
    // 创建照片 拍照 粘贴 按钮
    
    
    photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(45, 55, 50, 50);
    photoBtn.backgroundColor = [UIColor clearColor];
    photoBtn.tag= kbt_tag_toolbar + 1;
    [photoBtn setImage:[UIImage imageNamed:@"type_btn_pick_photo"] forState:UIControlStateNormal];
    [photoBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [photoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoBtn];
    
    cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(45+90, 55, 50, 50);
    cameraBtn.backgroundColor = [UIColor clearColor];
    cameraBtn.tag = kbt_tag_toolbar + 2;
    [cameraBtn setImage:[UIImage imageNamed:@"type_btn_take_photo"] forState:UIControlStateNormal];
    [cameraBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [cameraBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cameraBtn];
    
    pasteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pasteBtn.frame = CGRectMake(45+90*2, 55, 50, 50);
    pasteBtn.backgroundColor = [UIColor clearColor];
    pasteBtn.tag = kbt_tag_toolbar + 3;
    [pasteBtn setImage:[UIImage imageNamed:@"type_btn_zhantie_default"] forState:UIControlStateNormal];
    [pasteBtn setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [pasteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pasteBtn];
    
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(45+90*i, 83, 50, 50);
        label.textColor = [UIColor grayColor];
        label.tag = kbt_tag_toolbar+101+i;
        label.alpha = 0.8f;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13.0f];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        if (i==0) {
            label.text = @"照片";
        }else if (i==1){
            label.text = @"拍照";
        }else{
            label.text = @"粘贴";
        }
    }
}


// -------更改的代码结尾-------


//- (void)initialization{
//    self.backgroundColor = [UIColor purpleColor];
//
//    CGFloat side = 33.0f;
//    CGFloat side_l = 40.0f;
//    CGFloat left_margin = 10.0f;
//    CGFloat up_margin = 5.0f;
//    CGFloat edg = (side_l-side)/2;
//
//
//    // 循环创建按钮
//    for (int i = 0; i < 6; i ++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGRect r = CGRectMake(left_margin+(side_l+0)*i, up_margin, side_l, side_l);
//        if (i == 5) {
//            r.size.width += 20;
//        }
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(edg, edg, edg, edg)];
//
//        btn.frame = r;
//
//        btn.tag = kbt_tag_toolbar + i;
//        [self addSubview:btn];
//
//        if (i == 0) {// 语音和键盘的切换按钮
//            [btn setImage:[UIImage imageNamed:@"chatting_setmode_voice_btn_normal.png"] forState:UIControlStateNormal];
//            btn1 = btn;
//        }else if (i == 1){// 照片库
//            [btn setImage:[UIImage imageNamed:@"type_btn_pick_photo.png"] forState:UIControlStateNormal];
//            btn2 = btn;
//        }else if (i == 2){// 照相
//            [btn setImage:[UIImage imageNamed:@"type_btn_take_photo.png"] forState:UIControlStateNormal];
//            btn3 = btn;
//        }else if (i == 3){// 粘贴
//            [btn setImage:[UIImage imageNamed:@"type_btn_zhantie_default.png"] forState:UIControlStateNormal];
//            btn4 = btn;
//        }else if (i == 4){// 语音音量
//            [btn setImage:[UIImage imageNamed:@"chat_btn_bigvoice.png"] forState:UIControlStateNormal];
//            btn5 = btn;
//        }else if (i == 5){ // 发送按钮
////            [btn setImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
//            [btn setBackgroundImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
//            [btn setTitle:@"发送" forState:UIControlStateNormal];
//            btn6 = btn;
//        }
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    // 文本输入框（H使用了PGrowingTextView开源代码）
//    _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(left_margin, side_l+2*up_margin, 320-2*left_margin, 40)];
//    _textView.isScrollable = NO;
//    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
//
//	_textView.minNumberOfLines = 1;
//	_textView.maxNumberOfLines = 2;
//    // you can also set the maximum height in points with maxHeight
//    // textView.maxHeight = 200.0f;
//	_textView.returnKeyType = UIReturnKeySend; //
//	_textView.font = [UIFont systemFontOfSize:15.0f];
//	_textView.delegate = self;
//    _textView.tag = textView_tag_toolbar;
//    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
//    _textView.backgroundColor = [UIColor whiteColor];
//    _textView.layer.cornerRadius = 5;
//    [self addSubview:_textView];
//
//    // 按住说话的按钮
//    recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    recordBtn.frame = _textView.frame;
//    //    [recordBtn setBackgroundImage:[UIImage imageNamed:@"toolVoice.png"] forState:UIControlStateNormal];
//    recordBtn.tag = kbt_tag_toolbar + 6;
//    recordBtn.alpha = 0;
//    recordBtn.backgroundColor = [UIColor redColor];
//    recordBtn.layer.cornerRadius = 5;
//    recordBtn.layer.masksToBounds = YES;
//    [recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
//    [recordBtn setBackgroundImage:[UIImage imageNamed:@"main_task_bg.png"] forState:UIControlStateNormal];
//    [recordBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
//    [self addSubview:recordBtn];
//}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSLog(@"测试");
    if (growingTextView.text.length!=0) {
        plusSignBtn.hidden = YES;
        sendBtn.hidden = NO;
    }else{
        plusSignBtn.hidden = NO;
        sendBtn.hidden = YES;
    }
}

- (void)gestureRecognizerHandle:(id)sender
{
    UILongPressGestureRecognizer *tap = (UILongPressGestureRecognizer *)sender;
    if (tap.state == UIGestureRecognizerStateBegan) {
        [self.delegate recordStartQiDi];
    }

    if (tap.state == UIGestureRecognizerStateEnded) {
        [self.delegate recordEndQiDi];
    }
}



// 各个btn的点击事件
- (void)btnClick:(UIButton *)sender{
    //
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolView:index:)]) {
        [self.delegate toolView:self index:sender.tag-kbt_tag_toolbar];
    }
    
    switch (sender.tag - kbt_tag_toolbar) {
        case 0:
            [self voiceShow];
            break;
        case 3:
            _textView.text = [NSString stringWithFormat:@"%@",
                                 [[UIPasteboard generalPasteboard] string]];
        case 9:
            //NSLog(@"测试一下");
            isKeyBoard = !isKeyBoard;
            if (isKeyBoard) {// 如果是语音按钮
                CGRect r = self.frame;
                r.size.height += 80;
                r.origin.y -= 80;
                [self setNewFrame:r];// 重新设置textView的高度
                
            }else{// 如果不是语音按钮
                CGRect r = self.frame;
                r.size.height -= 80;
                r.origin.y += 80;
                [self setNewFrame:r];// 重新设置textView的高度
            }
            
        default:
            break;
    }
}

// 点击语音和键盘切换的按钮出发的事件
- (void)voiceShow{
    //_textView.text = @"";
    isVoice = !isVoice;
    if (isVoice) {// 如果是语音按钮
        [self endEditing:NO];
        recordBtn.alpha = 1;
        _textView.alpha = 0;
//        [voiceBtn setBackgroundImage:[UIImage imageNamed:@"chatting_keyboard_btn_normal"] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageNamed:@"chatting_keyboard_btn_normal"] forState:UIControlStateNormal];
        
    }else{// 如果不是语音按钮
        _textView.alpha = 1;
        recordBtn.alpha = 0;
        //[voiceBtn setBackgroundImage:[UIImage imageNamed:@"chatting_voice_btn_normal_ico"] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageNamed:@"chatting_voice_btn_normal_ico"] forState:UIControlStateNormal];
    }
}

#pragma textView delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    
    CGRect p = photoBtn.frame;
    p.origin.y -= diff;
    photoBtn.frame = p;
    
    CGRect c = cameraBtn.frame;
    c.origin.y -= diff;
    cameraBtn.frame = c;
    
    CGRect pa = pasteBtn.frame;
    pa.origin.y -= diff;
    pasteBtn.frame = pa;
    
    CGRect p1 = ((UILabel *)[self viewWithTag:kbt_tag_toolbar+101+0]).frame;
    p1.origin.y -= diff;
    ((UILabel *)[self viewWithTag:kbt_tag_toolbar+101+0]).frame = p1;
    
    CGRect p2 = ((UILabel *)[self viewWithTag:kbt_tag_toolbar+101+1]).frame;
    p2.origin.y -= diff;
    ((UILabel *)[self viewWithTag:kbt_tag_toolbar+101+1]).frame = p2;
    
    CGRect p3 = ((UILabel *)[self viewWithTag:kbt_tag_toolbar+101+2]).frame;
    p3.origin.y -= diff;
    ((UILabel *)[self viewWithTag:kbt_tag_toolbar+101+2]).frame = p3;
    
    [self setNewFrame:r];// 重新设置textView的高度
}
- (void)setNewFrame:(CGRect)rect{
    [UIView animateWithDuration:.25 animations:^{
        self.frame = rect;
        [self layoutS:self.frame];
    }];
    
    // 如果有实现，则执行
    if ([self.delegate respondsToSelector:@selector(changeFrame)]) {
        [self.delegate changeFrame];
    }
    
    if ([self.delegate respondsToSelector:@selector(toolViewDidChangeFrame:)]) {
        [self.delegate toolViewDidChangeFrame:self];
    }
    
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeTextViewShouldReturn:)]) {
        return [self.delegate placeTextViewShouldReturn:growingTextView];
    }
    _textView.text = nil;
    return YES;
}


#pragma mark -----------show UI-----------------
+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+ (UIView *)getTopView{
    return [[[[Toolbar getAppDelegate] window] rootViewController] view];
}
- (void)show{
    self.validScreenHeight = SCREEN_HEIGHT;
    [self showInView:[Toolbar getTopView]];
}
- (void)showInView:(UIView *)view{
    [self showInView:view withValidHeight:view.bounds.size.height];
}
- (void)showInView:(UIView *)view withValidHeight:(CGFloat)height{
    self.validScreenHeight = height;
    // 监听键盘显现和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.frame = CGRectMake(0, _validScreenHeight - defaultToolbarHeight, SCREEN_WIDTH, defaultToolbarHeight);
    [view addSubview:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (_textView.internalTextView.isFirstResponder) {
        NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keybordSize = [keyboardBoundsValue CGRectValue].size;
        CGRect rect = self.frame;
        rect.origin.y = _validScreenHeight - (keybordSize.height + rect.size.height);
        
        [self setNewFrame:rect];
    }
}

- (void)hide{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect r = self.frame;
    r.origin.y = _validScreenHeight - r.size.height;
    [self setNewFrame:r];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
