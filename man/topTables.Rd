% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/topTables-methods.R
\name{topTables}
\alias{topTables}
\alias{topTables,FGSEAList-method}
\title{Top tables}
\usage{
topTables(object, ...)

\S4method{topTables}{FGSEAList}(object, collection, n = 10L, headerLevel = 3L)
}
\arguments{
\item{object}{Object.}

\item{collection}{\code{character(1)}.
Gene set collection name.
Typically refers to \code{h} (hallmark), \code{c1}-\code{c7} collections from MSigDb.
Can obtain using \code{collectionNames()} on \code{FGSEAList} object.}

\item{n}{\code{integer(1)}.
Number of significant processes to include.
Bidirectional; will include \code{n} up- and down-regulated processes.}

\item{headerLevel}{\code{integer(1)}.
Markdown header level.}

\item{...}{Additional arguments.}
}
\value{
Markdown output.
}
\description{
Top tables of significantly enriched pathways.
}
\details{
Supports looping across multiple DEG results, and adds a Markdown header for
each contrast.
}
\note{
Requires the knitr package to be installed.

Updated 2021-02-17.
}
\examples{
data(fgsea)

## FGSEAList ====
alphaThreshold(fgsea) <- 0.9
topTables(fgsea, collection = "h")
}
