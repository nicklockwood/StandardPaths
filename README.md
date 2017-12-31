Purpose
-------------

iOS and the Mac App Store place quite strict conditions on where files should be stored, but it's not always clear where the right place is. As of iOS 5.0 it's even more complex because of the need to ensure that certain files aren't backed up to iCloud or aren't wiped out when the device gets full.

Also, since the advent of Retina displays and hybrid apps, it is often hard to identify the correct file path for resources such as images or nib files because on different devices they may have different suffixes such as @2x or ~ipad, and whilst many iOS and Mac OS APIs manage these suffixes automatically, they do so in an inconsistent and opaque way.

Support for the -568h file suffix for targeting the iPhone 5 screen is also frustratingly limited to only the launch image, and is not generally supported for loading images, nib files, etc.

StandardPaths provides a simple set of NSFileManager extension methods to access files in a clear and consistent way across platforms, and abstracts the complexity of applying the mobile backup attribute to disable iCloud backup on iOS 5 and above.

StandardPaths also provides NSString extension methods for manipulating file suffixes for Retina graphics, iPhone 5 and device idioms (phone/pad/desktop) to simplify loading device-specific resources.

Finally, StandardPaths swizzles some of the methods in UIKit and AppKit so that they gain additional intelligence when loading device-specific resources. This enables you to load the correct images and nib files for iPhone5 based on the file suffix instead of ugly runtime code checks of the display size. This swizzling can be disabled if you would prefer not to mess with the standard behaviour (see below for details).


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 11.2 / Mac OS 10.12 (Xcode 9.2)
* Earliest supported deployment target - iOS 8.0 / Mac OS 10.11
* Earliest compatible deployment target - iOS 7.0 / Mac OS 10.7

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

StandardPaths work with both ARC and non-ARC projects. There is no need to exclude StandardPaths files from the ARC validation process, or to convert StandardPaths using the ARC conversion tool.


Thread Safety
--------------

You can call the StandardPaths methods safely from any thread.


Installation
--------------

To use the StandardPaths in your project, just drag the StandardPaths.h and .m files into your project. It has no dependencies.


NSFileManager extension methods
--------------------------------

StandardPaths extends NSFileManager with a collection of useful standard directories. Most methods come in two versions, one that returns just the path to the directory and a second that returns a path for a specific file name or path fragment within that directory. In the interests of concision, these methods are paired together in the documentation below.

```objc
- (NSString *)publicDataPath;
- (NSString *)pathForPublicFile:(NSString *)file;
```
	
Return the path for the user `Documents` folder. On iOS this a good place to store user-created documents. You can make these documents available for the user to access through iTunes by setting `UIFileSharingEnabled` to YES in the application's Info.plist. For this reason it's a bad idea to store private application data files in the `Documents` folder as you lose this flexibility. You should store these in `Library/Application Support` instead. Note also that the Mac App Store sandbox rules prohibit accessing files in `Documents` without requesting explicit permission from the user.

```objc
- (NSString *)privateDataPath;
- (NSString *)pathForPrivateFile:(NSString *)file;
```
	
Returns the path for `Library/Application Support` on iOS, or `Library/Application Support/<AppName>` on Mac OS and creates it if it does not exist. This is a good place to store application data files that are not user editable and so shouldn't be stored in the `Documents` folder.

```objc
- (NSString *)cacheDataPath;
- (NSString *)pathForCacheFile:(NSString *)file;
```
	
Returns the path to the Application's `Library/Caches` folder. On Mac OS, the path will include a subfolder named after the Application's bundle ID to prevent namespace collisions. If your app downloads data from the Internet, or caches the result of expensive calculations, this is a good place to store the result. On iOS 5 and above these files will be deleted automatically when the device runs low on space, so if the data is important you should store it using the `offlineDataPath` instead.

```objc
- (NSString *)offlineDataPath;
- (NSString *)pathForOfflineFile:(NSString *)file;
```

Returns the path for `Library/Application Support/Offline Data` on iOS, or `Library/Application Support/<AppName>/Offline Data` on Mac OS and creates it if it does not exist. This is not a standard defined path, but it is a safe place to put cache files that you do not wish to be automatically deleted when the device runs low on disk space. On iOS 5.0.1 the `com.apple.MobileBackup` attribute is set on this folder to prevent it from being automatically backed up to iCloud. This flag is deprecated in iOS 5.1, so when compiling for 5.1 and above, a new API is used. These mechanisms are not available prior to iOS 5.0.1, so users on iOS 5.0 will find that these files are synced to their cloud space. Previous releases of the StandardPaths library stored offline data files in `Library/Caches`, but this would cause inconvenience for users upgrading from iOS 4/5 to 5.0.1 that is probably not justified, so as of version 1.1, offlineDataPath no longer does this.
	
```objc
- (NSString *)temporaryDataPath;
- (NSString *)pathForTemporaryFile:(NSString *)file;
```
	
Returns the path for the temporary data folder. This is a good place to store temporary files e.g. during some complex process where the data can't all fit in memory. Files stored here *may* be deleted automatically when the application is closed, or when the device runs low on memory, but it's a good idea to delete them yourself anyway when you've finished with them.

```objc
- (NSString *)resourcePath;
- (NSString *)pathForResource:(NSString *)file;
```
	
Returns the path for files in the application resources folder. This basically just maps to `[[NSBundle mainBundle] resourcePath]`. Files in this folder are read-only. Note that unlike the `[[NSBundle mainBundle] pathForResource:ofType:]` method, `pathForResource:` does not return nil if the file does not exist.

```objc
- (NSString *)normalizedPathForFile:(NSString *)fileOrPath;
- (NSString *)normalizedPathForFile:(NSString *)fileOrPath ofType:(NSString *)ext;
```

This method takes a file name or path and normalizes them by performing the following operations:

1) It can take a path fragment or file name and convert it to a complete path by prefixing the application bundle resources path. Secondly, it replicates the behaviours of Mac OS and iOS when finding different versions of resource files such as @2x image files or files suffixed with ~ipad or ~iphone (and adds a ~mac extension option for cross-platform consistency).

2) It supports the iPhone 5 "-568h" suffix for files designed specifically for the taller screen. Apple don't provide any built-in support for this suffix other than on the Default.png startup image, but the `normalizedFilePathForFile:` method will detect and use any file with this extension (with or without the @2x) when running on an iPhone 5 and use it in preference to non-suffixed files with the same name. This is very useful for loading iPhone 5-specific images and nib files automatically without ugly runtime code checks.

3) It implements the Cocos2D -hd suffix pseudo-standard to indicate image files that should be used both for Retina iPhones and standard definition iPads/Macs. This allows you to support 2 or 3 platforms with the same code base without bloating your app with duplicate images that are identical apart from the file name.

4) It correctly maps .png image paths to the multi-page HiDPI TIFF files used on Mac OS 10.7+ for combining standard and Retina scale images into a single file.

These behaviours will work with any file, not just images or nibs, so it can be useful if you want to load device-specific versions of nib files, 3D models or shaders for OpenGL applications without writing a lot of branching code. Unlike the other NSFileManager extension methods, this method will return nil if the file does not exist. This method makes multiple filesystem calls, so may be relatively slow the first time it is called for each path, however it caches the result for a given input so the next time it will be faster. See the Image file suffixes section below for more information.

The `ofType:` form of the method takes an optional file extension to use if the file does not already have an extension. Unlike the built-in `[[NSBundle mainBundle] pathForResource:ofType:]` method, the extension will be ignored if the file already has a type.


NSString extension methods
-----------------------------

StandardPaths extends NSString with some additional methods for manipulating file paths by adding, deleting and retrieving the standard and pseudo-standard path extensions used for Retina-resolution images and device-specific resources. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByReplacingPathExtensionWithExtension:(NSString *)extension;
```
    
This method replaces a string path extension with the specified value.
    
```objc
- (BOOL)hasPathExtension;
```
    
This method returns YES if the string has a path extension.

```objc
- (NSString *)stringByAppendingPathSuffix:(NSString *)suffix;
```
    
This method is used to append a suffix to a file path. It is similar to the `stringByAppendingString:` method, but it will automatically ensure that if the string has a file extension that the suffix is inserted before the extension.
    
```objc
- (NSString *)stringByDeletingPathSuffix:(NSString *)suffix;
```
    
This method deletes the specified suffix from the string (if present), without disturbing the file extension.
    
 ```objc
- (BOOL)hasPathSuffix:(NSString *)suffix;
 ```

This method returns YES if the string has the specified suffix. This differs from the `hasSuffix:` method because it strips the file path extension before performing the check.

```objc
- (NSString *)stringByAppendingSuffixForInterfaceIdiom:(UIUserInterfaceIdiom)idiom;
```

This method appends the appropriate suffix string (SPPhoneSuffix, SPPadSuffix or SPDesktopSuffix) for the specified idiom constant to the string. If the string includes a file extension, the suffix is correctly inserted before the file extension. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByAppendingInterfaceIdiomSuffix;
```
    
This method appends the user interface idiom suffix for the current device (~ipad, ~iphone or ~mac) to the string. If the string includes a file extension, the suffix is correctly inserted before the file extension. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByDeletingInterfaceIdiomSuffix;
```
    
This method removes the user interface idiom suffix from the string if present, or does nothing if a suffix is not found.
    
```objc
- (NSString *)interfaceIdiomSuffix;
```
    
This method returns the user interface idiom suffix if found, or @"" if not.

```objc
- (BOOL)hasInterfaceIdiomSuffix;
```
    
This method returns YES if the string has an interface idiom suffix.

```objc
- (UIUserInterfaceIdiom)interfaceIdiomFromSuffix;
```

This method returns the UIUserInterfaceIdiom value specified by a file's interface idiom suffix (if found). If no suffix is found it returns the current device idiom. UIUserInterfaceIdiom is part of UIKit, and isn't defined on Mac OS, so StandardPaths defines these constants if running on Mac OS, and adds an additional UIUserInterfaceIdiomDesktop constant to represent the Mac OS desktop idiom. This implementation is compatible with the one used by the Chameleon iOS-Mac conversion library, so you should be able to use both libraries together.

```objc
- (NSString *)stringByAppendingSuffixForScale:(CGFloat)scale;
```

This method appends a standard scale suffix to the string. So for example if the passed scale value is 2.0 then the method will append @2x to the string. The method correctly handles file extensions and device type suffixes, so the @2x will be inserted before the file extension or device type suffix if present. See the Image file suffixes section below for more information. Passing a value of 0.0 for the scale will use the current device scale.

```objc
- (NSString *)stringByAppendingDeviceScaleSuffix;
```

This method appends the appropriate suffix to the string for the current device scale (at present that means an @2x suffix or @3x suffix for Retina iPhones, or nothing for non-Retina devices). The method correctly handles file extensions and device type suffixes, so the @2x will be inserted before the file extension or device type suffix if present. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByDeletingScaleSuffix;
```

This method removes the @2x (or any other scale factor) suffix from a file path, or does nothing if the suffix is not found.

```objc
- (NSString *)scaleSuffix;
```

This method returns the scale factor suffix if found, or an empty string if not.

```objc
- (BOOL)hasScaleSuffix;
```

Return YES if the string has an @xx scale suffix and NO if not.

```objc
- (NSString *)stringByAppendingSuffixForHeight:(CGFloat)height;
```

This method appends a screen height suffix to the string. So for example if the passed height value is 568 then the method will append -568h to the string. The method correctly handles file extensions and device type suffixes, so the -568h will be inserted before the @2x scale suffix or device type suffix if present. See the Image file suffixes section below for more information. Passing a value of 0.0 for the height will use the current device screen height.

```objc
- (NSString *)stringByAppendingDeviceHeightSuffix;
```

This method appends the appropriate suffix to the string for the current device height (at present that means an @2x suffix if the device has a Retina display, or nothing if it doesn't). The method correctly handles file extensions and device type suffixes, so the @2x will be inserted before the file extension or device type suffix if present. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByDeletingHeightSuffix;
```

This method removes the -568h (or any other height) suffix from a file path, or does nothing if the suffix is not found.

```objc
- (NSString *)heightSuffix;
```

This method returns the scale factor suffix if found, or an empty string if not.

```objc
- (BOOL)hasHeightSuffix;
```

Return YES if the string has an -xxxh height suffix and NO if not.

```objc
- (NSString *)stringByAppendingHDSuffix;
```

This method appends the -hd suffix to the string to indicate a Retina iPhone or large-screen device such as an iPad or Mac. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByAppendingHDSuffixIfDeviceIsHD;
```

This method appends the -hd suffix to the string if the device is a Retina display iPhone or is an iPad or Mac, and does nothing if it isn't. See the Image file suffixes section below for more information.

```objc
- (NSString *)stringByDeletingHDSuffix;
```

This method deletes the -hd suffix from the string if found, or does nothing if the suffix is not found.

```objc
- (BOOL)hasHDSuffix;
```

This method returns YES if the string has an -hd suffix and NO if it doesn't.

```objc
- (CGFloat)scaleFromSuffix;
```

This method returns the image scale value for a file path as a floating point number, e.g. 2.0 if the file includes an -hd suffix (on iPhone only) or @2x/@3x suffix and 1.0 if there is no suffix. It will also correctly parse non-standard scale suffixes such as @1.5x, etc.

```objc
- (CGFloat)heightFromSuffix;
```

This method returns the screen height value for a file path as a floating point number, e.g. 568 if the file includes a -568h suffix (on iPhone only) and 0.0 if there is no suffix. It will also correctly parse non-standard height suffixes such as -667h for the iPhone 6, -736h for the iPhone 6+, etc.


UIKit swizzling
-----------------

By default, StandardPaths swizzles some UIKit and AppKit methods to make some of the pseudo-standards that it implements work more simply and automatically. If you don't want this behaviour then don't panic, you can disable it by adding the following pre-compiler macro to your build settings:

```objc
SP_SWIZZLE_ENABLED=0
```

Or if you prefer, add this to your `prefix.pch` file:

```objc
#define SP_SWIZZLE_ENABLED 0
```

Before you do that though, be reassured that the swizzling that StandardPaths does is minimal and quite safe. It always calls the originally swizzled method and merely acts as a buffer to insert some additional intelligence beforehand. It doesn't break UIImage caching, or cause any other nasty side effects like some solutions out there.

The swizzled methods are as follows:

```objc
[UIImage -initWithContentsOfFile:];
[UIImage +imageNamed:];
[NSImage -initWithContentsOfFile:];
[NSImage +imageNamed:];
```
    
These methods are swizzled to automatically support images with the -hd and -568h suffixes. See the Image file suffixes section for details.

```objc
[NSBundle -loadNibNamed:owner:options:];
[UINib -nibWithNibName:bundle:];
[UIViewController -loadView];
```
    
These methods are all swizzled for the same reason: to automatically load nib files that are suffixed with -568h on an iPhone 5, saving you from having to perform a check at runtime.


Image file suffixes
--------------------

Mac OS and iOS have a clever mechanism for managing multiple versions of assets by using file suffixes. The first iPad introduced the ~ipad suffix for specifying ipad-specific versions of files (e.g. foo~ipad.png). The iPhone 4 introduced the @2x suffix for managing double-resolution images for Retina displays (e.g. foo@2x.png). With the 3rd generation iPad you can combine these to have Retina-quality iPad images (e.g. foo@2x~ipad.png). As of Mac OS 10.7, the same @2x image naming is supported for Retina Macs, although there is also a secondary convention in place on Mac OS, where standard def and @2x images are merged into a single multi-page HiDPI TIFF file. Iphone 6+ introduced @3x Retina, and so on.

This file naming convention is an elegant solution for apps, but is sometimes insufficient for games because, unlike apps, hybrid games often share near-identical interfaces on iPhone, iPad and Mac, with the assets and interface elements simply scaled up, and this means that the standard definition iPad/Mac and the Retina resolution iPhone need to use the same images.

Naming your images with the @2x or @3x suffix works for the Retina iPhone but not the standard def iPad or Mac, and naming them with the ~ipad suffix works for iPad but not iPhone, which forces you to either duplicate identical assets with different filenames, or to write your own file loading logic.

The -hd suffix is a solution introduced by the Cocos2D library to the problem of wanting to use the same 2x graphics for both the iPhone Retina display and the iPad standard definition display by using the same -hd filename suffix for both.

The -568h suffix was introduced with the iPhone 5 to support Default.png launch images which are 568 points high (1136px) instead of the regular 480 points. StandardPaths extends this convention so it can be used for all files. It is typically used for images, and because the iPhone 5 has a Retina display it should be combined with the @2x scale suffix for images so that they are loaded at the correct scale. As with all the other suffixes though, StandardPaths also supports the use of this suffix with other file types such as nibs (the additional @2x part of the suffix is not used for non-image assets). The iPhone 6 and 6+ introduced two new screen sizes, and there may be more in future, so StandardPaths supports any arbitrary size for the height value.

StandardPaths supports this solution by adding some utility methods to NSString for automatically applying this suffix to file paths when using the `normalizedFilePath:` method. Files using the @2x, @3x, ~ipad, -hd and -xxxh conventions (or any combination thereof) are automatically detected and loaded as appropriate. For example, If you pass in an image file called foo.png, StandardPaths will automatically look for foo@2x.png or foo-hd.png on a Retina iPhone, or foo~ipad.png or foo-hd.png on an iPad and will also find things like foo-hd@2x.png if you are using a Retina iPad. For cross-platform consistency, StandardPaths also extends these concepts to Mac OS by introducing a ~mac suffix, and treating Mac the same way as iPad with respect to the -hd suffix. It will also look for multi-page HiDPI TIFF file alternatives as appropriate.

**Note:** By default, StandardPaths also swizzles various UIKit methods to make loading nibs and images with the -hd and -568h suffix as seamless as possible. If you don't want StandardPaths to mess with the behaviour of UIKit classes, just add `SP_SWIZZLE_ENABLED=0` to your project's preprocessor macros in the build settings.


Usage
-----------

As long as you have included the StandardPaths.h file, you can call any of the methods above on any instance of `NSFileManager`. For example, if you wanted to get the path to a file called "Foo.bar" in the cache folder, you could write either of the following:

```objc
NSString *path = [[NSFileManager defaultManager] pathForCacheFile:@"Foo.bar"];
NSString *path = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent:@"Foo.bar"];
```
    
To get a normalized file path within the application bundle, you an use just the file name, e.g.

```objc
NSString *path = [[NSFileManager defaultManager] normalizedPathForFile:@"Foo.png"];
```
    
To get a normalized file path that is not inside the application bundle, either use an absolute file path, or use one of the other methods to first convert the path to an absolute path before normalizing, e.g.

```objc
NSFileManager *manager = [NSFileManager defaultManager];
NSString *path = [manager normalizedPathForFile:[manager publicDataPath:@"Foo.png"]];
```

Note that file lookups outside of the application bundle are not cached (as the files are not changed) so it is more CPU-intensive to use `normalizedPathForFile:` for these files. If you are accessing the same file multiple times, you may wish to cache the path yourself rather than calling the method multiple times.

Unless you have disabled swizzling using the `SP_SWIZZLE_ENABLED` macro, StandardPaths will automatically handle loading of images and nib files with the `-hd` or `-568h` suffixes, so you don't need to do anything special to load these.

If you have disabled swizzling, or you want to manipulate non-file-path strings such as info dictionary keys or nib file names, you can use the NSString extension methods. So for example if you wanted to get the device-specific name of a nib file on iPhone 5 you could use:

```objc
NSString *infoDictionaryKey = @"resourceName";
if ([UIScreen mainScreen].bounds.size.height >= 568)
{
	infoDictionaryKey = [infoDictionaryKey stringByAppendingDeviceHeightSuffix];
}
```

This would then return "resourceName" on an iPhone 4, and "resourceName-568h" on an iPhone 5. The string suffix methods are intelligent about where they insert the suffix, so it's safe to call them in any order.


Release notes
---------------

Version 1.6.6

- Updated for Xcode 9.2

Version 1.6.5

- Fixed compiler errors in Xcode 7.3

Version 1.6.4

- Fixed compiler errors in Xcode 6.3

Version 1.6.3

- Fixed bug with -xxxh suffix not being correctly detected for nib files

Version 1.6.2

- Fixed false positives when checking for -xxxh suffix

Version 1.6.1

- Added better support for iPhone 6 and 6 plus
- Fixed potential crash in nib loading logic

Version 1.6

- Added support for new screen sizes and pixel densities
- Renamed stringByAppendingInterfaceIdiomSuffix to stringByAppendingDeviceInterfaceIdiomSuffix for consistency
- Deprecated methods that were overly specific to iPhone 4/5 hardware

Version 1.5.6

- Now loads Retina images on non-Retina devices if no non-Retina image is supplied

Version 1.5.5

- Now conforms to -Weverything warning level

Version 1.5.4

- Removed some debug code accidentally left in library

Version 1.5.3

- Fixed bug in swizzled initWithImage: method that meant it was never called

Version 1.5.2

- Fixed swizzling crash when using storyboards
- Added Podspec file

Version 1.5.1

- Fixed bug in UIImage swizzling where attempting to load an image name or path that already includes the -568h suffix would fail
- Fixed "No previous prototype for function" error 

Version 1.5

- Fixed some bugs in the normalizedPathForFile: method when extension is omitted
- Added normalizedPathForFile:ofType: method for convenience
- Now swizzles the image loading methods on Mac OS as well as iOS
- Added additional path manipulation methods

Version 1.4.2

- Added fix for rdar://problem/11017158
- Now correctly handles non-integer path scale factors such as @1.5x

Version 1.4.1

- Added suffix logic for files that have a .foo.gz extension in order to improve compatibility with the GLView library.

Version 1.4

- Now includes swizzling of UIKit methods to add automatic support for -hd and -568h suffixes when loading images and nib files (this can be disabled with the SP_SWIZZLE_ENABLED preprocessor macro if desired).
- Updated API to include more string suffix manipulation methods and more sensible naming conventions for the existing methods. Note that some methods have slightly changed their behaviour.
- Fixed a small bug in the normalizedPathForFile: method when loading images on Retina Macs (wrong image was selected).

Version 1.3

- Added support for the iPhone 5 -568h@2x suffix for file paths. Apple currently provides no support for this in UIImage or when loading nib files, but StandardPaths can now detect these files automatically and generate the correct path when needed.

Version 1.2.2

- StandardPaths's NSString extension methods will no longer mangle strings that contain double slashes, such as fully-qualified URLs. Note however that Apple's own path manipulation methods (e.e.g stringByAppendingPathExtension:) will still mangle these strings.

Version 1.2.1

- normalizedPathForFile: method will no longer double-apply the @2x extension in certain cases, causing the wrong file to be loaded.

Version 1.2

- Added `normalizedPathForFile:` method for loading device and resolution-specific file versions based on standard suffixes
- Added NSString category methods for file suffix manipulation
- Added Mac and iOS test projects for normalized path functionality
- Now requires iOS 4 or above

Version 1.1.1

- Added path caching to improve performance when saving lots of files
- Added fallback for when NSTemporaryDirectory() returns nil

Version 1.1

- Added support for new iOS 5.1 mobile backup flag.
- Added convenience methods for creating files within standard directories.
- Offline Data path no longer changes between iOS 5 and iOS 5.0.1 as the inconvenience during the upgrade process outweighs the benefit for users of iOS 5.0 (reduced iCloud usage).

Version 1.0.1

- Fixed offlineDataPath to correctly point to Offline Data subfolder on iOS 5 and earlier as documented.

Version 1.0

- Initial release.
