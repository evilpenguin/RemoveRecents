/*
 * Tweak: 	AppSwitcherClearRecents
 * Version:	0.3.4
 * Creator: EvilPenguin|
 * 
 * Enjoy :0)
 */

@interface SBDisplayLayout
- (NSDictionary *)plistRepresentation;
@end

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
- (id)applicationWithBundleIdentifier:(id)bundleIdentifier;
- (BOOL) respondsToSelector:(SEL)selector;
@end

@interface SBAppSwitcherBarView
- (id)_iconForDisplayIdentifier:(id)displayIdentifier;
@end

@interface SBAppSliderController
- (NSArray *)applicationList;
- (id)_beginAppListAccess;
@end

@interface SBDisplayItem
@property(readonly, copy, nonatomic) NSString *displayIdentifier;
@end

@interface SBSMSApplication
- (BOOL) isRunning;
@end

