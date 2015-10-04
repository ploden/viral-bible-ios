//
//  VBUploadController.h
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VBCompletionHandlerWithError)(NSError *__nullable error);

@interface VBUploadController : NSObject

+ (void)uploadData:(nonnull NSData *)data
          filename:(nonnull NSString *)filename
            bucket:(nonnull NSString *)bucket
       contentType:(nonnull NSString *)contentType
        completion:(nullable VBCompletionHandlerWithError)completion;

@end
