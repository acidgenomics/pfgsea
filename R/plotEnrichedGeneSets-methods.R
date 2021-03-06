#' @name plotEnrichedGeneSets
#' @inherit AcidGenerics::plotEnrichedGeneSets
#' @note Updated 2020-09-21.
#'
#' @inheritParams AcidRoxygen::params
#' @inheritParams params
#' @param ... Additional arguments.
#'
#' @return `ggplot`.
#'
#' @seealso [plotGeneSet()].
#'
#' @examples
#' data(fgsea)
#' alphaThreshold(fgsea) <- 0.9
#' plotEnrichedGeneSets(fgsea, collection = "h", n = 1L)
NULL



## Modified 2020-09-21.
`plotEnrichedGeneSets,FGSEAList` <-  # nolint
    function(
        object,
        collection,
        direction = c("both", "up", "down"),
        n = 10L,
        headerLevel = 3L
    ) {
        validObject(object)
        assert(
            isString(collection),
            isSubset(collection, collectionNames(object)),
            isInt(n),
            isHeaderLevel(headerLevel)
        )
        alphaThreshold <- alphaThreshold(object)
        nesThreshold <- nesThreshold(object)
        direction <- match.arg(direction)
        data <- object[[collection]]
        invisible(mapply(
            contrast = names(data),
            data = data,
            MoreArgs = list(
                alphaThreshold = alphaThreshold,
                nesThreshold = nesThreshold,
                direction = direction,
                n = n
            ),
            FUN = function(
                contrast,
                data,
                alphaThreshold,
                nesThreshold,
                direction,
                n
            ) {
                markdownHeader(
                    text = contrast,
                    level = headerLevel,
                    tabset = TRUE,
                    asis = TRUE
                )
                sets <- .headtail(
                    object = data,
                    alphaThreshold = alphaThreshold,
                    nesThreshold = nesThreshold,
                    direction = direction,
                    n = n,
                    idCol = "pathway",
                    alphaCol = "padj",
                    nesCol = "NES"
                )
                if (!hasLength(sets)) {
                    return(invisible(NULL))  # nocov
                }
                ## Using an `mapply()` call here so we can pass the pathway
                ## names in easily into the `markdownHeader()` call.
                mapply(
                    set = sets,
                    MoreArgs = list(
                        collection = collection,
                        contrast = contrast,
                        headerLevel = headerLevel + 1L
                    ),
                    FUN = function(
                        set,
                        collection,
                        contrast,
                        headerLevel
                    ) {
                        markdownHeader(set, level = headerLevel, asis = TRUE)
                        p <- plotGeneSet(
                            object,
                            collection = collection,
                            contrast = contrast,
                            set = set
                        )
                        tryCatch(
                            expr = print(p),
                            error = function(e) invisible(NULL)
                        )
                    }
                )
            }
        ))
    }



#' @rdname plotEnrichedGeneSets
#' @export
setMethod(
    f = "plotEnrichedGeneSets",
    signature = signature("FGSEAList"),
    definition = `plotEnrichedGeneSets,FGSEAList`
)
