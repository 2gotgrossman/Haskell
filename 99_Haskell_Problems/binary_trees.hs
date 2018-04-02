data Tree a = Empty | Branch a (Tree a) (Tree a)
              deriving (Show, Eq)


leaf x = Branch x Empty Empty


-- Problem 55
cbalTree :: Int -> [Tree Char]
cbalTree 0 = [Empty]
cbalTree n = let (q, r) = (n - 1) `quotRem` 2
    in [Branch 'x' left right | i     <- [q .. q + r],
                                left  <- cbalTree i,
                                right <- cbalTree (n - i - 1)]


-- Problem 56
symmetric Empty          = True
symmetric (Branch a l r) = mirror l r

mirror :: Tree a -> Tree a -> Bool
mirror Empty Empty      = True
mirror (Branch x l1 r1)
       (Branch y l2 r2) = mirror l1 r2 && mirror l2 r1
mirror _ _              = False


-- Problem 57
constructBST :: Ord a => [a] -> Tree a
constructBST xs = foldl insertElem Empty xs
  where insertElem :: Ord a => Tree a -> a -> Tree a
        insertElem Empty             elem = leaf elem
        insertElem (Branch curr l r) elem = if elem < curr
                                             then Branch curr (insertElem l elem) r
                                             else Branch curr l (insertElem r elem)

-- Problem 58
symCbalTrees n = filter symmetric $ cbalTree n

-- Problem 59
hbalTree _   0 = [Empty]
hbalTree val 1 = [Branch val Empty Empty]
hbalTree val n = b1 ++ b2 ++ b3
  where b1 = [Branch val l r | l <- subN, r <- subNMinus1]
        b2 = [Branch val l r | l <- subN, r <- subN]
        b3 = [Branch val l r | l <- subNMinus1, r <- subN]
        subN = hbalTree val (n-1)
        subNMinus1 = hbalTree val (n-2)

-- Problem 60
-- Note: maxN = 2**H - 1
maxHeightOfBalancedTree n = ceiling $ logBase 2 n
--TODO


-- Problem 61
isLeaf (Branch _ Empty Empty) = True
isLeaf _                      = False

countLeaves Empty = 0
countLeaves tr@(Branch a l r) | isLeaf tr = 1
                              | otherwise = (countLeaves l) + (countLeaves r)

-- Problem 61A
collectLeaves Empty = []
collectLeaves (Branch a Empty Empty) = [a]
collectLeaves (Branch a l     r)     = collectLeaves l ++ collectLeaves r

-- Problem 62
collectInternalBranches Empty                  = []
collectInternalBranches (Branch a Empty Empty) = []
collectInternalBranches (Branch a l     r    ) = a : collectInternalBranches l ++ collectInternalBranches r

-- Problem 62B
atLevel (Branch a _ _        ) 1 = [a]
atLevel (Branch _ Empty Empty) n = []
atLevel (Branch a l     r    ) n = atLevel l (n-1) ++ atLevel r (n-1)
atLevel Empty                  _ = []

-- Problem 63
completeBinaryTree 0 = Empty
completeBinaryTree n = Branch 'x' left right
  where n' = (n - 1) `div` 2
        nMod = (n-1) `mod` 2
        left = completeBinaryTree (n' + nMod)
        right = completeBinaryTree n'

--isCompleteBinaryTree tr =
