//
//  FilesViewModel.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import "FilesViewModel.h"
#import "FilesSectionModel.h"
#import <objc/message.h>

@interface FilesViewModel ()
@property (retain) id dataSource;
@property (retain) NSOperationQueue *queue;
@end

@implementation FilesViewModel

- (instancetype)initWithDataSource:(id)dataSource url:(NSURL *)url {
    if (self = [super init]) {
        self.dataSource = dataSource;
        
        [_url release];
        _url = [url copy];
        
        [self setupQueue];
    }
    
    return self;
}

- (void)dealloc {
    [_url release];
    [_queue release];
    [_dataSource release];
    [super dealloc];
}

- (void)loadDataSource {
    NSURL *url = self.url;
    id dataSource = self.dataSource;
    __block typeof(self) unretainedSelf = self;
    
    __block NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSError * _Nullable error = nil;
        NSArray<NSURL *> *contentURLs = [NSFileManager.defaultManager contentsOfDirectoryAtURL:url
                                                           includingPropertiesForKeys:@[NSURLFileResourceTypeKey]
                                                                              options:0 
                                                                                error:&error];
        
        if (error) {
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameFilesViewModelDidErrorOccur
                                                              object:unretainedSelf
                                                            userInfo:@{FilesViewModelErrorKey: error}];
            return;
        }
        
        if (blockOperation.isCancelled) {
            return;
        }
        
        //
        
        id snapshot = [NSClassFromString(@"NSDiffableDataSourceSnapshot") new];
        
        NSMutableArray<FilesItemModel *> *directoryItemModels = [NSMutableArray<FilesItemModel *> new];
        NSMutableArray<FilesItemModel *> *fileItemModels = [NSMutableArray<FilesItemModel *> new];
        
        [contentURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
            id _Nullable fileResourceTypeKey;
            NSError * _Nullable error = nil;
            [url getResourceValue:&fileResourceTypeKey forKey:NSURLFileResourceTypeKey error:&error];
            
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            
            if (fileResourceTypeKey == nil) {
                return;
            }
            
            BOOL isDirectory = ([NSURLFileResourceTypeDirectory isEqualToString:fileResourceTypeKey] || ([NSURLFileResourceTypeSymbolicLink isEqualToString:fileResourceTypeKey]));
            
            FilesItemModel *itemModel = [[FilesItemModel alloc] initWithURL:url isDirectory:isDirectory];
            
            if (isDirectory) {
                [directoryItemModels addObject:itemModel];
            } else {
                [fileItemModels addObject:itemModel];
            }
            
            [itemModel release];
        }];
        
        if (directoryItemModels.count) {
            [directoryItemModels sortUsingComparator:^NSComparisonResult(FilesItemModel * _Nonnull obj1, FilesItemModel * _Nonnull obj2) {
                return [obj1.url.lastPathComponent compare:obj2.url.lastPathComponent options:NSCaseInsensitiveSearch];
            }];
            
            FilesSectionModel *sectionModel = [[FilesSectionModel alloc] initWithType:FilesSectionModelTypeDirectories];
            
            ((void (*)(id, SEL, NSArray *))objc_msgSend)(snapshot, NSSelectorFromString(@"appendSectionsWithIdentifiers:"), @[sectionModel]);
            
            ((void (*)(id, SEL, NSArray *, id))objc_msgSend)(snapshot, NSSelectorFromString(@"appendItemsWithIdentifiers:intoSectionWithIdentifier:"), directoryItemModels, sectionModel);
            
            [sectionModel release];
        }
        
        [directoryItemModels release];
        
        if (fileItemModels.count) {
            [fileItemModels sortUsingComparator:^NSComparisonResult(FilesItemModel * _Nonnull obj1, FilesItemModel * _Nonnull obj2) {
                return [obj1.url.lastPathComponent compare:obj2.url.lastPathComponent options:NSCaseInsensitiveSearch];
            }];
            
            FilesSectionModel *sectionModel = [[FilesSectionModel alloc] initWithType:FilesSectionModelTypeFiles];
            
            ((void (*)(id, SEL, NSArray *))objc_msgSend)(snapshot, NSSelectorFromString(@"appendSectionsWithIdentifiers:"), @[sectionModel]);
            
            ((void (*)(id, SEL, NSArray *, id))objc_msgSend)(snapshot, NSSelectorFromString(@"appendItemsWithIdentifiers:intoSectionWithIdentifier:"), fileItemModels, sectionModel);
            
            [sectionModel release];
        }
        
        [fileItemModels release];
        
        //
        
        if (blockOperation.isCancelled) {
            [snapshot release];
            return;
        }
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ((void (*)(id, SEL, id, BOOL, void (^)(void)))objc_msgSend)(dataSource, NSSelectorFromString(@"applySnapshot:animatingDifferences:completion:"), snapshot, YES, ^{
            dispatch_semaphore_signal(semaphore);
        });
        
        [snapshot release];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
    }];
    
    [self.queue addOperation:blockOperation];
}

- (void)itemModelFromIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^)(FilesItemModel * _Nullable))completionHandler {
    id dataSource = self.dataSource;
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        FilesItemModel * _Nullable itemModel = ((id (*)(id, SEL, NSIndexPath *))objc_msgSend)(dataSource, NSSelectorFromString(@"itemIdentifierForIndexPath:"), indexPath);
        completionHandler(itemModel);
    }];
    
    [self.queue addOperation:operation];
}

- (void)setupQueue {
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUserInitiated;
    queue.maxConcurrentOperationCount = 1;
    self.queue = queue;
    [queue release];
}

@end
