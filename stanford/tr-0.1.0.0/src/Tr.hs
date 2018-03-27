-- | Haskell tr implementation. Just supports the swap and delete modes:
-- * tr string1 string2
-- * tr -d string1
--
-- PLEASE DON'T CHANGE THE INTERFACE OF THIS FILE AS WE WILL EXPECT IT TO BE
-- THE SAME WHEN TESTING!
module Tr
    ( CharSet
    , tr
    ) where

-- | Just to give `tr` a more descriptive type
type CharSet = String

-- | 'tr' - the characters in the first argument are translated into characters
-- in the second argument, where first character in the first CharSet is mapped
-- to the first character in the second CharSet. If the first CharSet is longer
-- than the second CharSet, the last character found in the second CharSet is
-- duplicated until it matches in length.
--
-- If the second CharSet is a `Nothing` value, then 'tr' should run in delete
-- mode where any characters in the input string that match in the first
-- CharSet should be removed.
--
-- The third argument is the string to be translated (i.e., STDIN) and the
-- return type is the output / translated-string (i.e., STDOUT).
--
-- translate mode: tr "eo" (Just "oe") "hello" -> "holle"
-- delete mode: tr "e" Nothing "hello" -> "hllo"
--
-- It's up to you how to handle the first argument being the empty string, or
-- the second argument being `Just ""`, we will not be testing this edge case.
tr :: CharSet -> Maybe CharSet -> String -> String
tr _inset Nothing xs = deleteChars _inset xs
tr _inset (Just _outset) xs = translateChars (fst tup) (snd tup) xs
  where tup = standardizeTranslation _inset _outset
--  | otherwise          = translateChars (fst tup) (snd tup) xs
--                            where tup = standardizeTranslation _inset (fromJust _outset)

standardizeTranslation :: CharSet -> CharSet -> (CharSet, CharSet)
standardizeTranslation _inset _outset
  | length _inset  < length _outset = (_inset, take (length _inset) _outset)
  | length _inset > length _outset = (_inset, _outset ++ take (length _inset - length _outset) (repeat $ last _outset))
  | otherwise = (_inset, _outset)

deleteChars :: CharSet -> String -> String
deleteChars _inset (x:xs)
  | x `elem` _inset = deleteChars _inset xs
  | otherwise     = x : deleteChars _inset xs
deleteChars _ _ = []

translateChars :: CharSet -> CharSet -> String -> String
translateChars from to (x:xs)
  | x `elem` from = (to !! elemIndex x from) : translateChars from to xs
  | otherwise   = x : translateChars from to xs
translateChars _ _ _ = []

-- UNSAFE: Assumes
elemIndex :: Eq a => a -> [a] -> Int
elemIndex elem xs = let helper elem (x:xs) index | elem == x = index
                                                 | otherwise = helper elem xs (index + 1)
                     in helper elem xs 0

fromJust :: Maybe a -> a
fromJust (Just a) = a

