//
//  VBUploadController.m
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

#import "VBUploadController.h"
#import <AWSS3/AWSS3.h>
#import "Viral_Bible_Ios-Swift.h"

@implementation VBUploadController

+ (void)uploadData:(nonnull NSData *)data
          filename:(nonnull NSString *)filename
            bucket:(nonnull NSString *)bucket
       contentType:(nonnull NSString *)contentType
        completion:(VBCompletionHandlerWithError)completion
{
    NSParameterAssert(data);
    NSParameterAssert(filename);
    NSParameterAssert(contentType);
    
    AWSS3 *s3 = [AWSS3 defaultS3];
    
    NSAssert(s3, @"nonnil is nil");
    
    AWSS3PutObjectRequest *request = [AWSS3PutObjectRequest new];
    request.bucket = bucket;
    request.contentType = contentType;
    request.body = data;
    request.key = filename;
    request.contentLength = [NSNumber numberWithInteger:data.length];
    
    [[s3 putObject:request] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            if (completion) {
                completion(task.error);
            }
        } else {
            // success
            if (completion) {
                completion(nil);
            }
        }
        return nil;
    }];
}

@end
