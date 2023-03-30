//
//  FilesSectionModel.m
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import "FilesSectionModel.h"

@implementation FilesSectionModel

- (instancetype)initWithType:(FilesSectionModelType)type {
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (NSUInteger)hash {
    return self.type;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:FilesSectionModel.class]) {
        return [super isEqual:object];
    }
    
    FilesSectionModel *other = object;
    
    return self.type == other.type;
}

@end
