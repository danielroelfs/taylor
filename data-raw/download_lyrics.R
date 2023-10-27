library(tidyverse)
library(rvest)

album_list <- read_html("https://genius.com/a/read-all-the-lyrics-to-taylor-swifts-new-album-1989-taylors-version") %>%
  html_nodes("li") %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  str_subset("https://genius.com/Taylor-swift-")

outpath <- "data-raw/lyrics/05b_1989-taylors-version"

num = 1
for (link in album_list) {
  num_label <- str_pad(num, 2, side = "left", pad = "0")

  outfile <- link %>%
    str_extract("(?<=Taylor-swift-).*(?=-taylors-version)") %>%
    {str_glue("{num_label}_{.}.txt")}

  print(str_glue("Downloading lyrics for {outfile}"))

  read_html(link) %>%
    html_nodes("[data-lyrics-container]") %>%
    html_text2() %>%
    str_c() %>%
    write_lines(file = str_glue("{outpath}/{outfile}"))

  num = num + 1
}


