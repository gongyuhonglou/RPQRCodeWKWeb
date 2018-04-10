//
//  ViewController.m
//  RPQRCodeWKWebView
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 WRP. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ADWebViewViewController.h"
#import <Photos/Photos.h>


@interface ViewController ()<RomAlertViewDelegate>
{
    RomAlertView *alertview;
    NSString *qrCodeUrl;
    
    UIImageView *img;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"长按图片识别二维码";
    
    img = [[UIImageView alloc] initWithFrame: CGRectMake(50, 64+50, 200, 400)];
    img.image = [UIImage imageNamed:@"3.jpg"];//2.jpg,3.jpg,4.jpg,5.jpg
    img.userInteractionEnabled = YES;
    [self.view addSubview:img];
    
    // 长按图片识别二维码]
    UILongPressGestureRecognizer *QrCodeTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(QrCodeClick:)];
    [img addGestureRecognizer:QrCodeTap];
}

- (void)QrCodeClick:(UILongPressGestureRecognizer *)pressSender {
    
    if (pressSender.state != UIGestureRecognizerStateBegan) {
        return;//长按手势只会响应一次
    }
    
    //截图 再读取
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
    
    NSArray *features = [detector featuresInImage:ciImage];
    
    if (features.count) {
        
        for (CIQRCodeFeature *feature in features) {
            NSLog(@"qrCodeUrl = %@",feature.messageString); // 打印二维码中的信息
            qrCodeUrl = feature.messageString;
        }
        
        // 初始化弹框 第一个参数是设置距离底部的边距
        alertview = [[RomAlertView alloc] initWithMainAlertViewBottomInset:0 Title:nil detailText:nil cancelTitle:nil otherTitles:[NSMutableArray arrayWithObjects:@"保存图片",@"识别图中二维码",nil]];
        alertview.tag = 10002;
        // 设置弹框的样式
        alertview.RomMode = RomAlertViewModeBottomTableView;
        // 设置弹框从什么位置进入 当然也可以设置什么位置退出
        [alertview setEnterMode:RomAlertEnterModeBottom];
        // 设置代理
        [alertview setDelegate:self];
        // 显示 必须调用 和系统一样
        [alertview show];
    } else {
        NSLog(@"图片中没有二维码");
    }
    
}

#pragma mark -- RomAlertViewDelegate 弹框识别图中二维码
- (void)alertview:(RomAlertView *)alertview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (alertview.tag == 10002) {
        if ([alertview.otherTitles[indexPath.row]  isEqualToString:@"保存图片"]) {
            NSLog(@"保存图片");
            [self savePhoto];
        }else if ([alertview.otherTitles[indexPath.row] isEqualToString:@"识别图中二维码"]){
            NSLog(@"识别图中二维码");
            
            // 隐藏
            [alertview hide];
            [self leftBackButtonPressed];
            
            //对结果进行处理跳转网页
            ADWebViewViewController *controller = [[ADWebViewViewController alloc] init];
            controller.m_url = qrCodeUrl;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
//            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//            if([delegate.window.rootViewController isKindOfClass:[UITabBarController class]]){
//                UITabBarController *tabBarController = (UITabBarController *)delegate.window.rootViewController;
//                UINavigationController *navigationController = [tabBarController selectedViewController];
//                UIViewController *vc = navigationController.topViewController;
//                //对结果进行处理跳转网页
//                ADWebViewViewController *controller = [[ADWebViewViewController alloc] init];
//                controller.m_url = qrCodeUrl;
//                controller.hidesBottomBarWhenPushed = YES;
//                [vc.navigationController pushViewController:controller animated:YES];
//            }
        }
    }
}

//隐藏
-(void)leftBackButtonPressed {
    
    [UIView animateWithDuration:0.15 animations:^{
        UIView *topView=(UIView *)[self.view viewWithTag:801];
        [topView removeFromSuperview];
        UIButton *leftButton=(UIButton *)[self.view viewWithTag:3000];
        [leftButton removeFromSuperview];
        
        UILabel *topTitleLabel=(UILabel *)[self.view viewWithTag:3001];
        [topTitleLabel removeFromSuperview];
        
        UIButton *saveButton=(UIButton *)[self.view viewWithTag:3002];
        [saveButton removeFromSuperview];
        
        self.view.frame=CGRectMake(CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds)/2, CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds)/2, 0, 0);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark -- 保存图片
- (void)savePhoto {

    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    //  保存图片到相册
                    [self saveImageIntoAlbum];
                    break;
                }
                case PHAuthorizationStatusDenied: {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                    NSLog(@"提醒用户打开相册的访问开关");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法保存"        message:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的照片。" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法保存"        message:@"因系统原因，无法访问相册！" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
        });
    }];
    
    
}


// 获得刚才添加到【相机胶卷】中的图片
-(PHFetchResult<PHAsset *> *)createdAssets
{
//    MJPhoto *photo = _photos[_currentPhotoIndex];
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:img.image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (createdAssetId == nil) return nil;
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

//获得【自定义相册】
-(PHAssetCollection *)createdCollection
{
    // 获取软件的名字作为相册的标题(如果需求不是要软件名称作为相册名字就可以自己把这里改成想要的名称)
    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    // 代码执行到这里，说明还没有自定义相册
    __block NSString *createdCollectionId = nil;
    // 创建一个新的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    if (createdCollectionId == nil) return nil;
    // 创建完毕后再取出相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}



//保存图片到相册
-(void)saveImageIntoAlbum
{
    // 获得相片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    // 获得相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdAssets == nil || createdCollection == nil) {
        
//        [self.view makeToast:@"图片保存失败！" duration:2 position:CSToastPositionCenter];
        return;
    }
    // 将相片添加到相册
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    // 保存结果
    NSString *msg = nil ;
    
    if(error){
        msg = @"图片保存失败！";
        
//        [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
        
    }else{
        msg = @"已成功保存到系统相册";
//        MJPhoto *photo = _photos[_currentPhotoIndex];
//        photo.save = YES;
//        [self.view makeToast:msg duration:2 position:CSToastPositionCenter];
        
    }
    
}

@end
