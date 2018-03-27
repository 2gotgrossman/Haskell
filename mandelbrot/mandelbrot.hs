import Data.Complex
import Control.Parallel.Strategies

reRange, imRange :: (Double, Double)
reRange = (-2, 1)
imRange = (-1,1)

main = do
  --print $ length $ getMandelbrotSets 5000
  print $ show $ (foldl (+) 0) $ getMandSumPar 1000
  --print $ show $ (foldl (+) 0) $ map (foldl (+) 0) $ getMandSumPar 1000

pmap f xs = map f xs `using` parList rdeepseq

getMandSumPar density = pmap ((foldl (+) 0) . applyRePts) linIm
  where applyRePts im = map (\re -> getMandelbrotVal (re:+im)) linRe
        linIm = linSpace imRange density
        linRe = linSpace reRange density

getMandelbrotSetsPar density = pmap applyRePts linIm
  where applyRePts im = map (\re -> getMandelbrotVal (re:+im)) linRe
        linIm = linSpace imRange density
        linRe = linSpace reRange density


getMandelbrotSets density = concatMap applyRePts linIm
  where applyRePts im = map (\re -> getMandelbrotVal (re:+im)) linRe
        linIm = linSpace imRange density
        linRe = linSpace reRange density

filterNaNs = filter hasNaN

hasNaN :: Complex Double -> Bool
hasNaN z = (isNaN $ realPart z) || (isNaN $ imagPart z)

getMandelbrotVal c = composeUntilGeq f 0 2 100
  where f = mandelbrotFunction c

composeUntilGeq :: (Complex Double -> Complex Double) -> Complex Double -> Integer -> Integer -> Integer
composeUntilGeq f z val iters = comp z 0
  where comp z' n
          | n > 100   = n
          | hasNaN z' = n
          | (magnitude z) > 2 = n
          | otherwise = let next = f z'
                         in comp next (n+1)
        {-
          | n > iters            = iters
          | hasNaN z' || magnitude z' >= 2 = iters
          | otherwise             =  let next = f z'
                                      in  next `seq` comp next (n+1)
-}
--composeNTimes :: Complex a => (a -> a) -> a -> Int -> a
composeNTimes f z 0 = z
composeNTimes f z n = next `seq` composeNTimes f next (n-1)
  where next = f z

zero = composeNTimes (mandelbrotFunction (1:+0)) 0 10


mandelbrotFunction :: Complex Double -> Complex Double-> Complex Double
mandelbrotFunction c = \z -> (zSquared z) `zAdd` c

zSquared (r:+im) = (r*r - im*im) :+ (2 * r * im)

zAdd (r1:+m1) (r2:+m2) = (r1 + r2) :+ (m1 + m2)

linSpace :: (Double, Double) -> Integer -> [Double]
linSpace (min, max) numPts = [min + step* (fromIntegral i) | i <- [0..numPts]]
  where step = (max - min) / (fromIntegral numPts)
