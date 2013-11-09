/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVWhitelist.h"

NSString* const kCDVDefaultWhitelistRejectionString = @"ERROR whitelist rejection: url='%@'";
NSString* const kCDVDefaultSchemeName = @"cdv-default-scheme";

<<<<<<< HEAD
@interface CDVWhitelist ()

@property (nonatomic, readwrite, strong) NSArray* whitelist;
@property (nonatomic, readwrite, strong) NSDictionary* expandedWhitelists;

- (void)processWhitelist;
=======
@interface CDVWhitelistPattern : NSObject {
    @private
    NSRegularExpression* _scheme;
    NSRegularExpression* _host;
    NSNumber* _port;
    NSRegularExpression* _path;
}

+ (NSString*)regexFromPattern:(NSString*)pattern allowWildcards:(bool)allowWildcards;
- (id)initWithScheme:(NSString*)scheme host:(NSString*)host port:(NSString*)port path:(NSString*)path;
- (bool)matches:(NSURL*)url;

@end

@implementation CDVWhitelistPattern

+ (NSString*)regexFromPattern:(NSString*)pattern allowWildcards:(bool)allowWildcards
{
    NSString* regex = [NSRegularExpression escapedPatternForString:pattern];

    if (allowWildcards) {
        regex = [regex stringByReplacingOccurrencesOfString:@"\\*" withString:@".*"];
    }
    return [NSString stringWithFormat:@"%@$", regex];
}

- (id)initWithScheme:(NSString*)scheme host:(NSString*)host port:(NSString*)port path:(NSString*)path
{
    self = [super init];  // Potentially change "self"
    if (self) {
        if ((scheme == nil) || [scheme isEqualToString:@"*"]) {
            _scheme = nil;
        } else {
            _scheme = [NSRegularExpression regularExpressionWithPattern:[CDVWhitelistPattern regexFromPattern:scheme allowWildcards:NO] options:0 error:nil];
        }
        if ([host isEqualToString:@"*"]) {
            _host = nil;
        } else if ([host hasPrefix:@"*."]) {
            _host = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"([a-z0-9.-]*\\.)?%@", [CDVWhitelistPattern regexFromPattern:[host substringFromIndex:2] allowWildcards:false]] options:0 error:nil];
        } else {
            _host = [NSRegularExpression regularExpressionWithPattern:[CDVWhitelistPattern regexFromPattern:host allowWildcards:NO] options:0 error:nil];
        }
        if ((port == nil) || [port isEqualToString:@"*"]) {
            _port = nil;
        } else {
            _port = [[NSNumber alloc] initWithInteger:[port integerValue]];
        }
        if ((path == nil) || [path isEqualToString:@"/*"]) {
            _path = nil;
        } else {
            _path = [NSRegularExpression regularExpressionWithPattern:[CDVWhitelistPattern regexFromPattern:path allowWildcards:YES] options:0 error:nil];
        }
    }
    return self;
}

- (bool)matches:(NSURL*)url
{
    return (_scheme == nil || [_scheme numberOfMatchesInString:[url scheme] options:NSMatchingAnchored range:NSMakeRange(0, [[url scheme] length])]) &&
           (_host == nil || [_host numberOfMatchesInString:[url host] options:NSMatchingAnchored range:NSMakeRange(0, [[url host] length])]) &&
           (_port == nil || [[url port] isEqualToNumber:_port]) &&
           (_path == nil || [_path numberOfMatchesInString:[url path] options:NSMatchingAnchored range:NSMakeRange(0, [[url path] length])])
    ;
}

@end

@interface CDVWhitelist ()

@property (nonatomic, readwrite, strong) NSMutableArray* whitelist;
@property (nonatomic, readwrite, strong) NSMutableSet* permittedSchemes;

- (void)addWhiteListEntry:(NSString*)pattern;
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c

@end

@implementation CDVWhitelist

<<<<<<< HEAD
@synthesize whitelist, expandedWhitelists, whitelistRejectionFormatString;
=======
@synthesize whitelist, permittedSchemes, whitelistRejectionFormatString;
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c

- (id)initWithArray:(NSArray*)array
{
    self = [super init];
    if (self) {
<<<<<<< HEAD
        self.whitelist = array;
        self.expandedWhitelists = nil;
        self.whitelistRejectionFormatString = kCDVDefaultWhitelistRejectionString;
        [self processWhitelist];
    }

=======
        self.whitelist = [[NSMutableArray alloc] init];
        self.permittedSchemes = [[NSMutableSet alloc] init];
        self.whitelistRejectionFormatString = kCDVDefaultWhitelistRejectionString;

        for (NSString* pattern in array) {
            [self addWhiteListEntry:pattern];
        }
    }
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
    return self;
}

- (BOOL)isIPv4Address:(NSString*)externalHost
{
    // an IPv4 address has 4 octets b.b.b.b where b is a number between 0 and 255.
    // for our purposes, b can also be the wildcard character '*'

    // we could use a regex to solve this problem but then I would have two problems
    // anyways, this is much clearer and maintainable
    NSArray* octets = [externalHost componentsSeparatedByString:@"."];
    NSUInteger num_octets = [octets count];

    // quick check
    if (num_octets != 4) {
        return NO;
    }

    // restrict number parsing to 0-255
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMinimum:[NSNumber numberWithUnsignedInteger:0]];
    [numberFormatter setMaximum:[NSNumber numberWithUnsignedInteger:255]];

    // iterate through each octet, and test for a number between 0-255 or if it equals '*'
    for (NSUInteger i = 0; i < num_octets; ++i) {
        NSString* octet = [octets objectAtIndex:i];

        if ([octet isEqualToString:@"*"]) { // passes - check next octet
            continue;
        } else if ([numberFormatter numberFromString:octet] == nil) { // fails - not a number and not within our range, return
            return NO;
        }
    }

    return YES;
}

<<<<<<< HEAD
- (NSString*)extractHostFromUrlString:(NSString*)url
{
    NSURL* aUrl = [NSURL URLWithString:url];

    if ((aUrl != nil) && ([aUrl scheme] != nil)) { // found scheme
        return [aUrl host];
    } else {
        return url;
    }
}

- (NSString*)extractSchemeFromUrlString:(NSString*)url
{
    NSURL* aUrl = [NSURL URLWithString:url];

    if ((aUrl != nil) && ([aUrl scheme] != nil)) { // found scheme
        return [aUrl scheme];
    } else {
        return kCDVDefaultSchemeName;
    }
}

- (void)processWhitelist
{
    if (self.whitelist == nil) {
        NSLog(@"ERROR: CDVWhitelist was not initialized properly, all urls will be disallowed.");
        return;
    }

    NSMutableDictionary* _expandedWhitelists = [@{kCDVDefaultSchemeName: [NSMutableArray array]} mutableCopy];

    // only allow known TLDs (since Aug 23rd 2011), and two character country codes
    // does not match internationalized domain names with non-ASCII characters
    NSString* tld_match = @"(aero|asia|arpa|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|xxx|[a-z][a-z])";

    // iterate through settings ExternalHosts, check for equality
    for (NSString* externalHost in self.whitelist) {
        NSString* host = [self extractHostFromUrlString:externalHost];
        NSString* scheme = [self extractSchemeFromUrlString:externalHost];

        // check for single wildcard '*', if found set allowAll to YES
        if ([host isEqualToString:@"*"]) {
            [_expandedWhitelists setObject:[NSMutableArray arrayWithObject:host] forKey:scheme];
            continue;
        }

        // if this is the first value for this scheme, create a new entry
        if ([_expandedWhitelists objectForKey:scheme] == nil) {
            [_expandedWhitelists setObject:[NSMutableArray array] forKey:scheme];
        }

        // starts with wildcard match - we make the first '.' optional (so '*.org.apache.cordova' will match 'org.apache.cordova')
        NSString* prefix = @"*.";
        if ([host hasPrefix:prefix]) {
            // replace the first two characters '*.' with our regex
            host = [host stringByReplacingCharactersInRange:NSMakeRange(0, [prefix length]) withString:@"(\\s{0}|*.)"]; // the '*' and '.' will be substituted later
        }

        // ends with wildcard match for TLD
        if (![self isIPv4Address:host] && [host hasSuffix:@".*"]) {
            // replace * with tld_match
            host = [host stringByReplacingCharactersInRange:NSMakeRange([host length] - 1, 1) withString:tld_match];
        }
        // escape periods - since '.' means any character in regex
        host = [host stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
        // wildcard is match 1 or more characters (to make it simple, since we are not doing verification whether the hostname is valid)
        host = [host stringByReplacingOccurrencesOfString:@"*" withString:@".*"];

        [[_expandedWhitelists objectForKey:scheme] addObject:host];
    }

    self.expandedWhitelists = _expandedWhitelists;
=======
- (void)addWhiteListEntry:(NSString*)origin
{
    if (self.whitelist == nil) {
        return;
    }

    if ([origin isEqualToString:@"*"]) {
        NSLog(@"Unlimited access to network resources");
        self.whitelist = nil;
        self.permittedSchemes = nil;
    } else { // specific access
        NSRegularExpression* parts = [NSRegularExpression regularExpressionWithPattern:@"^((\\*|[a-z-]+)://)?(((\\*\\.)?[^*/:]+)|\\*)?(:(\\d+))?(/.*)?" options:0 error:nil];
        NSTextCheckingResult* m = [parts firstMatchInString:origin options:NSMatchingAnchored range:NSMakeRange(0, [origin length])];
        if (m != nil) {
            NSRange r;
            NSString* scheme = nil;
            r = [m rangeAtIndex:2];
            if (r.location != NSNotFound) {
                scheme = [origin substringWithRange:r];
            }

            NSString* host = nil;
            r = [m rangeAtIndex:3];
            if (r.location != NSNotFound) {
                host = [origin substringWithRange:r];
            }

            // Special case for two urls which are allowed to have empty hosts
            if (([scheme isEqualToString:@"file"] || [scheme isEqualToString:@"content"]) && (host == nil)) {
                host = @"*";
            }

            NSString* port = nil;
            r = [m rangeAtIndex:7];
            if (r.location != NSNotFound) {
                port = [origin substringWithRange:r];
            }

            NSString* path = nil;
            r = [m rangeAtIndex:8];
            if (r.location != NSNotFound) {
                path = [origin substringWithRange:r];
            }

            if (scheme == nil) {
                // XXX making it stupid friendly for people who forget to include protocol/SSL
                [self.whitelist addObject:[[CDVWhitelistPattern alloc] initWithScheme:@"http" host:host port:port path:path]];
                [self.whitelist addObject:[[CDVWhitelistPattern alloc] initWithScheme:@"https" host:host port:port path:path]];
            } else {
                [self.whitelist addObject:[[CDVWhitelistPattern alloc] initWithScheme:scheme host:host port:port path:path]];
            }

            if (self.permittedSchemes != nil) {
                if ([scheme isEqualToString:@"*"]) {
                    self.permittedSchemes = nil;
                } else if (scheme != nil) {
                    [self.permittedSchemes addObject:scheme];
                }
            }
        }
    }
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
}

- (BOOL)schemeIsAllowed:(NSString*)scheme
{
    if ([scheme isEqualToString:@"http"] ||
        [scheme isEqualToString:@"https"] ||
        [scheme isEqualToString:@"ftp"] ||
        [scheme isEqualToString:@"ftps"]) {
        return YES;
    }

<<<<<<< HEAD
    return (self.expandedWhitelists != nil) && ([self.expandedWhitelists objectForKey:scheme] != nil);
=======
    return (self.permittedSchemes == nil) || [self.permittedSchemes containsObject:scheme];
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
}

- (BOOL)URLIsAllowed:(NSURL*)url
{
    return [self URLIsAllowed:url logFailure:YES];
}

- (BOOL)URLIsAllowed:(NSURL*)url logFailure:(BOOL)logFailure
{
<<<<<<< HEAD
    NSString* scheme = [url scheme];

    // http[s] and ftp[s] should also validate against the common set in the kCDVDefaultSchemeName list
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"ftp"] || [scheme isEqualToString:@"ftps"]) {
        NSURL* newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", kCDVDefaultSchemeName, [url host]]];
        // If it is allowed, we are done.  If not, continue to check for the actual scheme-specific list
        if ([self URLIsAllowed:newUrl logFailure:NO]) {
            return YES;
        }
    }

    // Check that the scheme is supported
=======
    // Shortcut acceptance: Are all urls whitelisted ("*" in whitelist)?
    if (whitelist == nil) {
        return YES;
    }

    // Shortcut rejection: Check that the scheme is supported
    NSString* scheme = [url scheme];
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
    if (![self schemeIsAllowed:scheme]) {
        if (logFailure) {
            NSLog(@"%@", [self errorStringForURL:url]);
        }
        return NO;
    }

<<<<<<< HEAD
    NSArray* expandedWhitelist = [self.expandedWhitelists objectForKey:scheme];

    // Are we allowing everything for this scheme?
    // TODO: consider just having a static sentinel value for the "allow all" list, so we can use object equality
    if (([expandedWhitelist count] == 1) && [[expandedWhitelist objectAtIndex:0] isEqualToString:@"*"]) {
        return YES;
    }

    // iterate through settings ExternalHosts, check for equality
    NSEnumerator* enumerator = [expandedWhitelist objectEnumerator];
    id regex = nil;
    NSString* urlHost = [url host];

    // if the url host IS found in the whitelist, load it in the app (however UIWebViewNavigationTypeOther kicks it out to Safari)
    // if the url host IS NOT found in the whitelist, we do nothing
    while (regex = [enumerator nextObject]) {
        NSPredicate* regex_test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

        // if wildcard, break out and allow
        if ([regex isEqualToString:@"*"]) {
            return YES;
        }

        if ([regex_test evaluateWithObject:urlHost] == YES) {
            // if it matches at least one rule, return
=======
    // http[s] and ftp[s] should also validate against the common set in the kCDVDefaultSchemeName list
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"] || [scheme isEqualToString:@"ftp"] || [scheme isEqualToString:@"ftps"]) {
        NSURL* newUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", kCDVDefaultSchemeName, [url host], [url path]]];
        // If it is allowed, we are done.  If not, continue to check for the actual scheme-specific list
        if ([self URLIsAllowed:newUrl logFailure:NO]) {
            return YES;
        }
    }

    // Check the url against patterns in the whitelist
    for (CDVWhitelistPattern* p in self.whitelist) {
        if ([p matches:url]) {
>>>>>>> 59781c5491dff2aea89000e7edf15f7365d0f88c
            return YES;
        }
    }

    if (logFailure) {
        NSLog(@"%@", [self errorStringForURL:url]);
    }
    // if we got here, the url host is not in the white-list, do nothing
    return NO;
}

- (NSString*)errorStringForURL:(NSURL*)url
{
    return [NSString stringWithFormat:self.whitelistRejectionFormatString, [url absoluteString]];
}

@end
