# tenniscareer

`tenniscareer` retrieves tennis match records from Tennis Abstract and plots
the age difference between a player and their opponent for each match.

## Installation

```r
install.packages("remotes")
remotes::install_github("UCB-stat159-f26/hw03-nonoyeyey")
```

## Usage

```r
library(tenniscareer)

serena <- get_career_data("Serena Williams")
plot_career(serena)

nadal <- get_career_data("Rafael Nadal")
plot_career(nadal)
```

The horizontal axis shows the player's age at the time of the match.
The vertical axis shows the player's age minus the opponent's age.
Blue points are wins and red points are losses. Matches without usable ages
remain in the returned data but are omitted from the plot.

## Tests

From the repository root, run:

```bash
Rscript -e 'testthat::test_local()'
```

The tests use local fixtures. The usage examples above retrieve live data.

## Reflection

My first live check for Nadal returned matches only through 2016.
Adding the second JavaScript file extended the results through 2018,
but the player page contained matches through 2024. I learned to check
the date range as well as the row count. A response can look reasonable
and still be missing years of data.

I also found that selecting the player page by default dropped Serena's
early matches. The package now compares the birth date, row count, and
date range before preferring the player page. This checks coverage at the
beginning and end of the data, but it does not verify every match
individually.

## AI assistance

I used ChatGPT to help draft and debug the R functions, offline tests, and
documentation. I ran the tests and checked the results for Serena Williams
and Rafael Nadal in Jupyter.
