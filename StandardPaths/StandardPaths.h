//
//  StandardPaths.h
//
//  Version 1.3
//
//  Created by Nick Lockwood on 10/11/2011.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#standardpaths
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


#ifndef UI_USER_INTERFACE_IDIOM
#define UI_USER_INTERFACE_IDIOM() UIUserInterfaceIdiomDesktop

typedef enum
{
    UIUserInterfaceIdiomPhone,
    UIUserInterfaceIdiomPad,
    UIUserInterfaceIdiomDesktop
}
UIUserInterfaceIdiom;

#endif


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

@end


@interface NSString (StandardPaths)

- (NSString *)stringByAppendingInterfaceIdiomSuffix;
- (NSString *)stringByDeletingInterfaceIdiomSuffix;
- (NSString *)interfaceIdiomSuffix;
- (UIUserInterfaceIdiom)interfaceIdiom;

- (NSString *)stringByAppendingScaleSuffix;
- (NSString *)stringByDeletingScaleSuffix;
- (NSString *)scaleSuffix;
- (CGFloat)scale;
- (BOOL)isRetina;

- (NSString *)stringByAppendingHDSuffix;
- (NSString *)stringByDeletingHDSuffix;
- (NSString *)HDSuffix;
- (BOOL)isHD;

- (NSString *)stringByAppendingTallscreenSuffix;
- (NSString *)stringByDeletingTallscreenSuffix;
- (NSString *)tallscreenSuffix;
- (BOOL)isTallscreen;

@end