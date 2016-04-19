//
//  YYTAESCryptHelper.m
//  YYTcryption
//
//  Created by Lee on 16/4/19.
//  Copyright © 2016年 yaoyaoxing. All rights reserved.
//

#import "YYTAESCryptHelper.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"

@implementation YYTAESCryptHelper


+ (NSString *)encryptMessage:(NSString *)message withPassword:(NSString*)password {
    
    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

+ (NSString *)decryptMessage:(NSString *)base64EncodedMessage password:(NSString *)password {
    NSData *encryptedData = [NSData base64DataFromString:base64EncodedMessage];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString * decryptMessage = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return decryptMessage;
    
}


@end
