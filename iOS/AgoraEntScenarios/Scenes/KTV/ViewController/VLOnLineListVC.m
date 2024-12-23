//
//  VLOnLineListVC.m
//  VoiceOnLine
//

#import "VLOnLineListVC.h"
#import "VLHomeOnLineListView.h"
#import "VLKTVViewController.h"

#import "VLCreateRoomViewController.h"
#import "LSTPopView.h"
#import "VLUserCenter.h"
#import "VLMacroDefine.h"
#import "VLURLPathConfig.h"
#import "VLToast.h"
#import "AppContext+KTV.h"
#import "AESMacro.h"
#import "VLAlert.h"
#import "AgoraEntScenarios-Swift.h"

@interface VLOnLineListVC ()<VLHomeOnLineListViewDelegate/*,AgoraRtmDelegate*/>

@property (nonatomic, strong) VLHomeOnLineListView *listView;
@end

@implementation VLOnLineListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [AppContext setupKtvConfig];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonUI];
    [self setUpUI];
}

- (void)commonUI {
    [self setBackgroundImage:@"online_list_BgIcon" bundleName:@"KtvResource"];
    [self setNaviTitleName:KTVLocalizedString(@"ktv_online_ktv")];
    if ([VLUserCenter center].isLogin) {
        [self setBackBtn];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [VLUserCenter clearUserRoomInfo];
    [self.listView loadData];
}

- (void)setUpUI {
    VLHomeOnLineListView *listView = [[VLHomeOnLineListView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-kTopNavHeight) withDelegate:self];
    self.listView = listView;
    [self.view addSubview:listView];
}

#pragma mark - Public Methods

- (void)configNavigationBar:(UINavigationBar *)navigationBar {
    [super configNavigationBar:navigationBar];
}
- (BOOL)preferredNavigationBarHidden {
    return true;
}

- (void)backBtnClickEvent {
    [super backBtnClickEvent];
    [AppContext unloadKtvServiceImp];
}

#pragma mark --NetWork

#pragma mark - deleagate
- (void)createBtnAction {

    VLCreateRoomViewController *createRoomVC = [[VLCreateRoomViewController alloc]init];
    createRoomVC.createRoomBlock = ^(CGFloat height) {
        [[KTVCreateRoomPresentView shared] update:height];
    };
    
    kWeakSelf(self);
    createRoomVC.createRoomVCBlock = ^(UIViewController *vc) {
        [[KTVCreateRoomPresentView shared] dismiss];
        KTVLogInfo(@"createRoomVCBlock");
        [weakself.navigationController pushViewController:vc animated:true];
    };
    KTVCreateRoomPresentView *presentView = [KTVCreateRoomPresentView shared];

    [presentView showViewWith:CGRectMake(0, SCREEN_HEIGHT - 343, SCREEN_WIDTH, 343) vc:createRoomVC];

    [self.view addSubview:presentView];
}

- (void)listItemClickAction:(SyncRoomInfo *)listModel {

    if (listModel.isPrivate) {
        NSArray *array = [[NSArray alloc]initWithObjects:KTVLocalizedString(@"ktv_cancel"),KTVLocalizedString(@"ktv_gotit"), nil];
        VL(weakSelf);
        [[VLAlert shared] showAlertWithFrame:UIScreen.mainScreen.bounds title:KTVLocalizedString(@"ktv_input_pwd") message:@"" placeHolder:KTVLocalizedString(@"ktv_pls_input_pwd") type:ALERTYPETEXTFIELD buttonTitles:array completion:^(bool flag, NSString * _Nullable text) {
            [weakSelf joinInRoomWithModel:listModel withInPutText:text];
            [[VLAlert shared] dismiss];
        }];
    }else{
        [self joinInRoomWithModel:listModel withInPutText:@""];
    }
}

- (void)joinInRoomWithModel:(SyncRoomInfo *)listModel withInPutText:(NSString *)inputText {
    if (listModel.isPrivate && ![listModel.password isEqualToString:inputText]) {
        [VLToast toast:KTVLocalizedString(@"PasswordError")];
        return;
    }
    VL(weakSelf);
    VLKTVViewController *ktvVC = [[VLKTVViewController alloc]init];
    KTVLogInfo(@"joinRoomWithRoomId[%@] start", listModel.roomNo);
    [[AppContext ktvServiceImp] joinRoomWithRoomId:listModel.roomNo password:inputText completion:^(NSError * _Nullable error) {
        KTVLogInfo(@"joinRoomWithRoomId[%@] completion", error.localizedDescription);
        if (error != nil) {
            [VLToast toast:error.localizedDescription];
            return;
        }
        
        ktvVC.roomModel = listModel;
        [weakSelf.navigationController pushViewController:ktvVC animated:YES];
    }];
}

//- (NSArray *)configureSeatsWithArray:(NSArray *)seatsArray songArray:(NSArray *)songArray {
//    NSMutableArray *seatMuArray = [NSMutableArray array];
//
//    NSArray *modelArray = [VLRoomSeatModel vj_modelArrayWithJson:seatsArray];
//    for (int i=0; i<8; i++) {
//        BOOL ifFind = NO;
//        for (VLRoomSeatModel *model in modelArray) {
//            if (model.onSeat == i) { 
//                ifFind = YES;
//                if(songArray != nil && [songArray count] >= 1) {
//                    if([model.userNo isEqualToString:songArray[0][@"userNo"]]) {
//                        model.ifSelTheSingSong = YES;
//                    }
//                    else if([model.userNo isEqualToString:songArray[0][@"chorusNo"]]) {
//                        model.ifJoinedChorus = YES;
//                    }
//                }
//                [seatMuArray addObject:model];
//            }
//        }
//        if (!ifFind) {
//            VLRoomSeatModel *model = [[VLRoomSeatModel alloc]init];
//            model.onSeat = i;
//            [seatMuArray addObject:model];
//        }
//    }
//    return seatMuArray.mutableCopy;
//}

- (LSTPopView *)setPopCommenSettingWithContentView:(UIView *)contentView ifClickBackDismiss:(BOOL)dismiss{
    LSTPopView *popView = [LSTPopView initWithCustomView:contentView parentView:self.view popStyle:LSTPopStyleFade dismissStyle:LSTDismissStyleFade];
    popView.hemStyle = LSTHemStyleCenter;
    popView.popDuration = 0.5;
    popView.dismissDuration = 0.5;
    LSTPopViewWK(popView)
    if (dismiss) {
        popView.isClickFeedback = YES;
        popView.bgClickBlock = ^{
            [wk_popView dismiss];
        };
    }else{
        popView.isClickFeedback = NO;
    }
    popView.rectCorners = UIRectCornerTopLeft | UIRectCornerTopRight;
    
    return  popView;
    
}


@end
