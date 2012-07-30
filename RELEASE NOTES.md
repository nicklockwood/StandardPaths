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