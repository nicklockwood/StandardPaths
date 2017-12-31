//
//  StandardPaths.h
//
//  Version 1.6.6
//
//  Created by Nick Lockwood on 10/11/2011.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/StandardPaths
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import <Foundation/Foundation.h>
#import <Availability.h>
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <UIKit/UIKit.h>
#endif


#ifndef SP_SWIZZLE_ENABLED
#define SP_SWIZZLE_ENABLED 1
#endif


#if TARGET_OS_IPHONE

#define UIUserInterfaceIdiomDesktop (UIUserInterfaceIdiomUnspecified - 1)

#else

#ifndef UI_USER_INTERFACE_IDIOM
#define UI_USER_INTERFACE_IDIOM() UIUserInterfaceIdiomDesktop

typedef NS_ENUM(NSInteger, UIUserInterfaceIdiom)
{
  UIUserInterfaceIdiomDesktop = -2,
  UIUserInterfaceIdiomUnspecified = -1,
  UIUserInterfaceIdiomPhone,
  UIUserInterfaceIdiomPad,
  UIUserInterfaceIdiomTV,
  UIUserInterfaceIdiomCarPlay
};

#endif
#endif


#ifndef SP_CONSTANTS_DEFINED
#define SP_CONSTANTS_DEFINED

static NSString *const SPPhoneSuffix = @"~iphone";
static NSString *const SPPadSuffix = @"~ipad";
static NSString *const SPTVSuffix = @"~tv";
static NSString *const SPCarSuffix = @"~car";
static NSString *const SPDesktopSuffix = @"~mac";
static NSString *const SPRetinaSuffix = @"@2x";
static NSString *const SPHDSuffix = @"-hd";

#endif


@interface NSFileManager (StandardPaths)

@property (nonatomic, readonly) NSString *publicDataPath;
@property (nonatomic, readonly) NSString *privateDataPath;
@property (nonatomic, readonly) NSString *cacheDataPath;
@property (nonatomic, readonly) NSString *offlineDataPath;
@property (nonatomic, readonly) NSString *temporaryDataPath;
@property (nonatomic, readonly) NSString *resourcePath;

- (NSString *)pathForPublicFile:(NSString *)file;
- (NSString *)pathForPrivateFile:(NSString *)file;
- (NSString *)pathForCacheFile:(NSString *)file;
- (NSString *)pathForOfflineFile:(NSString *)file;
- (NSString *)pathForTemporaryFile:(NSString *)file;
- (NSString *)pathForResource:(NSString *)file;

- (NSString *)normalizedPathForFile:(NSString *)fileOrPath;
- (NSString *)normalizedPathForFile:(NSString *)fileOrPath ofType:(NSString *)extension;

@end


@interface NSString (StandardPaths)

- (NSString *)stringByReplacingPathExtensionWithExtension:(NSString *)extension;

@property (nonatomic, readonly) BOOL hasPathExtension;

- (NSString *)stringByAppendingPathSuffix:(NSString *)suffix;
- (NSString *)stringByDeletingPathSuffix:(NSString *)suffix;
- (BOOL)hasPathSuffix:(NSString *)suffix;

- (NSString *)stringByAppendingSuffixForInterfaceIdiom:(UIUserInterfaceIdiom)idiom;

@property (nonatomic, readonly) NSString *stringByAppendingDeviceInterfaceIdiomSuffix;
@property (nonatomic, readonly) NSString *stringByDeletingInterfaceIdiomSuffix;
@property (nonatomic, readonly) NSString *interfaceIdiomSuffix;
@property (nonatomic, readonly) BOOL hasInterfaceIdiomSuffix;

@property (nonatomic, readonly) UIUserInterfaceIdiom interfaceIdiomFromSuffix;

- (NSString *)stringByAppendingSuffixForScale:(CGFloat)scale;

@property (nonatomic, readonly) NSString *stringByAppendingDeviceScaleSuffix;
@property (nonatomic, readonly) NSString *stringByDeletingScaleSuffix;
@property (nonatomic, readonly) NSString *scaleSuffix;
@property (nonatomic, readonly) BOOL hasScaleSuffix;

@property (nonatomic, readonly) NSString *stringByAppendingHDSuffix;
@property (nonatomic, readonly) NSString *stringByAppendingHDSuffixIfDeviceIsHD;
@property (nonatomic, readonly) NSString *stringByDeletingHDSuffix;
@property (nonatomic, readonly) BOOL hasHDSuffix;

@property (nonatomic, readonly) CGFloat scaleFromSuffix;

- (NSString *)stringByAppendingSuffixForHeight:(CGFloat)height;

@property (nonatomic, readonly) NSString *stringByAppendingDeviceHeightSuffix;
@property (nonatomic, readonly) NSString *stringByDeletingHeightSuffix;
@property (nonatomic, readonly) NSString *heightSuffix;
@property (nonatomic, readonly) BOOL hasHeightSuffix;

@property (nonatomic, readonly) CGFloat heightFromSuffix;

@end


@interface NSString (StandardPaths_Deprecated)

- (NSString *)stringByAppendingRetinaSuffix __deprecated;
- (NSString *)stringByAppendingRetinaSuffixIfDeviceIsRetina __deprecated;
- (NSString *)stringByDeletingRetinaSuffix __deprecated;
- (BOOL)hasRetinaSuffix __deprecated;

- (NSString *)stringByAppendingRetina4Suffix __deprecated;
- (NSString *)stringByAppendingRetina4SuffixIfDeviceIsRetina4 __deprecated;
- (NSString *)stringByDeletingRetina4Suffix __deprecated;
- (BOOL)hasRetina4Suffix __deprecated;

@end
