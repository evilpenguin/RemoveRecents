/*
 * Tweak: 	AppSwitcherClearRecents
 * Version:	0.3.4
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
- (id)applicationWithDisplayIdentifier:(id)displayIdentifier;// iOS 4-7
- (id)applicationsWithBundleIdentifier:(id)bundleIdentifier;// iOS 4-7
- (id)applicationWithBundleIdentifier:(id)bundleIdentifier;// iOS 8+
@end

@interface SBAppSwitcherBarView
- (id)_iconForDisplayIdentifier:(id)displayIdentifier;
@end

@interface SBAppSliderController
- (NSArray *)applicationList;
- (id)_beginAppListAccess;
@end

@interface SBDisplayLayout
- (NSDictionary *)plistRepresentation;
@end
