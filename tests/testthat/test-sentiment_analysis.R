test_that("Sentiment analysis works", {

  # create input / test example
  text <- c(
    "Ik vond de film matig",
    "De acteurs waren niet slecht",
    "Maar het script was allesbehalve goed",
    "Die kende geen spanning",
    "Zoals je van Tarantino verwacht was het plot fantastisch",
    "Gelukkig waren de bioscoopkaarten goedkoop"
  )

  # test main function
  expect_equal(
    dutch_sentiment_analysis(text),
    c(-2, 2, -1, -1, 2, 0.5)
    )

  # test labelled output
  expect_equal(
    dutch_sentiment_analysis(text, output = "label"),
    c("negative", "positive", "negative", "negative", "positive",
      "positive")
  )

  # test get_word_sentiment
  expect_equal(
  get_word_sentiment("goede"), 1
)

})
