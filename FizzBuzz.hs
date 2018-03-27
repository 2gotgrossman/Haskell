main = do
  mapM  putStrLn $ fizzBuzz 30

fizzBuzz :: Int -> [String]
fizzBuzz n = fizzBuzz' 1 []
  where max = n
        fizzBuzz' :: Int -> [String] -> [String]
        fizzBuzz' num xs
          | num >= n          = xs
          | num `mod` 15 == 0 = "FizzBuzz" : fizzBuzz' (num+1) xs
          | num `mod` 5  == 0 = "Buzz" : fizzBuzz' (num+1) xs
          | num `mod` 3  == 0 = "Fizz" : fizzBuzz' (num+1) xs
          | otherwise         = show num : fizzBuzz' (num+1) xs
