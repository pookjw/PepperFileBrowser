//
//  FilesItemModel.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import "FilesItemModel.h"

@implementation FilesItemModel

- (instancetype)initWithURL:(NSURL *)url isDirectory:(BOOL)isDirectory {
    if (self = [super init]) {
        [_url release];
        _url = [url copy];
        
        _isDirectory = isDirectory;
    }
    
    return self;
}

- (void)dealloc {
    [_url release];
    [super dealloc];
}

- (NSUInteger)hash {
    return self.url.hash;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:FilesItemModel.class]) {
        return [super isEqual:object];
    }
    
    FilesItemModel *other = object;
    return [self.url isEqual:other.url];
}

@end
