//
//  StandardPaths.h
//
//  Version 1.5.6
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


#ifndef UI_USER_INTERFACE_IDIOM
#define UI_USER_INTERFACE_IDIOM() UIUserInterfaceIdiomDesktop

typedef enum
{
    UIUserInterfaceIdiomPhone,
    UIUserInterfaceIdiomPad,
    UIUserInterfaceIdiomDesktop
}
UIUserInterfaceIdiom;

#elif defined(__IPHONE_OS_VERSION_MAX_ALLOWED)

#define UIUserInterfaceIdiomDesktop (UIUserInterfaceIdiomPad + 1)

#endif


static NSString *const SPPhoneSuffix = @"~iphone";
static NSString *const SPPadSuffix = @"~ipad";
static NSString *const SPDesktopSuffix = @"~mac";
static NSString *const SPRetinaSuffix = @"@2x";
static NSString *const SPHDSuffix = @"-hd";
static NSString *const SPRetina4Suffix = @"-568h";


@interface NSFileManager (StandardPaths)

- (NSString *)publicDataPath;
- (NSString *)privateDataPath;
- (NSString *)cacheDataPath;
- (NSString *)offlineDataPath;
- (NSString *)temporaryDataPath;
- (NSString *)resourcePath;

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
- (BOOL)hasPathExtension;

- (NSString *)stringByAppendingPathSuffix:(NSString *)suffix;
- (NSString *)stringByDeletingPathSuffix:(NSString *)suffix;
- (BOOL)hasPathSuffix:(NSString *)suffix;

- (NSString *)stringByAppendingSuffixForInterfaceIdiom:(UIUserInterfaceIdiom)idiom;
- (NSString *)stringByAppendingInterfaceIdiomSuffix;
- (NSString *)stringByDeletingInterfaceIdiomSuffix;
- (NSString *)interfaceIdiomSuffix;
- (BOOL)hasInterfaceIdiomSuffix;

- (UIUserInterfaceIdiom)interfaceIdiomFromSuffix;

- (NSString *)stringByAppendingSuffixForScale:(CGFloat)scale;
- (NSString *)stringByAppendingDeviceScaleSuffix;
- (NSString *)stringByDeletingScaleSuffix;
- (NSString *)scaleSuffix;
- (BOOL)hasScaleSuffix;

- (NSString *)stringByAppendingRetinaSuffix;
- (NSString *)stringByAppendingRetinaSuffixIfDeviceIsRetina;
- (NSString *)stringByDeletingRetinaSuffix;
- (BOOL)hasRetinaSuffix;

- (NSString *)stringByAppendingHDSuffix;
- (NSString *)stringByAppendingHDSuffixIfDeviceIsHD;
- (NSString *)stringByDeletingHDSuffix;
- (BOOL)hasHDSuffix;

- (CGFloat)scaleFromSuffix;

- (NSString *)stringByAppendingRetina4Suffix;
- (NSString *)stringByAppendingRetina4SuffixIfDeviceIsRetina4;
- (NSString *)stringByDeletingRetina4Suffix;
- (BOOL)hasRetina4Suffix;

@end
