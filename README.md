1、AES

```
import "YYTAESCryptHelper.h"


/**
 *  AES 加密
 *
 *  @param message   要加密的信息
 *  @param passwoord 密码
 *
 *  @return 加密后的信息
 */
+ (NSString *)encryptMessage:(NSString *)message withPassword:(NSString*)password;

/**
 *  AES 解密
 *
 *  @param base64EncodedMessage 经过加密的密文
 *  @param password             密码
 *
 *  @return 揭秘后的信息
 */
+ (NSString *)decryptMessage:(NSString *)base64EncodedMessage password:(NSString *)password;



```

2、RSA


```
import "YYTRSACryptHelper.h"
import "GTMBase64.h"


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
 *  设置密钥长度 `512`,`1024`,`2048`....
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

```