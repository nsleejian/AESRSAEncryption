//
//  YYTRSACryptHelper.h
//  YYTcryption
//
//  Created by Lee on 16/4/19.
//  Copyright © 2016年 yaoyaoxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rsa.h"
#import "pem.h"

typedef NS_ENUM(NSInteger, RSA_PADDING_TYPE) {
    
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
};
@interface YYTRSACryptHelper : NSObject

{
    RSA *_rsaPublic;
    RSA *_rsaPrivate;
    
@public
    RSA *_rsa;
}


/**
 *  base64 公钥编码
 *
 *  @return  编码后的公钥
 */
- (NSString *)base64EncodedPublicKey;

/**
 *  base64 私钥编码
 *
 *  @return 编码后的私钥
 */
- (NSString *)base64EncodedPrivateKey;


/**
 *  设置密钥长度 `512`,`1024`,`2048`
 *
 *  @param keySize 密钥长度
 *
 *  @return 成功或者失败  （BOOL）
 */
- (BOOL)generateRSAKeyPairWithKeySize:(int)keySize;

/**
 *  导入公钥（ base64 编码）
 *
 *  @param publicKey base64编码后的公钥
 *
 *  @return 成功或者失败  （BOOL）
 */
- (BOOL)importRSAPublicKeyBase64:(NSString *)publicKey;


/**
 *  导入私钥 （base64 编码）
 *
 *  @param privateKey base64编码后的私钥
 *
 *  @return 成功或者失败  （BOOL）
 */
- (BOOL)importRSAPrivateKeyBase64:(NSString *)privateKey;


/**
 *  公钥加密
 *
 *  @param padding    padding type
 *  @param plainData  padding text
 *
 *  @return 公钥加密后的数据
 */
- (NSData *)encryptWithPublicKeyUsingPadding:(RSA_PADDING_TYPE)padding
                                   plainData:(NSData *)plainData;


/**
 *  私钥加密
 *
 *  @param padding   padding type
 *  @param plainData padding text
 *
 *  @return 私钥加密后的数据
 */
- (NSData *)encryptWithPrivateKeyUsingPadding:(RSA_PADDING_TYPE)padding
                                    plainData:(NSData *)plainData;


/**
 *  解密通过公钥加密的数据
 *
 *  @param padding    padding type
 *  @param cipherData  加密的数据
 *
 *  @return 解密后的数据
 */
- (NSData *)decryptWithPublicKeyUsingPadding:(RSA_PADDING_TYPE)padding
                                  cipherData:(NSData *)cipherData;


/**
 *  解密通过私钥加密的数据
 *
 *  @param padding    padding type
 *  @param cipherData 加密的数据
 *
 *  @return 解密后的数据
 */
- (NSData *)decryptWithPrivateKeyUsingPadding:(RSA_PADDING_TYPE)padding
                                   cipherData:(NSData *)cipherData;

@end
