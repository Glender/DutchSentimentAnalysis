# count how many letters from the word occur in target
str_counter <- function(word, target) {

  # split the word and the target word
  word_splitted <- stringr::str_split(word, pattern = "", simplify = TRUE)[1,]
  target_splitted <- stringr::str_split(target, pattern = "", simplify = TRUE)[1,]

  # for each mathings character += 1
  count <- 0
  for(i in seq_along(target_splitted)){
    if(identical(word_splitted[i], target_splitted[i])) {
      count <- count + 1
    } else {
      break
    }
  }
  return(count)
}

# count how many letters of a word are in targets
word_target_counter <- function(word, x) {
  nr_letters_match <- purrr::map_dbl(x, ~ str_counter(.x, word))
  names(nr_letters_match) <- x
  return(nr_letters_match)
}

#' Search a similar word in the dictionary
#'
#' @param word Character
#'
#' @importFrom magrittr %>%
search_word <- function(word) {

  # take minimal levenshtein distance
  #str_dist <- vwr::levenshtein.distance(word, lexicon$word)
  str_dist <- stringdist::stringdist(word, lexicon$word, method = "lv")
  names(str_dist) <- lexicon$word
  min_dist <- str_dist[str_dist==min(str_dist)]

  # count how many of the first letters from the word occur in target
  target_names <- names(min_dist)
  word_matches <- word_target_counter(word = word, x = target_names)

  # grab the target word with the best fit
  word_match <- word_matches[word_matches == max(word_matches)][1]
  potential_match <- names(word_match)

  # if the word is a negation word, don't change it
  if(word %in% remove_words){
    new_word <- word
    # if the target has a good similarity score, overwrite the word
  } else if(nchar(word) <= 6 & (unname(word_match) / nchar(word)) > .75){
    new_word <- potential_match
  } else if(nchar(word) >= 7 & (unname(word_match) / nchar(word)) > .45){
    new_word <- potential_match
    # if no match, don't change the word
  } else {
    new_word <- word
  }
  return(new_word)
}

# search for similar words in dictionary
lookup_similar_words <- function(cleaned_string) {
  for(word in seq_along(cleaned_string)){
    cleaned_string[word] <- search_word(cleaned_string[word])
  }
  cleaned_string <- stringr::str_c(cleaned_string, collapse = " ")
  return(cleaned_string)
}
