/*
 * Tweak: 	AppSwitcherClearRecents
 * Version:	0.3
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

