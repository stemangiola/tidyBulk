% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/methods.R, R/methods_SE.R
\docType{methods}
\name{identify_abundant}
\alias{identify_abundant}
\alias{identify_abundant,spec_tbl_df-method}
\alias{identify_abundant,tbl_df-method}
\alias{identify_abundant,tidybulk-method}
\alias{identify_abundant,SummarizedExperiment-method}
\alias{identify_abundant,RangedSummarizedExperiment-method}
\title{find abundant transcripts}
\usage{
identify_abundant(
  .data,
  .sample = NULL,
  .transcript = NULL,
  .abundance = NULL,
  factor_of_interest = NULL,
  minimum_counts = 10,
  minimum_proportion = 0.7
)

\S4method{identify_abundant}{spec_tbl_df}(
  .data,
  .sample = NULL,
  .transcript = NULL,
  .abundance = NULL,
  factor_of_interest = NULL,
  minimum_counts = 10,
  minimum_proportion = 0.7
)

\S4method{identify_abundant}{tbl_df}(
  .data,
  .sample = NULL,
  .transcript = NULL,
  .abundance = NULL,
  factor_of_interest = NULL,
  minimum_counts = 10,
  minimum_proportion = 0.7
)

\S4method{identify_abundant}{tidybulk}(
  .data,
  .sample = NULL,
  .transcript = NULL,
  .abundance = NULL,
  factor_of_interest = NULL,
  minimum_counts = 10,
  minimum_proportion = 0.7
)

\S4method{identify_abundant}{SummarizedExperiment}(
  .data,
  .sample = NULL,
  .transcript = NULL,
  .abundance = NULL,
  factor_of_interest = NULL,
  minimum_counts = 10,
  minimum_proportion = 0.7
)

\S4method{identify_abundant}{RangedSummarizedExperiment}(
  .data,
  .sample = NULL,
  .transcript = NULL,
  .abundance = NULL,
  factor_of_interest = NULL,
  minimum_counts = 10,
  minimum_proportion = 0.7
)
}
\arguments{
\item{.data}{A `tbl` (with at least three columns for sample, feature and transcript abundance) or `SummarizedExperiment` (more convenient if abstracted to tibble with library(tidySummarizedExperiment))}

\item{.sample}{The name of the sample column}

\item{.transcript}{The name of the transcript/gene column}

\item{.abundance}{The name of the transcript/gene abundance column}

\item{factor_of_interest}{The name of the column of the factor of interest. This is used for defining sample groups for the filtering process. It uses the filterByExpr function from edgeR.}

\item{minimum_counts}{A real positive number. It is the threshold of count per million that is used to filter transcripts/genes out from the scaling procedure.}

\item{minimum_proportion}{A real positive number between 0 and 1. It is the threshold of proportion of samples for each transcripts/genes that have to be characterised by a cmp bigger than the threshold to be included for scaling procedure.}
}
\value{
A consistent object (to the input) with additional columns for the statistics from the hypothesis test (e.g.,  log fold change, p-value and false discovery rate).

A consistent object (to the input) with additional columns for the statistics from the hypothesis test (e.g.,  log fold change, p-value and false discovery rate).

A consistent object (to the input) with additional columns for the statistics from the hypothesis test (e.g.,  log fold change, p-value and false discovery rate).

A consistent object (to the input) with additional columns for the statistics from the hypothesis test (e.g.,  log fold change, p-value and false discovery rate).

A `SummarizedExperiment` object

A `SummarizedExperiment` object
}
\description{
identify_abundant() takes as input A `tbl` (with at least three columns for sample, feature and transcript abundance) or `SummarizedExperiment` (more convenient if abstracted to tibble with library(tidySummarizedExperiment)) and returns a consistent object (to the input) with additional columns for the statistics from the hypothesis test.
}
\details{
`r lifecycle::badge("maturing")`

At the moment this function uses edgeR (DOI: 10.1093/bioinformatics/btp616)

 Underlying method:
 edgeR::filterByExpr(
   data,
	min.count = minimum_counts,
	group = string_factor_of_interest,
	min.prop = minimum_proportion
)
}
\examples{



	identify_abundant(
	tidybulk::se_mini
	)


}
