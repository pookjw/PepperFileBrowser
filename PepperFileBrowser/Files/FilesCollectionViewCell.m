//
//  FilesCollectionViewCell.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import "FilesCollectionViewCell.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

static void FilesCollectionViewCell_dealloc(id self, SEL cmd) {
    id label;
    object_getInstanceVariable(self, "label", (void **)&label);
    [label release];
    
    struct objc_super superInfo = { self, [self superclass] };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper2)(&superInfo, cmd);
}

static id FilesCollectionViewCell_initWithFrame(id self, SEL cmd, CGRect frame) {
    struct objc_super superInfo = { self, [self superclass] };
    self = ((id (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper2)(&superInfo, cmd, frame);
    
    id contentView = ((id (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"contentView"));
    CGRect bounds = ((CGRect (*)(id, SEL))objc_msgSend)(contentView, NSSelectorFromString(@"bounds"));
    
    id label = ((id (*)(id, SEL, CGRect))objc_msgSend)([NSClassFromString(@"UILabel") alloc], NSSelectorFromString(@"initWithFrame:"), bounds);
    
    ((void (*)(id, SEL, NSInteger))objc_msgSend)(label, NSSelectorFromString(@"setNumberOfLines:"), 0);
    
    ((void (*)(id, SEL, id))objc_msgSend)(contentView, NSSelectorFromString(@"addSubview:"), label);
    
    object_setInstanceVariable(self, "label", [label retain]);
    [label release];
    
    return self;
}

Class FilesCollectionViewCell(void) {
    static Class _Nullable FilesCollectionViewCell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        FilesCollectionViewCell = objc_allocateClassPair(NSClassFromString(@"PUICListPlatterCell"), "FilesCollectionViewCell", 0);
        
        class_addIvar(FilesCollectionViewCell, "label", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        
        class_addMethod(FilesCollectionViewCell, @selector(dealloc), (IMP)FilesCollectionViewCell_dealloc, nil);
        class_addMethod(FilesCollectionViewCell, NSSelectorFromString(@"initWithFrame:"), (IMP)FilesCollectionViewCell_initWithFrame, nil);
    });
    
    return FilesCollectionViewCell;
}

void FilesCollectionViewCell_configureWithItemModel(id self, FilesItemModel *itemModel) {
    id label;
    object_getInstanceVariable(self, "label", (void **)&label);
    ((void (*)(id, SEL, NSString *))objc_msgSend)(label, NSSelectorFromString(@"setText:"), itemModel.url.lastPathComponent);
}
