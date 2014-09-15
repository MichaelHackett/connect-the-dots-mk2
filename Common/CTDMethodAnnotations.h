// Declarative annotations for method declarations and definitions.
//
// Copyright 2014 Michael Hackett. All rights reserved.


// Macro for objc_method_family method attribute. (Follows NSObjCRuntime.h
// macro patterns for compiler features not present in all versions or all
// compilers; macro becomes a no-op if not used with a supporting compiler.)
#if __has_attribute(objc_method_family)
#define CTD_METHOD_FAMILY(x) __attribute__((objc_method_family(x)))
#else
#define CTD_METHOD_FAMILY(x)
#endif


// Work-around for Clang behaviour that assumes that all "newXXX" methods that
// do not have a concrete return type will return an instance of the class
// in which the method resides. For some types of factory methods, this may
// not be the case. Tag the declaration of the method (in the header file) to
// avoid the compiler errors. Such methods still have the usual "new" family
// semantics (returning a object with a +1 retain count).
#define CTD_FACTORY_METHOD NS_RETURNS_RETAINED CTD_METHOD_FAMILY(none)


// Use in implementation file, immediately after method signature, to cause
// an exception if the method is received by an instance of the current class.
// Intended to prevent access to a superclass method that isn't appropriate
// for the subclass. Technically, this violates Lizkov Substitution Principle
// (LSP), so use it sparingly, but sometimes it makes sense (e.g., blocking
// parent initializers).

#define CTD_BLOCK_PARENT_METHOD { [self doesNotRecognizeSelector:_cmd]; return nil; }


// Corresponding declaration to put in the interface for a class that has
// blocked the no-arg initializer.

#define CTD_NO_DEFAULT_INIT \
  - (id)init __unavailable; \
  + (id)new __unavailable;
