//
//  NSData+Crypto.m
//  Encrypt
//
//  Created by wuyj on 15/7/3.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Crypto.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


NSString * const kNSDataCryptoErrorDomain = @"NSDataCryptoErrorDomain";

@interface NSError (NSDataCryptoErrorDomain)
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;
@end

@implementation NSError (NSDataCryptoErrorDomain)

+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status {
    NSString *desc = nil;
    
    switch (status) {
        case kCCSuccess:
            desc = @"Success";
            break;
            
        case kCCParamError:
            desc = @"Parameter Error";
            break;
            
        case kCCBufferTooSmall:
            desc = @"Buffer Too Small";
            break;
            
        case kCCMemoryFailure:
            desc = @"Memory Failure";
            break;
            
        case kCCAlignmentError:
            desc = @"Alignment Error";
            break;
            
        case kCCDecodeError:
            desc = @"Decode Error";
            break;
            
        case kCCUnimplemented:
            desc = @"Unimplemented Function";
            break;
            
        default:
            desc = @"Unknown Error";
            break;
    }
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject: desc forKey: NSLocalizedDescriptionKey];
    [userInfo setObject: desc forKey: NSLocalizedFailureReasonErrorKey];
    
    return [NSError errorWithDomain:kNSDataCryptoErrorDomain code:status userInfo:userInfo];
}

@end


@implementation NSData (Crypto)

- (NSData *)AES128EncryptWithKey:(NSString *)key gIv:(NSString *)Iv {
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [Iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES128DecryptWithKey:(NSString *)key gIv:(NSString *)Iv {
    
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [Iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)DESEncryptedDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedWithAlgorithm:kCCAlgorithmDES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)decryptedDESDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataWithAlgorithm:kCCAlgorithmDES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)tripleDESEncryptedDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedWithAlgorithm:kCCAlgorithm3DES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)decryptedTripleDESDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataWithAlgorithm:kCCAlgorithm3DES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}


- (void)appendKeyLengthsByAlgorithm:(CCAlgorithm)algorithm keyData:(NSMutableData*)keyData {
    
    switch (algorithm) {
            
        case kCCAlgorithmDES: {
            [keyData setLength:kCCKeySizeDES];
            break;
        }
            
        case kCCAlgorithm3DES: {
            [keyData setLength:kCCKeySize3DES];

            break;
        }
            
        default:
            break;
    }
}

- (NSData *)cryptorToData:(CCCryptorRef)cryptor result:(CCCryptorStatus *)status {
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[self length],true);
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate(cryptor,
                              [self bytes],
                              (size_t)[self length],
                              buf,
                              bufsize,
                              &bufused);
    if (*status != kCCSuccess) {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    *status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    if (*status != kCCSuccess){
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}


- (NSData *)dataEncryptedWithAlgorithm:(CCAlgorithm)algorithm
                                   key:(id)key
                               options:(CCOptions)options
                                 error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData *keyData;
    if ([key isKindOfClass: [NSData class]])
        keyData = (NSMutableData *)[key mutableCopy];
    else
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    [self appendKeyLengthsByAlgorithm:algorithm keyData:keyData];

    status = CCCryptorCreate(kCCEncrypt,
                             algorithm,
                             options,
                             [keyData bytes],
                             [keyData length],
                             NULL,
                             &cryptor);
    
    if (status != kCCSuccess) {
        if (error != NULL)
            *error = status;
        return nil;
    }
    
    NSData *result = [self cryptorToData:cryptor result:&status];
    if (result == nil && error != NULL)
        *error = status;
    
    CCCryptorRelease(cryptor);
    return result;
}

- (NSData *)decryptedDataWithAlgorithm:(CCAlgorithm)algorithm
                                     key:(id)key
                                 options:(CCOptions)options
                                   error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData * keyData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *)[key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    [self appendKeyLengthsByAlgorithm:algorithm keyData:keyData];
    
    status = CCCryptorCreate(kCCDecrypt,
                             algorithm,
                             options,
                             [keyData bytes],
                             [keyData length],
                             NULL,
                             &cryptor);
    
    if (status != kCCSuccess) {
        if (error != NULL)
            *error = status;
        return nil;
    }
    
    NSData *result = [self cryptorToData:cryptor result:&status];
    if (result == nil && error != NULL)
        *error = status;
    
    CCCryptorRelease(cryptor);
    return result;
}

- (NSString*)md5String {
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, r);
    NSString *md5 = [[NSString alloc] initWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    
    return md5;
}

#define CHUNK_SIZE 1024

+ (NSString *)fileMD5:(NSString*)path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if(handle == nil)
        return nil;
    
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    
    // 分块读取数据
    NSData* filedata;
    do {
        
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        
        //调用系统底层函数，无法避免32->64
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
#pragma clang diagnostic pop
        
    }
    
    while([filedata length]);
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    [handle closeFile];
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++) {
        [hash appendFormat:@"%02x",result[i]];
    }
    return [hash lowercaseString];
}

- (NSData*)base64EncodeData {
    
    NSData *stringData =[self base64EncodedDataWithOptions:0];
    return stringData;
}

- (NSData*)base64DecodeData {
    NSData *stringBase64Data = [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return stringBase64Data;
}

- (NSString*)base64EncodeString {
    NSString *string = [self base64EncodedStringWithOptions:0];
    return string;
}

- (NSString*)base64DecodeString {
    
    NSData *stringData = [self base64DecodeData];
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

- (NSData *) SHA1Hash {
    unsigned char hash[CC_SHA1_DIGEST_LENGTH];
    (void) CC_SHA1( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA1_DIGEST_LENGTH] );
}

- (NSData *) SHA224Hash {
    unsigned char hash[CC_SHA224_DIGEST_LENGTH];
    (void) CC_SHA224( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA224_DIGEST_LENGTH] );
}

- (NSData *) SHA256Hash {
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    (void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
}

- (NSData *) SHA384Hash {
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    (void) CC_SHA384( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA384_DIGEST_LENGTH] );
}

- (NSData *) SHA512Hash {
    unsigned char hash[CC_SHA512_DIGEST_LENGTH];
    (void) CC_SHA512( [self bytes], (CC_LONG)[self length], hash );
    return ( [NSData dataWithBytes: hash length: CC_SHA512_DIGEST_LENGTH] );
}

- (NSString *)byteToHex {
    NSUInteger len = [self length];
    char *chars = (char *)[self bytes];
    NSMutableString *hexString = [[NSMutableString alloc]init];
    for (NSUInteger i=0; i<len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
    }
    return hexString;
}

+ (NSData *)hexToData:(NSString *)hexString {
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

@end

