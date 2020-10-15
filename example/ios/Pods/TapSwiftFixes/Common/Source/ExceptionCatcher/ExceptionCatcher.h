//
//  ExceptionCatcher.h
//  TapSwiftFixes
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/**
 void block without arguments.
 */
typedef void (^ArgumentlessBlock)(void);

/**
 Catches Objective-C exception in Swift.

 @param tryBlock Block that may cause an exception.
 @param exception Exception.
 @return Boolean value which determines whether exception did not appear.
 */
extern BOOL catchException(ArgumentlessBlock _Nonnull tryBlock, NSException * _Nullable  __autoreleasing * _Nullable exception);
