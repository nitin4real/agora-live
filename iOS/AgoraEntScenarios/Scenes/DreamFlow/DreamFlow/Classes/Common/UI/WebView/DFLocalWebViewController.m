//
//  DFLocalWebViewController.m
//  VoiceOnLine
//

#import "DFLocalWebViewController.h"
#import <WebKit/WebKit.h>
#import "DFGlobalHelper.h"
#import "DFMacroDefine.h"
#import "DFHotSpotBtn.h"

#import "AESMacro.h"

@interface DFLocalWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webViewWK;

@end

@implementation DFLocalWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [self setUpUI];
    DFHotSpotBtn *backBtn = [[DFHotSpotBtn alloc]initWithFrame:CGRectMake(20, DFkStatusBarHeight, 20, 20)];
    [backBtn setImage:[UIImage imageNamed:@"ic_back_b"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}
-(void)backBtnClickEvent:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpUI {
    self.view.backgroundColor = UIColorMakeWithHex(@"#F7FAFE");
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    configuration.allowsInlineMediaPlayback = YES;
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
    CGFloat y = DFIPHONE_X ? 15 : 0;
    self.webViewWK = [[WKWebView alloc]initWithFrame:CGRectMake(0, DFkStatusBarHeight - y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - DFkDFSafeAreaBottomHeight - y) configuration:configuration];
    self.webViewWK.scrollView.backgroundColor = UIColorMakeWithHex(@"#F7FAFE");
    self.webViewWK.backgroundColor = UIColorMakeWithHex(@"#F7FAFE");
    self.webViewWK.navigationDelegate=self;
    self.webViewWK.UIDelegate = self;

    if (@available(iOS 11.0, *)) {
        self.webViewWK.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.webViewWK];
    [self makeProgressView];
    [self loadLocalHtml];
}

- (void)loadLocalHtml {
//    NSString *path = [[NSBundle mainBundle] bundlePath];
    self.nameStr = [self.nameStr stringByReplacingOccurrencesOfString:@".html" withString:@""];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:self.nameStr ofType:@"html"];
    htmlPath = [NSString stringWithFormat:@"file://%@?%@",htmlPath,self.pathStr];
//    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    [self.webViewWK loadHTMLString:html baseURL:baseURL];
    [self.webViewWK loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];

    
}

#pragma mark - Public Methods
- (void)configNavigationBar:(UINavigationBar *)navigationBar {
    [super configNavigationBar:navigationBar];
    
}
- (BOOL)preferredNavigationBarHidden {
    return true;
}

-(void)makeProgressView
{
    [self.webViewWK addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    CGFloat y = DFIPHONE_X ? (DFkStatusBarHeight - 12) : DFkStatusBarHeight;
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame),2)];
    [self.view addSubview:self.progressView];
}

#pragma mark - KVO Delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.webViewWK) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webViewWK.estimatedProgress animated:YES];
        if(self.webViewWK.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    if (self.progressView) {
        [self.webViewWK removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    NSURLRequest *request        = navigationAction.request;

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
