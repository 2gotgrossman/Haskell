
-- 1.
myLast :: [a] -> a
myLast [] = error "Empty list has no last element"
myLast [x] = x
myLast (_:xs) = myLast xs

-- 2. Penultimate element: NOT SAFE
myButLast :: [a] -> a
myButLast [x, _] = x
myButLast (_:xs) = myButLast xs
myButLast _ = error "Empty list or singleton"

-- 3.
elementat :: [a] -> Int -> a
elementat (x:_) 1 = x
elementat (_:xs) n
    | n < 1 = error "Cannot find the nth negative number"
    | otherwise = elementat xs ( n-1)
elementat [] _ = error "Index out of bound type exception"

-- 4.
myLength :: [a] -> Int
myLength (_:xs) = (myLength xs) + 1
myLength [] = 0

-- 5.
myReverse :: [a] -> [a]
myReverse (x:xs) = (myReverse xs) ++ [x]
myReverse [] = []

-- 6.
isPalandrome :: Eq a => [a] -> Bool
isPalandrome xs = xs == (myReverse xs)


-- 7. Flatten a NestedList into a list
data NestedList a = Elem a | List [NestedList a]

flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List x) = flattenList x where
                              flattenList (x:xs) = flatten x ++ flattenList xs
                              flattenList _ = []

-- 8. Remove duplicates from a list
compress :: Eq a => [a] -> [a]
compress (x:y:xs)
      | x == y    = compress(x : xs)
      | otherwise = x : compress (y : xs)
compress (xs) = xs

-- 9. Group equal elements into sub-lists
pack :: Eq a => [a] -> [[a]]
pack [] = []
pack (x:xs) = (x: takeWhile (==x) xs) : pack (dropWhile (==x) xs)

-- 10. Group equal characters
encode :: Eq a => [a] -> [(Int, a)]
encode [] = []
encode a = wrap (pack a)
              where
                wrap (x:xs) = (length x, head x) : wrap xs
                wrap [] = []

-- 11. Modify the result of problem 10 in such a way that if an element has no
-- duplicates it is simply copied into the result list. Only elements with
-- duplicates are transferred as (N E) lists.
--  > encodeModified "aaaabccaadeeee"
-- [Multiple 4 'a',Single 'b',Multiple 2 'c',
--  Multiple 2 'a',Single 'd',Multiple 4 'e']
data Encoding a = Multiple Int a | Single a deriving (Show)

encodeModified :: Eq a => [a] -> [Encoding a]
encodeModified [] = []
encodeModified a = wrap (pack a) where
            wrap (x:xs) = (if (length x) > 1 then (Multiple (length x) (head x))
                                    else (Single (head x) )) : wrap xs
            wrap [] = []

-- 12. Decode encodeModified
decodeModified :: Eq a => [Encoding a] -> [a]
decodeModified ((Single a) : xs)      = a : decodeModified xs
decodeModified ((Multiple a b) : xs)  = (replicate a b) ++ decodeModified xs
decodeModified [] = []

-- 13. Don't use pack. Encode directly
-- encodeDirect :: Eq a => [a]  -> [Encoding a]


-- 14.
dupli :: [a] -> [a]
dupli (x : xs) = x : x : dupli xs
dupli [] = []

-- 15.
repli :: [a] -> Int -> [a]
repli (x:xs) i = (dup x i) ++ (repli xs i)
                  where dup x i = replicate i x
repli [] _ = []

-- 16. Drop every nth element in a list.
dropEvery :: [a] -> Int -> [a]
dropEvery x n = dropHelper x n
                    where dropHelper (x:xs) 1    = dropHelper xs n
                          dropHelper (x:xs) curr = x : dropHelper xs (curr-1)
                          dropHelper _ _         = []

-- 17. Split a list into two parts
split :: [a] -> Int -> [[a]]
split [] _ = []
split x n = [(take n x), (drop n x)]

-- 18. Slice
slice :: [a] -> Int -> Int -> [a]
slice xs i k = [x | (x, j) <- zip xs [1..k], i <= j] -- List Comprehensions!!

-- 19. Rotate
rotate :: [a] -> Int -> [a]
rotate x n
      | n' >=0     = drop n' x ++ take n' x
      | otherwise  = drop diff x ++ take diff x
      where n' = n `mod` (length x)
            diff = (length x) - n'

-- 20.
removeAt :: Int -> [a] -> (a, [a])
removeAt 1 (x:xs) = (x, xs)
removeAt n (x:xs) = (l, x:r)
        where (l, r) = removeAt (n-1) xs

-- 21.
insertAt :: a -> [a] -> Int -> [a]
insertAt el (x:xs) 1 = x : el : xs
insertAt el (x:xs) n = x : insertAt el xs (n-1)

-- 22. Range
range :: Int -> Int -> [Int]
range a b
      | a <= b    = a : range (a+1) b
      | otherwise = []

-- 23. rnd_select
-- 24. diff_select
-- 25. rnd_permu

-- 26. combinations
combinations :: Int -> [a] -> [[a]]
combinations 0 xs = [[x] | x <- xs]
combinations n (xs) = [map (++x) (x, xs) = [map removeAt i, 
