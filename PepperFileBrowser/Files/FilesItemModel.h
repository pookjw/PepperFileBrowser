//
//  FilesItemModel.h
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilesItemModel : NSObject
@property (copy, readonly, nonatomic) NSURL *url;
@property (assign, readonly, nonatomic) BOOL isDirectory;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url isDirectory:(BOOL)isDirectory;
@end

NS_ASSUME_NONNULL_END
