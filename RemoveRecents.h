/*
 * Tweak: 	AppSwitcherClearRecents
 * Version:	0.3.2
 * Creator: EvilPenguin|
 * 
 * Enjoy :0)
 */

@interface SBProcess
- (BOOL)isRunning;
@end

@interface SBApplication
- (id)process;
@end

@interface SBApplicationIcon
- (id)application;
@end

@interface SBIcon
- (id)displayName;
@end

@interface SBIconView
@property(readonly, retain) id icon;
@end

@interface SBApplicationController
+ (id)sharedInstance;
- (id)applicationWithDisplayIdentifier:(id)displayIdentifier;
- (id)applicationsWithBundleIdentifier:(id)bundleIdentifier;
@end

@interface SBAppSwitcherBarView
- (id)_iconForDisplayIdentifier:(id)displayIdentifier;
@end