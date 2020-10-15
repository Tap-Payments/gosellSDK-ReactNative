//
//  ExceptionCatcher.m
//  TapSwiftFixes
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

@import Foundation.NSException;

#import "ExceptionCatcher.h"

BOOL catchException(ArgumentlessBlock _Nonnull tryBlock, NSException * _Nullable  __autoreleasing * _Nullable exception)
{
    NS_DURING
    
    tryBlock();
    return YES;
    
    NS_HANDLER
    
    if ( exception != nil )
    {
        *exception = localException;
    }
    
    return NO;
    
    NS_ENDHANDLER
}
