# Write vector with negation words
negation_words <- c("niet", "geen", "zonder", "nooit", "allesbehalve")

# Remove stopwords from sentence (e.g. hij, ik, onder, ja, eens, hier etc.)
stop_words <- c(
  "de", "en", "van", "ik", "te", "dat", "die", "in", "een", "hij",
  "het", "niet", "zijn", "is", "was", "op", "aan", "met", "als",
  "voor", "had", "er", "maar", "om", "hem", "dan", "zou", "of",
  "wat", "mijn", "men", "dit", "zo", "door", "over", "ze", "zich",
  "bij", "ook", "tot", "je", "mij", "uit", "der", "daar", "haar",
  "naar", "heb", "hoe", "heeft", "hebben", "deze", "u", "want",
  "nog", "zal", "me", "zij", "nu", "ge", "geen", "omdat", "iets",
  "worden", "toch", "al", "waren", "veel", "meer", "doen", "toen",
  "moet", "ben", "zonder", "kan", "hun", "dus", "alles", "onder",
  "ja", "eens", "hier", "wie", "werd", "altijd", "doch", "wordt",
  "wezen", "kunnen", "ons", "zelf", "tegen", "na", "reeds", "wil",
  "kon", "niets", "uw", "iemand", "geweest", "andere"
)

# Put stop words and negation words in one vector
remove_words <- c(
  "de", "en", "van", "ik", "te", "dat", "die", "in", "een", "hij",
  "het", "niet", "zijn", "is", "was", "op", "aan", "met", "als",
  "voor", "had", "er", "maar", "om", "hem", "dan", "zou", "of",
  "wat", "mijn", "men", "dit", "zo", "door", "over", "ze", "zich",
  "bij", "ook", "tot", "je", "mij", "uit", "der", "daar", "haar",
  "naar", "heb", "hoe", "heeft", "hebben", "deze", "u", "want",
  "nog", "zal", "me", "zij", "nu", "ge", "geen", "omdat", "iets",
  "worden", "toch", "al", "waren", "veel", "meer", "doen", "toen",
  "moet", "ben", "zonder", "kan", "hun", "dus", "alles", "onder",
  "ja", "eens", "hier", "wie", "werd", "altijd", "doch", "wordt",
  "wezen", "kunnen", "ons", "zelf", "tegen", "na", "reeds", "wil",
  "kon", "niets", "uw", "iemand", "geweest", "andere", "nooit",
  "allesbehalve"
)

#' @importFrom magrittr %>%
get_sentiment <- function(character_vector){

  # Clean string and move character to lowercase
  cleaned_string <- character_vector %>%
    stringr::str_to_lower() %>%
    stringr::str_extract_all("[:alpha:]+") %>%
    unlist()

  # search for similar words in dictionary
  cleaned_string <- lookup_similar_words(cleaned_string)

  # Convert to dataframe
  text_df <- tibble::tibble(
    line = seq_along(cleaned_string),
    text = cleaned_string
  )

  # create data in tidytext format and get sentiment for each word
  tidy_text <- text_df %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::inner_join(lexicon, by = "word")

  # get bigrams
  bigrams_tidy <- create_bigrams(text_df)

  # Merge the tidy dataset with biframes dataset, but only when negation is present
  if(any(stringr::str_detect(bigrams_tidy$word1, negation_words) == TRUE)){

    tidy_text <- tidy_text %>%

      # Remove stop words and negation words in dataframe
      dplyr::filter(!word %in% remove_words) %>%
      dplyr::filter(!word %in% bigrams_tidy$word) %>%

      # merge datasets
      dplyr::full_join(bigrams_tidy, by = c("line", "word", "score")) %>%
      dplyr::arrange(line)
  }
  # Make sure one score is printed for each input vector
  tidy_text <- tidy_text %>%
    dplyr::group_by(line) %>%
    dplyr::summarise(score = mean(score, na.rm = TRUE))

  # Guarantee that the output scores fit the input scores
  data <- data.frame(line = seq_along(character_vector))
  output <- dplyr::full_join(data, tidy_text, by = "line")

  return(as.vector(output$score))
}

#' Give labels for scores
#'
#' @param scores Numeric
assign_sentiment_labels <- function(scores) {
  # convert labels
  scores <- car::recode(
    scores, "-3:-0.25= 'negative'; 0.25:3='positive'; else='neutral'"
  )
  return(scores)
}

#' Dutch Sentiment Analysis
#'
#'The sentiment analysis is conducted by using a dutch sentiment dictionary that contains
#'of +3000 classified words. Pattern matching with the classified words in the dictionary is
#'performed by computing similarity indices and also takes negation into account ('niet leuk', 'geen charme').
#'The function scores textual input on a scale from -2 to 2, where negative/positive scores
#'indicate negative/positive sentiment.
#'
#'Adjusting the `output` arg to 'label' yields textual output ('negative', 'neutral', 'positive')
#'
#' @param text A character vector.
#' @param output 'numeric' (standard) or 'label'.
#'
#' @return Numeric or character, depending on output arg
#' @export
#' @examples
#'text <- c(
#'  "Ik vond de film matig",
#'  "De acteurs waren niet slecht",
#'  "Maar het script was allesbehalve goed",
#'  "Die kende geen spanning",
#'  "Zoals je van Tarantino verwacht was het plot fantastisch",
#'  "Gelukkig waren de bioscoopkaarten goedkoop"
#')
#'
#'# use function
#'tibble::tibble(
#'  lines = text,
#'  scores = dutch_sentiment_analysis(text)
#')
dutch_sentiment_analysis <- function(text, output="numeric"){

  # validate input
  stopifnot(output == "numeric" | output == "label")
  stopifnot(is.character(text))

  # get sentiment of each word
  scores <- unname(sapply(text, get_sentiment))

  # recode missings to zero/neutral sentiment
  scores <- ifelse(is.na(scores), 0, scores)

  # assign sentiment labels
  if(output=="label"){
    scores <- assign_sentiment_labels(scores)
  }
  return(scores)
}





