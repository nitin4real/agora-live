//
//  VLAlert.m
//  testAlert
//
//  Created by CP on 2023/1/6.
//

#import "VLAlert.h"
#import "AttributedTextView.h"

@interface VLAlert()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *mesLabel;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) AttributedTextView *attrView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) ALERTYPE alertType;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *attributeMessage;

//KTV only
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, copy) OnCallback completion;
@property (nonatomic, copy) linkCallback linkCompletion;
@end

@implementation VLAlert

static VLAlert *_alert = nil;
+ (instancetype)shared
{
    if (!_alert) {
        _alert = [[VLAlert alloc] init];
    }
    return _alert;
}

-(void)showAlertWithFrame:(CGRect)frame title:(NSString *)title message:(NSString *_Nullable)message placeHolder:(NSString *_Nullable)placeHolder type:(ALERTYPE)type buttonTitles:(NSArray *)buttonTitles completion:(OnCallback _Nullable)completion{
        self.alertType = type;
        self.message = message;
        [self layoutUI];
        
        self.completion = completion;
        self.mesLabel.hidden = type != ALERTYPENORMAL;
        self.textView.hidden = type != ALERTYPETEXTFIELD;
        self.cancleBtn.hidden = type == ALERTYPECONFIRM;
        self.titleLabel.text = title;
        self.mesLabel.text = message;
        
        [self.cancleBtn setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [self.confirmBtn setTitle:buttonTitles[type == ALERTYPECONFIRM ? 0 : 1] forState:UIControlStateNormal];
        self.textField.placeholder = placeHolder;
        [UIApplication.sharedApplication.delegate.window addSubview:self];
}

-(void)showAttributeAlertWithFrame:(CGRect)frame title:(NSString * _Nullable)title text:(NSString *)text AttributedStringS:(NSArray *)strings ranges:(NSArray *)ranges textColor:(UIColor *)textColor attributeTextColor:(UIColor * )attributeTextColor buttonTitles:(NSArray *)buttonTitles completion:(OnCallback _Nullable)completion linkCompletion:(linkCallback _Nullable)linkCompletion{
        [self layoutUI];
        self.alertType = ALERTYPEATTRIBUTE;
        self.completion = completion;
        self.linkCompletion = linkCompletion;
        self.textField.hidden = true;
        self.titleLabel.text = title;
        self.mesLabel.hidden = true;
        self.textView.hidden = true;
        self.attributeMessage = text;
        
        self.attrView = [[AttributedTextView alloc]initWithFrame:CGRectZero text:text AttributedStringS:strings ranges:ranges textColor:textColor attributeTextColor:attributeTextColor];
        [self.alertView addSubview:self.attrView];
        self.attrView.delegate = self;
    
        [self.cancleBtn setTitle:buttonTitles[0] forState:UIControlStateNormal];
        [self.confirmBtn setTitle:buttonTitles[1] forState:UIControlStateNormal];

        [UIApplication.sharedApplication.delegate.window addSubview:self];
}

-(void)layoutUI {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.2;
    [self addSubview:self.bgView];
    
    self.alertView = [[UIView alloc]init];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 10;
    self.alertView.layer.masksToBounds = true;
    [self addSubview:self.alertView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize: self.alertType == ALERTYPECONFIRM ? 16 : 18 weight:UIFontWeightBold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:self.titleLabel];
    
    self.mesLabel = [[UILabel alloc]init];
    self.mesLabel.numberOfLines = 0;
    self.mesLabel.font = [UIFont systemFontOfSize:15];
    self.mesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.mesLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:self.mesLabel];

    self.cancleBtn = [[UIButton alloc]init];
    [self.cancleBtn setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]];
    [self.cancleBtn setTitleColor:[self colorWithHexString:@"#000000"] forState:UIControlStateNormal];
    self.cancleBtn.backgroundColor = [self colorWithHexString:@"#EFF4FF"];
    self.cancleBtn.layer.cornerRadius = 20;
    self.cancleBtn.layer.borderColor = [self colorWithHexString:@"#EFF4FF"].CGColor;
    self.cancleBtn.layer.masksToBounds = true;
    self.cancleBtn.tag = 100;
    [self.cancleBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:self.cancleBtn];
    
    self.confirmBtn = [[UIButton alloc]init];
    self.confirmBtn.backgroundColor = [self colorWithHexString:@"#2753FF"];
    [self.confirmBtn setTitleColor:[self colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.confirmBtn setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]];
    self.confirmBtn.layer.cornerRadius = 20;
    self.confirmBtn.layer.masksToBounds = true;
    self.confirmBtn.tag = 101;
    [self.confirmBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:self.confirmBtn];
    
    self.textView = [[UIView alloc]init];
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = true;
    self.textView.layer.borderColor = [UIColor separatorColor].CGColor;
    self.textView.layer.borderWidth = 1;
    [self.alertView addSubview:self.textView];
    
    self.textField = [[UITextField alloc]init];
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textView addSubview:self.textField];
}

-(void)click:(UIButton *)btn {
    self.completion(btn.tag == 101, self.alertType == ALERTYPETEXTFIELD ? self.textField.text : nil);
}

-(void)dismiss {
    [self removeFromSuperview];
    _alert = nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.frame = UIScreen.mainScreen.bounds;
    self.bgView.frame = UIScreen.mainScreen.bounds;
    //1.Determine what kind of alert it is, then calculate the altitude
    CGFloat contentHeight = 20 + 22 + 20;
    CGFloat mesHeight = [self heightWithString:self.message];
    CGFloat attrTVHeight = [self heightWithString:self.attributeMessage] + 20;
    if(self.alertType == ALERTYPENORMAL){
        contentHeight += mesHeight;
    } else if (self.alertType == ALERTYPETEXTFIELD) {
        contentHeight += 40;
    } else if (self.alertType == ALERTYPEATTRIBUTE) {
        contentHeight += attrTVHeight;
    }
    contentHeight += 20;
    contentHeight += 40;
    contentHeight += 20;
    self.alertView.frame = CGRectMake(40, ([UIScreen mainScreen].bounds.size.height - contentHeight) / 2.0, [[UIScreen mainScreen] bounds].size.width - 80, contentHeight);
    self.titleLabel.frame = CGRectMake(20, 20, self.alertView.bounds.size.width - 40, 22);
    self.mesLabel.frame = CGRectMake(20, 62, self.alertView.bounds.size.width - 40, mesHeight);
    self.textView.frame = CGRectMake(20, 62, self.alertView.bounds.size.width - 40, 40);
    self.textField.frame = CGRectMake(10, 0, self.alertView.bounds.size.width - 50, 40);
    self.attrView.frame = CGRectMake(20, 62, self.alertView.bounds.size.width - 40, attrTVHeight);
    
    CGFloat btnW = (self.alertView.bounds.size.width - 40 - 50) * 0.5;
    self.cancleBtn.frame = CGRectMake(20, contentHeight - 60, btnW, 40);
    self.confirmBtn.frame = CGRectMake( self.alertType == ALERTYPECONFIRM ? 20 : 20 + 50 + btnW, contentHeight - 60, self.alertType == ALERTYPECONFIRM ? self.alertView.bounds.size.width - 40 : btnW, 40);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration animations:^{
        self.frame = CGRectOffset(self.frame, 0, movement);
    }];

}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSURL *url = [NSURL URLWithString:@"0"];
    NSURL *url2 = [NSURL URLWithString:@"2"];
    if([url isEqual:URL] || [url2 isEqual:URL]){
        self.linkCompletion(@"0");
    } else {
        self.linkCompletion(@"1");
    }
    return YES;
}

- (CGFloat)heightWithString:(NSString *)text {
    CGSize textSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width - 120, 0);
    NSDictionary *font = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGRect rect = [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:font context:nil];
    return rect.size.height;
    
}

- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    NSString * colorStr = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([colorStr length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
    
    // If it starts with #, then the string is cut, starting at index 1 and ending at the end
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    // Determine the string length after removing all leading characters
    if ([colorStr length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //red
    NSString * redStr = [colorStr substringWithRange:range];
    //green
    range.location = 2;
    NSString * greenStr = [colorStr substringWithRange:range];
    //blue
    range.location = 4;
    NSString * blueStr = [colorStr substringWithRange:range];
    
    // Scan values Convert hexadecimal to binary
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

- (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}

@end
