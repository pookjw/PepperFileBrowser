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
    id stackView;
    object_getInstanceVariable(self, "_stackView", (void **)&stackView);
    [stackView release];
    
    id leadingImageView;
    object_getInstanceVariable(self, "_leadingImageView", (void **)&leadingImageView);
    [leadingImageView release];
    
    id label;
    object_getInstanceVariable(self, "_label", (void **)&label);
    [label release];
    
    id trailingImageView;
    object_getInstanceVariable(self, "_trailingImageView", (void **)&trailingImageView);
    [trailingImageView release];
    
    struct objc_super superInfo = { self, [self superclass] };
    ((void (*)(struct objc_super *, SEL))objc_msgSendSuper2)(&superInfo, cmd);
}

static id FilesCollectionViewCell_initWithFrame(id self, SEL cmd, CGRect frame) {
    struct objc_super superInfo = { self, [self superclass] };
    self = ((id (*)(struct objc_super *, SEL, CGRect))objc_msgSendSuper2)(&superInfo, cmd, frame);
    
    id contentView = ((id (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"contentView"));
    CGRect bounds = ((CGRect (*)(id, SEL))objc_msgSend)(contentView, NSSelectorFromString(@"bounds"));
    
    //
    
    id stackView = ((id (*)(id, SEL, CGRect))objc_msgSend)([NSClassFromString(@"UIStackView") alloc], NSSelectorFromString(@"initWithFrame:"), bounds);
    
    ((void (*)(id, SEL, id))objc_msgSend)(contentView, NSSelectorFromString(@"addSubview:"), stackView);
    
    //
    
    id leadingImageView = [NSClassFromString(@"UIImageView") new];
    UIImage *folderImage = [UIImage systemImageNamed:@"folder"];
    ((void (*)(id, SEL, UIImage *))objc_msgSend)(leadingImageView, NSSelectorFromString(@"setImage:"), folderImage);
    
    ((void (*)(id, SEL, id))objc_msgSend)(stackView, NSSelectorFromString(@"addArrangedSubview:"), leadingImageView);
    
    object_setInstanceVariable(self, "_leadingImageView", [leadingImageView retain]);
    [leadingImageView release];
    
    //
    
    id label = ((id (*)(id, SEL, CGRect))objc_msgSend)([NSClassFromString(@"UILabel") alloc], NSSelectorFromString(@"initWithFrame:"), CGRectNull);
    
    ((void (*)(id, SEL, NSInteger))objc_msgSend)(label, NSSelectorFromString(@"setNumberOfLines:"), 0);
    
    ((void (*)(id, SEL, id))objc_msgSend)(stackView, NSSelectorFromString(@"addArrangedSubview:"), label);
    
    object_setInstanceVariable(self, "_label", [label retain]);
    [label release];
    
    //
    
    id trailingImageView = [NSClassFromString(@"UIImageView") new];
    UIImage *chevronRightImage = [UIImage systemImageNamed:@"chevron.right"];
    ((void (*)(id, SEL, UIImage *))objc_msgSend)(trailingImageView, NSSelectorFromString(@"setImage:"), chevronRightImage);
    
    ((void (*)(id, SEL, id))objc_msgSend)(stackView, NSSelectorFromString(@"addArrangedSubview:"), trailingImageView);
    
    object_setInstanceVariable(self, "_trailingImageView", [trailingImageView retain]);
    [trailingImageView release];
    
    //
    
    object_setInstanceVariable(self, "_stackView", [stackView retain]);
    [stackView release];
    
    return self;
}

Class FilesCollectionViewCell(void) {
    static Class _Nullable FilesCollectionViewCell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        FilesCollectionViewCell = objc_allocateClassPair(NSClassFromString(@"PUICListPlatterCell"), "FilesCollectionViewCell", 0);
        
        class_addIvar(FilesCollectionViewCell, "_stackView", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        class_addIvar(FilesCollectionViewCell, "_leadingImageView", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        class_addIvar(FilesCollectionViewCell, "_label", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        class_addIvar(FilesCollectionViewCell, "_trailingImageView", sizeof(id), rint(log2(sizeof(id))), @encode(id));
        
        class_addMethod(FilesCollectionViewCell, @selector(dealloc), (IMP)FilesCollectionViewCell_dealloc, nil);
        class_addMethod(FilesCollectionViewCell, NSSelectorFromString(@"initWithFrame:"), (IMP)FilesCollectionViewCell_initWithFrame, nil);
    });
    
    return FilesCollectionViewCell;
}

void FilesCollectionViewCell_configureWithItemModel(id self, FilesItemModel *itemModel) {
    id label;
    object_getInstanceVariable(self, "_label", (void **)&label);
    ((void (*)(id, SEL, NSString *))objc_msgSend)(label, NSSelectorFromString(@"setText:"), itemModel.url.lastPathComponent);
}
