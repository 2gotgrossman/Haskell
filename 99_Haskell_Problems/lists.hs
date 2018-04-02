
myLast [] = error "Can't get last item of empy list"
myLast xs = foldl (const id) 0 xs

-- Prob 22
range m n = range' m
  where range' i | i <= n    = i : range' (i+1)
                 | otherwise = []
