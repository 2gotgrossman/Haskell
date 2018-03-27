# Monads 

## Monad Class Definition

```
class  Monad m  where
    (>>=)            :: m a -> (a -> m b) -> m b
    (>>)             :: m a -> m b -> m b
    return           :: a -> m a
    fail             :: String -> m a

    m >> k           =  m >>= \_ -> k
```

## Do syntax rules
```
do e1 ; e2        =       e1 >> e2
do p <- e1; e2    =       e1 >>= \p -> e2
```

## Monad Laws
https://wiki.haskell.org/Monad_laws

```
return a >>= k	=	k a
m >>= return	=	m
xs >>= return . f	=	fmap f xs
m >>= (\x -> k x >>= h)	=	(m >>= k) >>= h
```

# List Monad 
## Definition
```
instance Monad [] where  
    return x = [x]  
    xs >>= f = concat (map f xs)  
    fail _ = []

concat :: [[a]] -> [a]
```

## powerset
https://evan-tech.livejournal.com/220036.html

```
powerset :: [a] -> [[a]]
powerset = filterM (const [True, False])

filtermM :: Monad m => (a -> m Bool) -> [a] -> m [a] -- or, concretized with [] for m:
filtermM ::         => (a -> [Bool]) -> [a] -> [[a]]
filterM          :: (Monad m) => (a -> m Bool) -> [a] -> m [a]
filterM _ []     =  return []
filterM p (x:xs) =  do
   flg <- p x
   ys  <- filterM p xs
   return (if flg then x:ys else ys)
```

## List Examples

```
[(x,y) | x <- [1,2,3] , y <- [1,2,3], x /= y]

do x <- [1,2,3]
   y <- [1,2,3]
   True <- return (x /= y)
   return (x,y)

[1,2,3] >>= (\ x -> [1,2,3] >>= (\y -> return (x/=y) >>=
   (\r -> case r of True -> return (x,y)
                    _    -> fail "")))
```

# Why monads?
Modularity. We can hide the underlying machinery.

But wait, didn't we say that monads are just beefed up applicative functors? Shouldn't there be a class constraint in there along the lines of class `(Applicative m) = > Monad m` where so that a type has to be an applicative functor first before it can be made a monad? Well, there should, but when Haskell was made, it hadn't occured to people that applicative functors are a good fit for Haskell so they weren't in there. But rest assured, every monad is an applicative functor, even if the Monad class declaration doesn't say so.

# Maybe Monad 

```
instance Monad Maybe where
    return x = Just x  
    Nothing >>= f = Nothing  
    Just x >>= f  = f x  
    fail _ = Nothing
```

# Non-Determinism
For a list, the idea is that a list is just one value with multiple possible answers.

# Things that don't make sense
```
getVar :: IO String
getVar = do
        x <- getStrLine
```

Should be :
```
getVar = do
          x <- getStrLine
          return x
```
Or: ` getVar = getStrLine`


