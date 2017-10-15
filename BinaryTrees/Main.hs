-- file: ch05/Main.hs
module Main (main) where

import BinaryTree

main = print (isBalanced Leaf (Just 5) (Just 5))
