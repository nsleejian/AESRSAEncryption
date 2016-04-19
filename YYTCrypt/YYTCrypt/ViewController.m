//
//  ViewController.m
//  YYTCrypt
//
//  Created by Lee on 16/4/19.
//  Copyright © 2016年 yaoyaoxing. All rights reserved.
//

#import "ViewController.h"
#import "YYTAESCryptHelper.h"
#import "YYTRSACryptHelper.h"
#import "GTMBase64.h"


#define kRSAPublicKey  \
@"MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtsnGlBJmfQiclCiFSHiufDOqa4a7QiGpNJO0W26PRvzBdWdaPOln8mU7Yp0Q0NF2UciXpxa1bMs7q/Ntoof7HWrvAJKnd0ysGQ/thb1h+nb0NrnNTU925nnpgysnRSrVvHuyUH5faBJSRTUIt/RCyLMBFGwZfx7jMGwqLENsTUBJPfK8O+jrw5DBPKVj7cO49BaxvMElETx/epohVfF3JOW4jyKK+hHWrGg3YSMPZSKXLT9eWgqqkgvc/S9PEMoyjz7/yLlmqErjgnMy/1BoPm3vmJmm06tEV3Qw6K4GkqNNDsUxNT4ZkK/+XIVgB34b4ywTwm0Lyepo2bJNbwe8P3wvj76csfQtlqWu4g9ojGVr8gxIqufqU404SzVwRuRn0QLjdGJlBjJrn8jRjZxfalyYV02SHOhK6ObPIRxBFikrFcRwVrbEMftBQs51sunk4qCe9c1JwE9rHQVaTgUHol9Kf5O85ceL3Y5ExDCbg8MrOaOOED4zjWLnEI3mneFd3DvdbUjSqPNplHA0SarMWHrozk0EQl5YaLEcOtgkZ+VmQiAZ8Abl8xs1t57m1BroQ41iFCc8Bt9cIdHSb8HKupxgtvyrpdHGi7RMUj+aLAv2Q8tRuBg0dqDL9mHCT+VDzuoGgCxBMSj5GoPBdsebERs0IjdnKGxsWXLQcV1TQ+ECAwEAAQ=="

@interface ViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) YYTRSACryptHelper *rsaCryptor;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@property (nonatomic,strong)NSString * cipherStringPri;
@property (nonatomic,strong)NSData *cipherData;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //==============================AES
    
    NSString * string  = @"v2ex.com";
    
    NSString * encrypt = [YYTAESCryptHelper encryptMessage:string withPassword:@"123456"];
    
    NSLog(@"AES加密后的数据：%@",encrypt);
    
    NSString * dccrypt = [YYTAESCryptHelper decryptMessage:encrypt password:@"123456"];
    
    NSLog(@"AES解密后的数据:%@\n===============================\n",dccrypt);
    
    
    
    //===========================RSA
    _rsaCryptor = [[YYTRSACryptHelper alloc] init];

 
}

//第一步 生成密钥对
- (IBAction)createKey:(id)sender {
    
    BOOL success = [self.rsaCryptor generateRSAKeyPairWithKeySize:4096];
    
    if (success) {
        
        BIGNUM *n = self.rsaCryptor->_rsa->n;
        
        const char *ndesc = BN_bn2hex(n);
        //产生长度为1024的密钥对
        NSString *n_objc = [NSString stringWithCString:ndesc encoding:NSASCIIStringEncoding];
        
        BIGNUM *e = self.rsaCryptor->_rsa->e;
        
        const char *edesc = BN_bn2dec(e);
        //公钥指数
        NSString *e_objc = [NSString stringWithCString:edesc encoding:NSASCIIStringEncoding];
        
        BIGNUM *d = self.rsaCryptor->_rsa->d;
        
        const char *ddesc = BN_bn2hex(d);
        //私钥指数
        NSString *d_objc = [NSString stringWithCString:ddesc encoding:NSASCIIStringEncoding];
        
        NSString *str = [NSString stringWithFormat:@"产生长度为1024的密钥对：\n 模n:\n%@ \n 公钥指数e: %@ \n 私钥指数d:\n%@ \n 公钥base64: \n %@ \n 私钥base64: \n %@",
                         n_objc,
                         e_objc,
                         d_objc,
                         [self.rsaCryptor base64EncodedPublicKey],
                         [self.rsaCryptor base64EncodedPrivateKey]
                         ];
        
        NSLog(@"%@",str);
        _outputTextView.text = str;
        [self alertViewShowWithMessage:@"生成密钥对成功"];
    }else {
        [self alertViewShowWithMessage:@"生成密钥对失败"];
    }
}

//第二步 公钥加密
- (IBAction)publicKeyEncryption:(id)sender {
    if (_inputTextView.text.length == 0 ) {
        [self alertViewShowWithMessage:@"请输入要加密的内容"];
        return;
    }
    NSString * text        = _inputTextView.text;
    NSData *cipherData     = [self.rsaCryptor encryptWithPublicKeyUsingPadding:RSA_PKCS1_PADDING plainData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *cipherString = [GTMBase64 stringByEncodingData:cipherData];
    NSString *enStr        = [NSString stringWithFormat:@"加密后的密文的base64: \n%@", cipherString];
    NSLog(@"%@",enStr);
    _cipherData = cipherData;
    _outputTextView.text = enStr;

}

//第三步 通过私钥解密公钥加密的信息
- (IBAction)privateKeyDecrypt:(id)sender {
    if (_cipherData == nil) {
        [self alertViewShowWithMessage:@"未找到加密内容"];
        return ;
    }
    NSData *plainData    = [self.rsaCryptor decryptWithPrivateKeyUsingPadding:RSA_PADDING_TYPE_PKCS1 cipherData:_cipherData];
    NSString *plainText  = [[NSString alloc]initWithData:plainData encoding:NSUTF8StringEncoding];
    NSString *deStr      = [NSString stringWithFormat:@"解密可得: \n%@", plainText];
    NSLog(@"%@",deStr);
    _outputTextView.text = deStr;
}

//私钥加密
- (IBAction)privateKeyEncryption:(id)sender {
    if (_inputTextView.text.length == 0 ) {
        [self alertViewShowWithMessage:@"请输入要加密的内容"];
        return;
    }
    NSString *textPri         = _inputTextView.text;
    NSData *cipherDataPri     = [self.rsaCryptor encryptWithPrivateKeyUsingPadding:RSA_PKCS1_PADDING plainData:[textPri dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *cipherStringPri = [GTMBase64 stringByEncodingData:cipherDataPri];
    NSString *enStrPri        = [NSString stringWithFormat:@"加密后的密文的base64: \n%@", cipherStringPri];
    NSLog(@"%@",enStrPri);
    _cipherStringPri = cipherStringPri;
    _outputTextView.text  = enStrPri;
    
}

//通过公钥解密用私钥加密的信息
- (IBAction)publicKeyDecrypt:(id)sender {
    if (_cipherStringPri == nil) {
        [self alertViewShowWithMessage:@"未找到加密内容"];
        return ;
    }
    NSData *deCipherDataPri  = [GTMBase64 decodeString:_cipherStringPri];
    NSData *deplainDataPri   = [self.rsaCryptor decryptWithPublicKeyUsingPadding:RSA_PADDING_TYPE_PKCS1 cipherData:deCipherDataPri];
    NSString *dePlainTextPri = [[NSString alloc]initWithData:deplainDataPri encoding:NSUTF8StringEncoding];
    NSString *deStrPri       = [NSString stringWithFormat:@"解密可得: \n%@", dePlainTextPri];
    NSLog(@"%@",deStrPri);
    _outputTextView.text     = deStrPri;

}
- (IBAction)importThePublicKey:(id)sender {

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"是否导入测试密钥?"message:kRSAPublicKey preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL importSuccess = [self.rsaCryptor importRSAPublicKeyBase64:kRSAPublicKey];
        [self alertViewShowWithMessage:importSuccess?@"导入成功":@"导入失败"];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)alertViewShowWithMessage:(NSString *)message {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
