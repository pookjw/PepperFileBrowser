//
//  FilesSectionModel.h
//  PepperFileBrowser
//
//  Created by Jinwoo Kim on 3/30/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FilesSectionModelType) {
    FilesSectionModelTypeDirectories,
    FilesSectionModelTypeFiles
};

@interface FilesSectionModel : NSObject
@property (readonly) FilesSectionModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(FilesSectionModelType)type;
@end

NS_ASSUME_NONNULL_END
