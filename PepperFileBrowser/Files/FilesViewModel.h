//
//  FilesViewModel.h
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import <Foundation/Foundation.h>
#import "FilesItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameFilesViewModelDidErrorOccur = @"NSNotificationNameFilesViewModelDidErrorOccur";
static NSString * const FilesViewModelErrorKey = @"FilesViewModelErrorKey";

@interface FilesViewModel : NSObject
@property (copy, readonly) NSURL *url;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(id)dataSource url:(NSURL *)url;
- (void)loadDataSource;
- (void)itemModelFromIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^)(FilesItemModel * _Nullable itemModel))completionHandler;
@end

NS_ASSUME_NONNULL_END
