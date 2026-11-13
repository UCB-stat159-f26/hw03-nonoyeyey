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

While testing my R package, I learned to check which years the data actually covered. My first result for Nadal stopped in 2016. Reading another file from Tennis Abstract extended the results to 2018, but his player page included matches through 2024. After that, I started checking the first and last match dates along with the number of rows.

Serena’s data showed me why the row count alone can be misleading. Her player page had more rows, but it left out some of her earliest matches. I changed the package to check that the player page covers at least the same date range as the other data source before using it. I’d still need to compare individual records to find missing matches within that range.

## AI assistance

I used ChatGPT to help draft and debug the R functions, offline tests, and
documentation. I ran the tests and checked the results for Serena Williams
and Rafael Nadal in Jupyter.
