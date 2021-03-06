#' Get optional slotted DESeqAnalysis from a RankedList object
#'
#' @note Updated 2021-03-16.
#' @noRd
#'
#' @details
#' Intentionally error with an informative error message.
.getDESeqAnalysis <-  # nolint
    function(object) {
        assert(is(object, "FGSEAList"))
        deseq <- metadata(object)[["deseq"]]
        if (!is(deseq, "DESeqAnalysis")) {
            stop(paste(
                "'FGSEAList' does not contain 'DESeqAnalysis'",
                "in 'deseq' 'metadata()' slot."
            ))
        }
        deseq
    }




#' Get the top up- and down-regulated pathways from FGSEA results
#'
#' @note Updated 2020-03-18.
#' @noRd
#'
#' @param ... Passthrough arguments to `.enrichedGeneSets`.
#' @param n `integer(1)`.
#'   Number of upregulated and downregulated sets (each) to return.
#'
#' @examples
#' data(fgsea)
#' .headtail(
#'     object = fgsea[[1L]][[1L]],
#'     alphaThreshold = 0.9,
#'     nesThreshold = 1L,
#'     direction = "both",
#'     n = 2L,
#'     idCol = "pathway",
#'     alphaCol = "padj",
#'     nesCol = "NES"
#' )
.headtail <- function(..., direction, n) {
    assert(isInt(n))
    direction <- match.arg(direction, choices = c("both", "up", "down"))
    args <- list(...)
    ## Upregulated sets.
    if (isSubset(direction, c("both", "up"))) {
        up <- do.call(
            what = .enrichedGeneSets,
            args = c(args, direction = "up")
        )
        up <- head(x = up, n = n)
    } else {
        up <- character()
    }
    ## Downregulated sets.
    if (isSubset(direction, c("both", "down"))) {
        down <- do.call(
            what = .enrichedGeneSets,
            args = c(args, direction = "down")
        )
        down <- head(x = down, n = n)
    } else {
        down <- character()
    }
    ## Combine upregulated and downregulated sets.
    egs <- unique(c(up, rev(down)))
    egs
}



#' Match symbols in gene set to gene IDs (i.e. DESeqDataSet rownames)
#'
#' Handle situation where DESeq object doesn't contain all symbols defined in
#' the gene set.
#'
#' @note Updated 2021-02-16.
#' @noRd
.matchGenesToIDs <- function(object, set, genes) {
    assert(
        is(object, "FGSEAList"),
        isString(set),
        isCharacter(genes)
    )
    suppressMessages({
        g2s <- Gene2Symbol(object)
    })
    colnames(g2s) <- camelCase(colnames(g2s), strict = TRUE)
    idx <- na.omit(match(x = genes, table = g2s[["geneName"]]))
    if (!hasLength(idx)) return(NULL)
    g2s <- g2s[idx, , drop = FALSE]
    assert(hasRows(g2s))
    out <- g2s[["geneId"]]
    assert(isCharacter(out))
    out
}
