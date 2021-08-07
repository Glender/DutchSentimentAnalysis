# Function to reverse the score of negation words (e.g. niet spannend)
rev_score <- function(x) ifelse(x < 0, abs(x), 0 - x )

#' Create bigrams for textual input
#'
#' @param text_df A dataframe
#'
#' @importFrom magrittr %>%
create_bigrams <- function(text_df){

  # create bigrams
  bigrams_tidy <- text_df %>%
    tidytext::unnest_tokens(bigram, text, token="ngrams", n=2) %>%

    # Separate the bigrams
    tidyr::separate(bigram, c("word1", "word"), sep = " ") %>%

    # Only maintain the bigrams with negation words (e.g. not good)
    dplyr::filter(word1 %in% negation_words) %>%

    # get score for each word
    dplyr::inner_join(lexicon, by = "word") %>%

    # Reverse scores
    dplyr::mutate(score = rev_score(score))

  return(bigrams_tidy)
}
