

# Functional Programming (FP)
You can find these notes at https://tinyurl.com/prog-lang-haskell.

## Why Do I Care about FP?
1. A new perspective on programming
    - Viewing problems from another perspective can lead to new solutions
2. In some ways, it's a safer and more resilient way to program
    - Possibly fewer bugs
    - Effects on other parts of code base are more explicit
3. FP is flowing into other languages and paradigms
    - Python, Java 8, Javascript, MapReduce, Scala, Kotlin, Lisp, etc.
4. Companies are using FP languages!
    - [Facebook](https://code.facebook.com/posts/745068642270222/fighting-spam-with-haskell/), [Tesla](https://www.reddit.com/r/haskell/comments/84r1dp/summer_2018_internship_opportunity_with_tesla_inc/),  and many hedge funds / Wall Street firms use Haskell.
    - Many more use FP

## Goal For Today (time permitting)
1. What is FP? (3:35pm)
2. Haskell 101 (3:55pm)
3. Functional Lists (4:20pm)


# Characteristics of Functional Programming (3:35-3:55pm)
##  1. Pure Functions
1.  No Side Effects
2. Functions having inputs and outputs. That's it
3. Two different functions are equivalent _if and only if_ given the same inputs, they will both produce the same output
```python
# Not Pure:
def sum_of_list1(values: List[int]) -> int:
    total = sum(values)
    return total

# Pure
def sum_of_list2(values: List[int]) -> int:
    total = sum(values)
    values.append(total)    # I'm not Pure!
    return total
```

## 2. Higher Order Functions and Abstraction
1. A function that
    1. Takes one or more functions as arguments
    2. or returns a function as a result
```python
>>> numbers = list(range(20))
>>> numbers
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
>>> def square_me(x: Int) -> Int:
>>>     return x*x
>>> squared_numbers = list(map(square_me, numbers))
>>> squared_numbers
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361]
```
2. If there's a repeated pattern we employ, we can abstract away the details into a higher order function or data structure

## 3. Recursion Mania
1. Get really excited about recursion!!
2. Lists in FP languages are Linked Lists
    - Operations on Linked Lists can be written recursively
3. Issues with stack pressure are relieved with [tail recursion](https://stackoverflow.com/questions/33923/what-is-tail-recursion)
    - We don't care about the intermediate state of many recursive functions.
    - We can drop the context of these intermediate functions from the call stack.
```python
# Not Tail Recursive
def fact_rec(n):
    if (n == 0):
        return 1
    else:
        return n * fact_rec(n-1)

# Tail Recursive (Just not in Python)
def fact_tail(n):
    def fact_helper(n, accumulator):
        if (n==0):
            return 1
        else:
            return fact_helper(n-1, accumulator*n)

    fact_helper(n, 1)
```

## 4. Lazy Evaluation
1. Haskell delays the evaluation of an expression until its value is needed
2. Lazy evaluation is already built into parts of imperative programming languages
    - `if x then y else z`
    - `denom != 0 && num / denom`
3. We also gain the ability to deal with infinite lists
    - We only evaluate the part of the list that we will use
4. The following breaks in Python but the equivalent would work in Haskell
    - But Python 3 Generators are lazy! (Think `map`, `filter`, `range`)

```python
print length([2+1, 3*2, 1/0, 5-4])
x = 1/0
```

## 5. Immutability
1. There are no variables, only values
2. You can't change the value of a list.
3. Leads to new ways to deal with data structures
4. Problems with deep and shallow copies disappear

```python
# NOPE
x = 5
x = x + 5
```

## 6. Strongly Typed
1. You need to declare the types of your variables up front
    - Not necessarily true in Haskell because the Haskell compiler is smart.
    - More accurately: Your types need to make sense
2. The compiler will make sure there are no type conflicts before runtime

# Haskell (3:55-4:20pm)

## Content Shamelessly Borrowed from `Reading Simple Haskell`
- Original content available [here](https://soupi.github.io/rfc/reading_simple_haskell/).
## Try it yourself!
- Try this Haskell REPL here: [Haskell REPL](https://repl.it/site/languages/haskell)

---

## Simple Values and Functions

```hs
-- I'm a comment!
five = 5

-- A function that takes `n` as an input
-- We can infer the type of `n`
increment n = n + 1

six = increment five

seven = increment (increment five)

incAndAdd x y = increment x + increment y
```

---

## Operators

- You can also define operators
    - Think: mathematical operators (addition, subtraction, etc)

```hs
x +- y = (x + x) - (y + y)
six  = (+-) 5 2
six' = 5 +- 2
```

---

## let/where

- We can name part of the computation using `let` or `where`
- `let [<definition>] in <expression>` is an expression and can be used anywhere
- `where` is special syntax

```hs
sumOf3 x y z =
  let temp = x + y
  in temp + z

-- or:
sumOf3 x y z = temp + z
  where temp = x + y

-- `let` and `where` statements attempt to make code more readable
fib n = if n > 1
           then n' + n''
           else 1
  where n'  = fib (n-1)
        n'' = fib (n-2)
```

---

## Defining Types

- Concrete types starts with an uppercase letter
- Use `type` to give a new alias to an existing type. They can be used interchangingly.

```hs
type Nickname = String
```

---

## Type Signatures

- We can give values a type signature using `::`
- Without a type signature, the type would default to `String`

```hs
myNickname :: Nickname
myNickname = "suppi"
```

---

## Defining Complex Types

- We can define our own types using the keyword `data`
- We use `|` to say "alternatively"
- Each option must start with an uppercase letter
- We can also combine other data types to make more complex data types
- Similar to structs in other languages

```hs
data KnownColor -- the new type's name
  = Red         -- One possible value
  | Blue
  | Green

redColor :: KnownColor
redColor = Red


data RGB
  = MkRGB Int Int Int
{-
      ^    ^   ^   ^
      |    |   |   |
      |    |   |   +- This is the blue component
      |    |   |
      |    |   +----- This is the green component
      |    |
      |    +--------- This is the red component
      |
      +------------- This is called the value constructor, or "tag"
-}

magenta :: RGB
magenta = MkRGB 255 0 255

-- Or we can combine them
data Color
  = Red
  | Blue
  | Green
  | RGB Int Int Int

blue :: Color
blue = Blue

magenta :: Color
magenta = RGB 255 0 255
```

---

## The Type of Functions

- We use `->` to denote the type of a function from one type to another type

```hs
increment :: Int -> Int
increment n = n + 1

sum3 :: Int -> Int -> Int -> Int
sum3 x y z = x + y + z

supplyGreenAndBlue :: Int -> Int -> Color
supplyGreenAndBlue = RGB 100
```

---

## Parametric Polymorphism in Type Signatures

```hs
-- I only take concrete `Int` values
identityInt :: Int -> Int
identityInt x = x

five :: Int
five = identityInt 5

-- `a` represents any one type
identity :: a -> a
identity x = x

seven :: Int
seven = identity 7

true :: Bool
true = identity True

```

---


## One More Thing About Functions

- In Haskell functions are first class values
- They can be put in variables, passed and returned from functions, etc
- This is a function that takes two functions and a value, applies the second function to the value and then applies the first function to the result
- AKA function composition

```hs
compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

f . g = compose f g
```

---

## Recursive Types and Data Structures

- A recursive data type is a data definition that refers to itself
- This lets us define even more interesting data structures such as linked lists and trees

```hs
data TreeInts
  = Leaf
  | Node Int TreeInts TreeInts

-- the list [1,2,3]
tree123 :: TreeInts
list123 = Node 5 (Node 1 Leaf Leaf) (Node 10 Leaf Leaf)
```

---

## Case Expression (Pattern Matching)

- Matches from top to bottom

```hs
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- The underscore means that we aren't using that variable in the following expression
myIf :: Bool -> a -> a -> a
myIf True  trueBranch _           = trueBranch
myIf False _          falseBranch = falseBranch

```

---



# Functional Lists! (4:20-4:45pm)
- [Lists: Live Coding](https://repl.it/@2gotgrossman/Prog-Lang-Haskell)
- [Lists: Solutions to Problems](https://repl.it/@2gotgrossman/Prog-Lang-Haskell-Answers)
```hs
data List a
  = Nil
  | a :. (List a)

```
- Let's build up from here!
    1. Length of List
    2. Head and tail
    3. Infinite lists
    4. Product and Sum of list of ints
    5. Higher order functions
    6. Concatenating two lists


# Takes on Today's Spotify IPO
- [Jack Stratton (of Vulfpeck) on Spotify IPO](https://www.youtube.com/watch?v=LB1sTH7bUQ4)
