//
//  YYTAESCryptHelper.h
//  YYTcryption
//
//  Created by Lee on 16/4/19.
//  Copyright © 2016年 yaoyaoxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYTAESCryptHelper : NSObject

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

@end
