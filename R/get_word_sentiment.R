#' Lookup the sentimental value of a word in the dictionary
#'
#' Use this function to get the sentiment of a word in the dutch sentiment dictionary.
#'
#' @param words Character
#' @export
#' @examples
#'words <- c("goed", "slecht", "lekker")
#'get_word_sentiment(words)
get_word_sentiment <- function(words){
  # search for similar words in dictionary
  words <- unname(sapply(words, lookup_similar_words))

  # get score and return the
  scores <- as.vector(lexicon$score)
  names(scores) <- lexicon$word
  return(unname(scores[words]))
}
