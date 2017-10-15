-- file: BinaryTree.hs
module BinaryTree
    (
    Tree (..),
    isBalanced
    ) where

import Data.Maybe

data Tree a = Leaf | Node a (Tree a) (Tree a) deriving (Show, Eq)

isBalanced :: Ord a => Tree a -> Bool
isBalanced a = isBalancedHelper a Nothing Nothing

isBalancedHelper :: Ord a => Tree a -> Maybe a -> Maybe a -> Bool
isBalancedHelper Leaf _ _ = True
isBalancedHelper (Node a l r) mini maxi = lowerCheck && upperCheck
                                    && (isBalancedHelper l mini (Just a))
                                    && (isBalancedHelper r (Just a) maxi)
                                    where lowerCheck = maybe True (a >=) mini
                                          upperCheck = maybe True (a <) maxi

isSameTree :: Eq a => Tree a -> Tree a -> Bool
isSameTree Leaf Leaf = True
isSameTree (Node a1 l1 r1) (Node a2 l2 r2) = (a1 == a2) && (isSameTree l1 l2)
                                              && (isSameTree r1 r2)
isSameTree _ _ = False
-- 
-- toList :: Tree a -> b
-- toList Leaf = []
-- toList (Node a l r) = a : (toList l) : (toList r)
