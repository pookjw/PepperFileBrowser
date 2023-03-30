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
    
    ((void (*)(id, SEL, BOOL))objc_msgSend)(stackView, NSSelectorFromString(@"setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    id stackViewTopAnchor = ((id (*)(id, SEL))objc_msgSend)(stackView, NSSelectorFromString(@"topAnchor"));
    id contentViewTopAnchor = ((id (*)(id, SEL))objc_msgSend)(contentView, NSSelectorFromString(@"topAnchor"));
    
    id stackViewLeadingAnchor = ((id (*)(id, SEL))objc_msgSend)(stackView, NSSelectorFromString(@"leadingAnchor"));
    id contentViewLeadingAnchor = ((id (*)(id, SEL))objc_msgSend)(contentView, NSSelectorFromString(@"leadingAnchor"));
    
    id stackViewTrailingAnchor = ((id (*)(id, SEL))objc_msgSend)(stackView, NSSelectorFromString(@"trailingAnchor"));
    id contentViewTrailingAnchor = ((id (*)(id, SEL))objc_msgSend)(contentView, NSSelectorFromString(@"trailingAnchor"));
    
    id stackViewBottomAnchor = ((id (*)(id, SEL))objc_msgSend)(stackView, NSSelectorFromString(@"bottomAnchor"));
    id contentViewBottomAnchor = ((id (*)(id, SEL))objc_msgSend)(contentView, NSSelectorFromString(@"bottomAnchor"));
    
    id stackViewBottomConstraint = ((id (*)(id, SEL, id))objc_msgSend)(stackViewBottomAnchor, NSSelectorFromString(@"constraintEqualToAnchor:"), contentViewBottomAnchor);
    ((void (*)(id, SEL, float))objc_msgSend)(stackViewBottomConstraint, NSSelectorFromString(@"setPriority:"), 750.f);
    
    NSArray *stackViewConstraints = @[
        ((id (*)(id, SEL, id))objc_msgSend)(stackViewTopAnchor, NSSelectorFromString(@"constraintEqualToAnchor:"), contentViewTopAnchor),
        ((id (*)(id, SEL, id))objc_msgSend)(stackViewLeadingAnchor, NSSelectorFromString(@"constraintEqualToAnchor:"), contentViewLeadingAnchor),
        ((id (*)(id, SEL, id))objc_msgSend)(stackViewTrailingAnchor, NSSelectorFromString(@"constraintEqualToAnchor:"), contentViewTrailingAnchor),
        stackViewBottomConstraint
    ];
    
    ((void (*)(id, SEL, id))objc_msgSend)(contentView, NSSelectorFromString(@"addSubview:"), stackView);
    
    ((void (*)(id, SEL, NSArray *))objc_msgSend)(NSClassFromString(@"NSLayoutConstraints"), NSSelectorFromString(@"activateConstraints:"), stackViewConstraints);
    
    //
    
    id label = ((id (*)(id, SEL, CGRect))objc_msgSend)([NSClassFromString(@"UILabel") alloc], NSSelectorFromString(@"initWithFrame:"), CGRectNull);
    
    ((void (*)(id, SEL, NSInteger))objc_msgSend)(label, NSSelectorFromString(@"setNumberOfLines:"), 0);
    
    ((void (*)(id, SEL, id))objc_msgSend)(stackView, NSSelectorFromString(@"addArrangedSubview:"), label);
    
    object_setInstanceVariable(self, "_label", [label retain]);
    [label release];
    
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
