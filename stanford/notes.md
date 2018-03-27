## Haskell is pure
1. Immutable: Can only bind a symbol once in a given scope
2. Order-independent: Order of bindings in source code does not matter
3. Lazy: Definitions of symbols are evaluated on when needed
4. Recursive: A bound symbol is in scope within its own definition

## Recursion
1. We use recursion to "re-bind" argument symbols in new scope instead of reassigning a value to the same variable.
2. Tail recursion: Need to use an accumulator variable.

```
factorial1 n = if n > 1 then n * factorial (n-1) else 1
```

Due to laziness, `n` is evaluated after `factorial (n-1)` is evaluated. So our stack still grows linearly.

```
factorial2 n = let loop acc n' = if n' > 1
                                then loop (acc * n') (n' - 1)
                                else acc
              in loop 1 n
```

`factorial2` is tail recursive.

## Lazy Evaluation
1. Expressions can be represented as a graph. A function corresponds to a reduction rule. 
2. Redex: Any subgraph that matches a reduction rule is called a reducible expression
3. Normal Form: A graph that has no redexes
4. Constructors (like `Just`, `:`, and `[]`) also give rise to normal forms, since they cannot be reduced.
5. Weak Head Normal Form (WHNF): Any graph whose topmost node is a constructor.
6. Unevaluated Expression (AKA Thunk): A graph that is not in WHNF.
7. In Haskell, function arguments are only evaluated from left to right until their topmost nodes are constructors that match the "needs" of the output.

#### Time Complexity
Lazy evaluation never performs more evaluation steps than eager evaluation.

#### Space Complexity
There can be space leaks if you aren't careful (for example, large lists can be copied unecessarily).

```seq :: a -> b -> b```
`seq` evaluates `a` and then just returns `b`. `seq`, therefore, forces evaluation.

I don't completely understand when Tail Recursion is invoked and when it is not.

## Types
``` data Type val1 val2 = Constructor1 val1 
                        | Constructor2 val2
                        | Constructor3
                        deriving (Show, Read)
```

`reads` parses a string into a certain type/pattern.
```
*Main> reads "Point 1 2 and some extra stuff" :: [(Point, String)]
[(Point 1.0 2.0," and some extra stuff")]
```

I don't completely understand how `reads` parses. TODO: Look up use in haskell.org/hoogle/

## Function Composition


```
(.) :: (b -> c) -> (a -> b) -> a -> c
(f . g) x = f ( g x)
```

## Lambda Abstractions
1. Anonymous functions
2. Can deconstruct values with patterns, can take multiple arguments.

## infixr 0 operators
```($) :: (a -> b) -> a -> b```
1. Applies the function. However, since it has such low precedence, it is a way of avoiding parentheses.
`$!` combines `$` and `seq`
2. ```f $! x = x `seq` f x
```

## Forcing eagerness and avoiding thunks
1. We can force the evaluation of thunks by using `$!` or `seq`.
2. When GHC is optimizing, it will usually avoid such thunks. However, we can take control of the process ourselves

## do notation
1. A do block lets you sequence IO actions. In a do block:
2. `pat <- action` - binds pat (variable or constructor pattern) to result of executing action
3. `let pat = pure-value` - binds pat to pure-value (no “in …” required)
4. `action` - executes action and discards the result, or returns it if at end of block
5. Every action in an `IO` block must have type `IO a`
6. `return` function gives any `IO` action a returning value.
      - `return :: a -> IO a`

## Ad-Hoc Polymorphism
1. Does different things on different types
2. Ad-hoc polymorphic functions are called methods and declared with classes
3. The actual method for each type is defined in an instance declaration


``` 
class MyShow a where
    myShow :: a -> String
data Point = Point Double Double
instance MyShow Point where
    myShow (Point x y) = "(" ++ show x ++ ", " ++ show y ++ ")"
```

1. Type declarations can contain restrictions on type variables
2. Restrictions expressed with `(class type-var, …) =>` at start of type

## The Dreaded Monomorphism Restriction
1. I don't get it TODO
2. I think it's basically how Haskell distinguishes between values and functions
3. You can get around a lot of issues if you add type signatures.

## Superclasses
```
class Eq a => Ord a where
    (<), (>=), (>), (<=) :: a -> a -> Bool
    a <= b = a == b || a < b -- default methods can use superclasses
    ....
```
Instances can also "inherit" from a superclass instance

## Functors
1. A class for parameterized types onto which you can map functions
```
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```

Parameterized types are sometimes called type constructors.

## Monad class
```
class Monad m where
    (>>=) :: m a -> (a -> m b) -> m b
    return :: a -> m a
    fail :: String -> m a   -- called when pattern binding fails
    fail s = error s        -- default is to throw exception

    (>>) :: m a -> m b -> m b
    m >> k = m >>= \_ -> k
```
For example, the Maybe class is a monad.

```
instance  Monad Maybe  where
    (Just x) >>= k = k x
    Nothing >>= _  = Nothing
    return = Just
    fail _ = Nothing
```

## Field labels for Types
You can label each field of a parameter in a type constructor.
```
data Type = Constructor {
  field1 :: Type1,
  field2 :: Type2,
  ...
}
```
To initialize: ``` varName = Constructor { field1 = val1, field2, val2 }
```
Automatically, you can now access `val1` with the following expression: `field1 varName`. Get-functions are already defined for types with fields. Note though, that therefore the field names must be unique.

## Miscellaneous
1. A `!` before a data field type makes it strict, meaning it can't be a thunk.


# Exceptions

## Exceptions in Pure Code
```error :: String -> a```

`Control.Exception` throws language-level exceptions.
```
class Exception e where
    throw :: Exception e => e -> a
    throwIO :: Exception e => e -> IO a
    catch :: Exception e => IO a -> (e -> IO a) -> IO a
```

1. Can only `catch` exceptions in IO, but can `throw` exceptions in pure code. 
2. try returns Right a normally, Left e if an exception occurred
```
try :: Exception e => IO a -> IO (Either e a)
```
3. `finally` and `onException`
```
finally :: IO a -> IO b -> IO a      -- cleanup always
onException :: IO a -> IO b -> IO a  -- after exception
```

## Exceptions and laziness
1. Exceptions only occur when thunks are evaluated. For example, `let x = 1/0 : 1/0` will not return an error until an element in the list is evaluated.
2. Even `seq x 5 where x = (div 1 0 : div 1 0` will not throw an error. 
3. If you want to evaluate all thunks in a nested data type, use `deepseq` in `Control.DeepSeq`

# Haskell Threads
1. User level threads implemented in `Control.Concurrent`
      - Lightweight (both time and space)
      - Use threads where in other languages you'd use something cheaper
      - Runtime emulates blocking OS calls 
2. `forkIO` creates a new thread
`forkIO :: IO () -> IO ThreadId`

## MVar
1. Allows for communication between threads via shared variables
2. `Mvar t` is a mutable variable of type t that is either full or empty
```
newEmptyMVar :: IO (MVar a)  -- create empty MVar
newMVar :: a -> IO (MVar a)  -- create full MVar given val

takeMVar :: MVar a -> IO a
putMVar :: MVar a -> a -> IO ()
tryTakeMVar :: MVar a -> IO (Maybe a) -- Nothing if empty
tryPutMVar :: MVar a -> a -> IO Bool  -- False if full
```
3. `takeMVar` and `putMVar` will put threads to sleep if `MVar` is empty or full, respectively.

## Benchmarking Library: `Criterion`

## OS Threads
1. By default, all Haskell threads run in a single OS thread
2. Link a module with `-threaded` to allow OS threads as well (uses `pthread_create`
3. `forkOS` creates a Haskell thread bound to a new OS thread
`forkOS :: IO () -> IO ThreadId`
4. Haskell threads bound to OS threads are much slower than Haskell threads in the same OS thread
5. Without `-threaded`, thread switches is just a procedure call
6. With `-threaded`, bound Haskell threads are in a particular OS thread whereas unbound Haskell thread share and can migrate between OS threads. 
7. Unbound threads have similar performance to threads without `-threaded`

### So why use OS threads if they are slower?
1. If an unbound thread blocks, it can block a whole program
