
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Dutch Sentiment Analysis

[![](https://img.shields.io/badge/devel%20version-0.0.0.9000-purple.svg)](https://github.com/Glender/DutchSentimentAnalysis)
[![CodeFactor](https://www.codefactor.io/repository/github/rossellhayes/ipa/badge)](https://www.codefactor.io/repository/github/rossellhayes/ipa)
[![](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html#maturing)
[![R build
status](https://github.com/rossellhayes/ipa/workflows/R-CMD-check/badge.svg)](https://github.com/rossellhayes/ipa/actions)
[![](https://codecov.io/gh/rcannood/princurve/branch/main/graph/badge.svg)](https://codecov.io/gh/rcannood/princurve)
[![](https://img.shields.io/github/languages/code-size/Glender/DutchSentimentAnalysis.svg)](https://github.com/Glender/DutchSentimentAnalysis)

Unfortunately there aren’t many R-packages that implement sentiment
analysis for the dutch language. The DutchSentimentAnalysis package
fills this void. It is easily installable via Github and provides easy
to use functions, exemplary data, and comprehensive documentation.

The sentiment analyses are performed by a classification algorithm that
uses a dutch sentiment dictionary to quantify attitudes and opinions.
The sentiment dictionary contains 5190 words that are classified on a
scale from -2 to 2, where positive/negative scores indicate
positive/negative emotional value.

The emotional classification algorithm evaluates the similarity between
textual input and words occuring in the dictionary and rates text on
sentimental value. It intelligently takes negation into account (e.g.
‘niet goed’) and has high predictive validity.

## :writing\_hand: Author

Name: Glenn Hiemstra

Email: <Glenn.Hiemstra@gmail.com>

<https://github.com/glender>

## :arrow\_double\_down: Installation

``` r
# Install the cutting edge development version from GitHub:
# install.packages("devtools")
devtools::install_github("Glender/DutchSentimentAnalysis")
```

## :book: Usage

``` r
library(DutchSentimentAnalysis)
#> Emotions do not lie
library(tibble)

# create vector with character data
text <- c(
 "Ik vond de film matig",
 "De acteurs waren niet slecht",
 "Maar het script was allesbehalve goed",
 "Die kende geen spanning",
 "Zoals je van Tarantino verwacht was het plot fantastisch",
 "Gelukkig waren de bioscoopkaarten goedkoop"
)

# use the function
dutch_sentiment_analysis(text)
#> [1] -2.0  2.0 -1.0 -1.0  2.0  0.5

# or put the results in a dataframe
tibble(
 lines = text,
 scores = dutch_sentiment_analysis(text),
 label = dutch_sentiment_analysis(text, output = "label")
)
#> # A tibble: 6 x 3
#>   lines                                                    scores label   
#>   <chr>                                                     <dbl> <chr>   
#> 1 Ik vond de film matig                                      -2   negative
#> 2 De acteurs waren niet slecht                                2   positive
#> 3 Maar het script was allesbehalve goed                      -1   negative
#> 4 Die kende geen spanning                                    -1   negative
#> 5 Zoals je van Tarantino verwacht was het plot fantastisch    2   positive
#> 6 Gelukkig waren de bioscoopkaarten goedkoop                  0.5 positive
```

## :floppy\_disk: Data

If you want to find the sentiment scores of a single word, you can do
the following:

``` r
# write some words that you want to lookup
words <- c("goed", "slecht", "lekker")
get_word_sentiment(words)
#> [1]  1 -2  2

# You can also consult the dictionary itself with:
tail(dutch_sentiment_dictionary)
#> # A tibble: 6 x 2
#>   word       score
#>   <chr>      <dbl>
#> 1 zwijnepan     -2
#> 2 zwijnestal    -2
#> 3 zwijnezooi    -2
#> 4 zwijnjak      -2
#> 5 zwijntje      -1
#> 6 zwoegen        1
```

## :telescope: Validation

To illustrate that the dutch sentiment analysis enjoys strong predictive
validity, we show that sentiment scores correlate strongly with related
measurements. For that purpose we analyze a dataset containing product
reviews of earphones. Besides the users opinion of the earphones,
reviewers also provided their feedback in the form of a 5-star rating.
If our sentiment analysis has predictive value, the scores of the
sentiment analysis on the product review should correlate with the
results of the 5-star rating. Let’s find out.

``` r
# look at the data
head(product_reviews)
#> # A tibble: 6 x 2
#>   Star_rating Product_review                                                    
#>         <dbl> <chr>                                                             
#> 1           1 Doordat het artikel zo slecht verpakt wordt komt het product kapo…
#> 2           4 Prima om te gamen en ook je omgeving goed te verstaan. Microfoon …
#> 3           1 Een en al kansloos. Ontzettend slechte kwaliteit, bijna niks te h…
#> 4           5 Het geluid van het oortje werkt perfect de microfoon werkt heel g…
#> 5           1 toen ik de jack in de controller ingeplaatst, ik hebt niks gehoor…
#> 6           5 Ik heb dit oortje nu alweer bijna een jaar. Ik heb prima geluid e…

# compute sentiment scores
sentiment_scores <- dutch_sentiment_analysis(product_reviews$Product_review)

# test predictive validity
cor.test(sentiment_scores, product_reviews$Star_rating)
#> 
#>  Pearson's product-moment correlation
#> 
#> data:  sentiment_scores and product_reviews$Star_rating
#> t = 7.0098, df = 37, p-value = 2.751e-08
#> alternative hypothesis: true correlation is not equal to 0
#> 95 percent confidence interval:
#>  0.5773493 0.8647299
#> sample estimates:
#>       cor 
#> 0.7552816

# or get the estimates with a lineair model
model <- lm(product_reviews$Star_rating ~ sentiment_scores)
summary(model$coefficients)
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#>   1.060   1.540   2.020   2.020   2.499   2.979
```

These results show the strong predictive validity (r = .8, p \< .0001)
of the dutch sentiment analyses. On average, for each unit increase in
sentiment scores of the users product review, the scores of the 5-star
rating also increase by one. This is sufficient evidence that the
emotional classification algorithm works.

## :speech\_balloon: Help

The documentation of all functions can be accessed by `?<function-name>`
or navigate via the package documentation help page
`?DutchSentimentAnalysis` or `help("DutchSentimentAnalysis")`.

    # For example:
    ?dutch_sentiment_analysis
    help("DutchSentimentAnalysis")
