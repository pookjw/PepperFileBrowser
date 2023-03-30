//
//  FilesViewController.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import "FilesViewController.h"
#import "FilesViewModel.h"
#import "FilesCollectionViewCell.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

static void FilesViewController_dealloc(id self, SEL cmd) {
    FilesViewModel *viewModel;
    object_getInstanceVariable(self, "viewModel", (void **)&viewModel);
    [viewModel release];
    
    NSURL *url;
    object_getInstanceVariable(self, "url", (void **)&url);
    [url release];
    
    struct objc_super superInfo = { self, [self superclass] };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper2)(&superInfo, cmd);
}

static void FilesViewController_loadView(id self, SEL cmd) {
    id layout = [NSClassFromString(@"PUICListCollectionViewLayout") new];
    id collectionView = ((id (*)(id, SEL, CGRect, id))objc_msgSend)([NSClassFromString(@"PUICListCollectionView") alloc], NSSelectorFromString(@"initWithFrame:collectionViewLayout:"), CGRectNull, layout);
    
    [layout release];
    
    ((void (*)(id, SEL, id))objc_msgSend)(collectionView, NSSelectorFromString(@"setDelegate:"), self);
    ((void (*)(id, SEL, id))objc_msgSend)(self, NSSelectorFromString(@"setView:"), collectionView);
    
    [collectionView release];
}

static void FilesViewController_viewDidLoad(id self, SEL cmd) {
    struct objc_super superInfo = { self, [self superclass] };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&superInfo, cmd);
    
    id collectionView = ((id (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"view"));
    
    void (^cellRegistrationHandler)(id, NSIndexPath *, id) = ^(id cell, NSIndexPath *indexPath, id item) {
        FilesCollectionViewCell_configureWithItemModel(cell, item);
    };
    
    id cellRegistration = ((id (*)(id, SEL, Class, void (^)(id, NSIndexPath *, id)))objc_msgSend)(NSClassFromString(@"UICollectionViewCellRegistration"), NSSelectorFromString(@"registrationWithCellClass:configurationHandler:"), FilesCollectionViewCell(), cellRegistrationHandler);
    
    id dataSource = ((id (*)(id, SEL, id, id _Nullable (^)(id, NSIndexPath *, id)))objc_msgSend)([NSClassFromString(@"UICollectionViewDiffableDataSource") alloc], NSSelectorFromString(@"initWithCollectionView:cellProvider:"), collectionView, ^id _Nullable(id collectionView, NSIndexPath *indexPath, id itemIdentifier) {
        id cell = ((id (*)(id, SEL, id, NSIndexPath *, id))objc_msgSend)(collectionView, NSSelectorFromString(@"dequeueConfiguredReusableCellWithRegistration:forIndexPath:item:"), cellRegistration, indexPath, itemIdentifier);
        return cell;
    });
    
    NSURL *url;
    object_getInstanceVariable(self, "url", (void **)&url);
    FilesViewModel *viewModel = [[FilesViewModel alloc] initWithDataSource:dataSource url:url];
    [dataSource release];
    object_setInstanceVariable(self, "viewModel", [viewModel retain]);
    [viewModel loadDataSource];
    [viewModel release];
}

static void FilesViewController_collectionView_didSelectItemAtIndexPath(id self, SEL cmd, id collectionView, NSIndexPath *indexPath) {
    FilesViewModel *viewModel;
    object_getInstanceVariable(self, "viewModel", (void **)&viewModel);
    id navigationController = ((id (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"navigationController"));
    
    [viewModel itemModelFromIndexPath:indexPath completionHandler:^(FilesItemModel * _Nullable itemModel) {
        NSURL * _Nullable url = itemModel.url;
        
        if (url) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                id filesViewController = FilesViewController_initWithURL([FilesViewController() alloc], url);
                ((void (*)(id, SEL, id, BOOL))objc_msgSend)(navigationController, NSSelectorFromString(@"pushViewController:animated:"), filesViewController, YES);
                [filesViewController release];
            }];
        }
    }];
}

Class FilesViewController(void) {
    static Class _Nullable FilesViewController = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        FilesViewController = objc_allocateClassPair(NSClassFromString(@"SPViewController"), "FilesViewController", 0);
        
        class_addIvar(FilesViewController, "viewModel", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        class_addIvar(FilesViewController, "url", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        
        class_addMethod(FilesViewController, @selector(dealloc), (IMP)FilesViewController_dealloc, nil);
        class_addMethod(FilesViewController, NSSelectorFromString(@"loadView"), (IMP)FilesViewController_loadView, nil);
        class_addMethod(FilesViewController, NSSelectorFromString(@"viewDidLoad"), (IMP)FilesViewController_viewDidLoad, nil);
        class_addMethod(FilesViewController, NSSelectorFromString(@"collectionView:didSelectItemAtIndexPath:"), (IMP)FilesViewController_collectionView_didSelectItemAtIndexPath, nil);
    });
    
    return FilesViewController;
}

id FilesViewController_initWithURL(id self, NSURL *url) {
    self = ((id (*)(id, SEL))objc_msgSend)(self, @selector(init));
    
    if (self) {
        object_setInstanceVariable(self, "url", [url copy]);
    }
    
    return self;
}
