Version 1.4.1

- Added suffix logic for files that have a .foo.gz extension in order to improve compatibility with the GLView library.

Version 1.4

- Now includes swizzling of UIKit methods to add automatic support for -hd and -568h suffixes when loading images and nib files (this can be disabled with the SP_SWIZZLE_ENABLED preprocessor macro if desired).
- Updated API to include more string suffic manipulation methods and more sensible naming conventions for the existing methods. Note that some methods have slightly changed their behaviour.
- Fixed a small bug in the normalizedPathForFile: method when loading images on Retina Macs (wrong image was selected).

Version 1.3

- Added support for the iPhone 5 -568h@2x suffix for file paths. Apple currently provides no support for this in UIImage or when loading nib files, but StandardPaths can now detect these files automatically and generate the correct path automatically when needed.

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