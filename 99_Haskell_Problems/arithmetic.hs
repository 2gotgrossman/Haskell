import Data.List.Ordered (union, minus)
-- Problem 31
isPrime :: Integer -> Bool
isPrime n = not $ any (\i -> n `mod` i ==0) nums
  where nums = 2:[i | i <- [3..(n-1)], i `mod` 2 /= 0]

-- Problem 32
myGCD a 0 = a
myGCD a b = gcd b a'
  where a' = a `mod` b

-- Problem 33
coprime a b = myGCD a b == 1

-- Problem 34
totient 1 = 1
totient m = length $ filter (coprime m) [1..m-1]

-- Problem 35
primeFactors n = factors n 2
  where factors 1 _        = []
        factors m d
          | m `mod` d == 0 = d : (factors (m `div` d) d)
          | otherwise            = factors m (d+1)

-- Problem 36
primeFactorsMult :: Int -> [(Int, Int)]
primeFactorsMult n = getMults factors
  where factors = primeFactors n
        getMults [] = []
        getMults (x:xs) = (x, 1 + length (fst split)) : getMults (snd split)
          where split = (span (== x) xs)

-- Problem 37
totient' n = foldl (\prod (p, m) -> prod * (p-1) * p^(m-1))
                 1
                 (primeFactorsMult n)

-- Problem 39
primesRange a b = filter isPrime [a..b]

-- Problem 40
goldbach 4 = (2, 2)
goldbach n = findG 3
  where ps = takeWhile (< n) primes
        findG a | a < n = if a `elem` ps && (n-a) `elem` ps
                             then (a, n-a)
                             else findG (a+2)

-- Problem 41
goldbachRange n m = map goldbach [evenN, evenN+2..m]
  where evenN = n + (n `mod` 2)

goldbachRangeGeq n m max = filter (\(x,_) -> x >= max) $ goldbachRange n m



primes = 2 : ops
    where
    ops = sieve 3 9 ops []                                -- odd primes
    sieve x q ~(p:pt) fs =
        ([x,x+2..q-2] `minus` joinST [[y+s, y+2*s..q] | (s,y) <- fs])
        ++ sieve (q+2) (head pt^2) pt
                   ((++ [(2*p,q)]) [(s,q-rem (q-y) s) | (s,y) <- fs])

joinST (xs:t) = (union xs . joinST . pairs) t
    where
    pairs (xs:ys:t) = union xs ys : pairs t
    pairs t         = t
joinST []     = []

main = do print $ show $ take 100 primes
