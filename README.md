tidybulk - part of tidyTranscriptomics
================

[![R build
status](https://github.com/stemangiola/tidybulk/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/stemangiola/tidybulk/actions)

**Tidybulk brings transcriptomics to the tidyverse!**

[![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

The code is released under the version 3 of the GNU General Public
License.

<img src="https://github.com/Bioconductor/BiocStickers/blob/master/tidybulk/tidybulk.png?raw=true" width="120px" />

website:
[stemangiola.github.io/tidybulk/](http://stemangiola.github.io/tidybulk/)

Please have a look also to

-   [tidySummarizedExperiment](https://github.com/stemangiola/tidySummarizedExperiment)
    for bulk data tidy representation
-   [tidySingleCellExperiment](https://github.com/stemangiola/tidySingleCellExperiment)
    for single-cell data tidy representation
-   [tidyseurat](https://github.com/stemangiola/tidyseurat) for
    single-cell data tidy representation
-   [tidyHeatmap](https://github.com/stemangiola/tidyHeatmap) for
    heatmaps produced with tidy principles analysis and manipulation
-   [nanny](https://github.com/stemangiola/nanny) for tidy high-level
    data analysis and manipulation
-   [tidygate](https://github.com/stemangiola/tidygate) for adding
    custom gate information to your tibble

<img src="https://github.com/stemangiola/tidybulk/blob/master/inst/new_SE_usage-01.png?raw=true" width="800px" align="left"/>

## Functions/utilities available

| Function                          | Description                                                                  |
|-----------------------------------|------------------------------------------------------------------------------|
| `identify_abundant`               | identify the abundant genes                                                  |
| `aggregate_duplicates`            | Aggregate abundance and annotation of duplicated transcripts in a robust way |
| `scale_abundance`                 | Scale (normalise) abundance for RNA sequencing depth                         |
| `reduce_dimensions`               | Perform dimensionality reduction (PCA, MDS, tSNE)                            |
| `cluster_elements`                | Labels elements with cluster identity (kmeans, SNN)                          |
| `remove_redundancy`               | Filter out elements with highly correlated features                          |
| `adjust_abundance`                | Remove known unwanted variation (Combat)                                     |
| `test_differential_abundance`     | Differential transcript abundance testing (DE)                               |
| `deconvolve_cellularity`          | Estimated tissue composition (Cibersort or llsr)                             |
| `test_differential_cellularity`   | Differential cell-type abundance testing                                     |
| `test_stratification_cellularity` | Estimate Kaplan-Meier survival differences                                   |
| `keep_variable`                   | Filter for top variable features                                             |
| `keep_abundant`                   | Filter out lowly abundant transcripts                                        |
| `test_gene_enrichment`            | Gene enrichment analyses (EGSEA)                                             |
| `test_gene_overrepresentation`    | Gene enrichment on list of transcript names (no rank)                        |

| Utilities                  | Description                                                     |
|----------------------------|-----------------------------------------------------------------|
| `get_bibliography`         | Get the bibliography of your workflow                           |
| `tidybulk`                 | add tidybulk attributes to a tibble object                      |
| `tidybulk_SAM_BAM`         | Convert SAM BAM files into tidybulk tibble                      |
| `pivot_sample`             | Select sample-wise columns/information                          |
| `pivot_transcript`         | Select transcript-wise columns/information                      |
| `rotate_dimensions`        | Rotate two dimensions of a degree                               |
| `ensembl_to_symbol`        | Add gene symbol from ensembl IDs                                |
| `symbol_to_entrez`         | Add entrez ID from gene symbol                                  |
| `describe_transcript`      | Add gene description from gene symbol                           |
| `impute_missing_abundance` | Impute abundance for missing data points using sample groupings |
| `fill_missing_abundance`   | Fill abundance for missing data points using an arbitrary value |

All functions are directly compatible with `SummarizedExperiment`
object.

## Installation

From Bioconductor

``` r
BiocManager::install("tidybulk")    
```

From Github

``` r
devtools::install_github("stemangiola/tidybulk")    
```

# Data

We will use a `SummarizedExperiment` object.

``` r
counts_SE   
```

    ## # A SummarizedExperiment-tibble abstraction: 408,624 x 8
    ## [90m# Transcripts=8513 | Samples=48 | Assays=count[39m
    ##    feature  sample     count Cell.type time  condition batch factor_of_interest
    ##    <chr>    <chr>      <dbl> <fct>     <fct> <lgl>     <fct> <lgl>             
    ##  1 A1BG     SRR1740034   153 b_cell    0 d   TRUE      0     TRUE              
    ##  2 A1BG-AS1 SRR1740034    83 b_cell    0 d   TRUE      0     TRUE              
    ##  3 AAAS     SRR1740034   868 b_cell    0 d   TRUE      0     TRUE              
    ##  4 AACS     SRR1740034   222 b_cell    0 d   TRUE      0     TRUE              
    ##  5 AAGAB    SRR1740034   590 b_cell    0 d   TRUE      0     TRUE              
    ##  6 AAMDC    SRR1740034    48 b_cell    0 d   TRUE      0     TRUE              
    ##  7 AAMP     SRR1740034  1257 b_cell    0 d   TRUE      0     TRUE              
    ##  8 AANAT    SRR1740034   284 b_cell    0 d   TRUE      0     TRUE              
    ##  9 AAR2     SRR1740034   379 b_cell    0 d   TRUE      0     TRUE              
    ## 10 AARS2    SRR1740034   685 b_cell    0 d   TRUE      0     TRUE              
    ## # … with 40 more rows

Loading `tidySummarizedExperiment` will automatically abstract this
object as `tibble`, so we can display it and manipulate it with tidy
tools. Although it looks different, and more tools (tidyverse) are
available to us, this object is in fact a `SummarizedExperiment` object.

``` r
class(counts_SE)    
```

    ## [1] "SummarizedExperiment"
    ## attr(,"package")
    ## [1] "SummarizedExperiment"

## Get the bibliography of your workflow

First of all, you can cite all articles utilised within your workflow
automatically from any tidybulk tibble.

``` r
counts_SE %>%   get_bibliography()  
```

## Aggregate duplicated `transcripts`

tidybulk provide the `aggregate_duplicates` function to aggregate
duplicated transcripts (e.g., isoforms, ensembl). For example, we often
have to convert ensembl symbols to gene/transcript symbol, but in doing
so we have to deal with duplicates. `aggregate_duplicates` takes a
tibble and column names (as symbols; for `sample`, `transcript` and
`count`) as arguments and returns a tibble with transcripts with the
same name aggregated. All the rest of the columns are appended, and
factors and boolean are appended as characters.

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.aggr = counts_SE %>% aggregate_duplicates()   
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
temp = data.frame(  
    symbol = dge_list$genes$symbol, 
    dge_list$counts 
)   
dge_list.nr <- by(temp, temp$symbol,    
    function(df)    
        if(length(df[1,1])>0)   
            matrixStats:::colSums(as.matrix(df[,-1]))   
)   
dge_list.nr <- do.call("rbind", dge_list.nr)    
colnames(dge_list.nr) <- colnames(dge_list) 
```

</div>

<div style="clear:both;">

</div>

## Scale `counts`

We may want to compensate for sequencing depth, scaling the transcript
abundance (e.g., with TMM algorithm, Robinson and Oshlack
doi.org/10.1186/gb-2010-11-3-r25). `scale_abundance` takes a tibble,
column names (as symbols; for `sample`, `transcript` and `count`) and a
method as arguments and returns a tibble with additional columns with
scaled data as `<NAME OF COUNT COLUMN>_scaled`.

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm = counts_SE.aggr %>% identify_abundant(factor_of_interest = condition) %>% scale_abundance() 
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(edgeR)  

dgList <- DGEList(count_m=x,group=group)    
keep <- filterByExpr(dgList)    
dgList <- dgList[keep,,keep.lib.sizes=FALSE]    
[...]   
dgList <- calcNormFactors(dgList, method="TMM") 
norm_counts.table <- cpm(dgList)    
```

</div>

<div style="clear:both;">

</div>

We can easily plot the scaled density to check the scaling outcome. On
the x axis we have the log scaled counts, on the y axes we have the
density, data is grouped by sample and coloured by cell type.

``` r
counts_SE.norm %>%  
    ggplot(aes(count_scaled + 1, group=sample, color=`Cell.type`)) +    
    geom_density() +    
    scale_x_log10() +   
    my_theme    
```

![](man/figures/plot_normalise-1.png)<!-- -->

## Filter `variable transcripts`

We may want to identify and filter variable transcripts.

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.variable = counts_SE.norm %>% keep_variable()
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(edgeR)

x = norm_counts.table

s <- rowMeans((x-rowMeans(x))^2)
o <- order(s,decreasing=TRUE)
x <- x[o[1L:top],,drop=FALSE]

norm_counts.table = norm_counts.table[rownames(x)]

norm_counts.table$cell_type = tibble_counts[
    match(
        tibble_counts$sample,
        rownames(norm_counts.table)
    ),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

## Reduce `dimensions`

We may want to reduce the dimensions of our data, for example using PCA
or MDS algorithms. `reduce_dimensions` takes a tibble, column names (as
symbols; for `sample`, `transcript` and `count`) and a method (e.g., MDS
or PCA) as arguments and returns a tibble with additional columns for
the reduced dimensions.

**MDS** (Robinson et al., 10.1093/bioinformatics/btp616)

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.MDS =
  counts_SE.norm %>%
  reduce_dimensions(method="MDS", .dims = 6)
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(limma)

count_m_log = log(count_m + 1)
cmds = limma::plotMDS(ndim = .dims, plot = FALSE)

cmds = cmds %$% 
    cmdscale.out %>%
    setNames(sprintf("Dim%s", 1:6))

cmds$cell_type = tibble_counts[
    match(tibble_counts$sample, rownames(cmds)),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

On the x and y axes axis we have the reduced dimensions 1 to 3, data is
coloured by cell type.

``` r
counts_SE.norm.MDS %>% pivot_sample()  %>% select(contains("Dim"), everything())
```

    ## # A tibble: 48 x 15
    ##      Dim1   Dim2   Dim3     Dim4    Dim5    Dim6 sample    Cell.type       time 
    ##     <dbl>  <dbl>  <dbl>    <dbl>   <dbl>   <dbl> <chr>     <chr>           <chr>
    ##  1 -1.46   0.220 -1.68   0.0553   0.0658 -0.126  SRR17400… b_cell          0 d  
    ##  2 -1.46   0.226 -1.71   0.0300   0.0454 -0.137  SRR17400… b_cell          1 d  
    ##  3 -1.44   0.193 -1.60   0.0890   0.0503 -0.121  SRR17400… b_cell          3 d  
    ##  4 -1.44   0.198 -1.67   0.0891   0.0543 -0.110  SRR17400… b_cell          7 d  
    ##  5  0.243 -1.42   0.182  0.00642 -0.503  -0.131  SRR17400… dendritic_myel… 0 d  
    ##  6  0.191 -1.42   0.195  0.0180  -0.457  -0.130  SRR17400… dendritic_myel… 1 d  
    ##  7  0.257 -1.42   0.152  0.0130  -0.582  -0.0927 SRR17400… dendritic_myel… 3 d  
    ##  8  0.162 -1.43   0.189  0.0232  -0.452  -0.109  SRR17400… dendritic_myel… 7 d  
    ##  9  0.516 -1.47   0.240 -0.251    0.457  -0.119  SRR17400… monocyte        0 d  
    ## 10  0.514 -1.41   0.231 -0.219    0.458  -0.131  SRR17400… monocyte        1 d  
    ## # … with 38 more rows, and 6 more variables: condition <chr>, batch <chr>,
    ## #   factor_of_interest <chr>, merged.transcripts <dbl>, TMM <dbl>,
    ## #   multiplier <dbl>

``` r
counts_SE.norm.MDS %>%
  pivot_sample() %>%
  GGally::ggpairs(columns = 10:15, ggplot2::aes(colour=`Cell.type`))
```

![](man/figures/plot_mds-1.png)<!-- -->

**PCA**

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.PCA =
  counts_SE.norm %>%
  reduce_dimensions(method="PCA", .dims = 6)
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
count_m_log = log(count_m + 1)
pc = count_m_log %>% prcomp(scale = TRUE)
variance = pc$sdev^2
variance = (variance / sum(variance))[1:6]
pc$cell_type = counts[
    match(counts$sample, rownames(pc)),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

On the x and y axes axis we have the reduced dimensions 1 to 3, data is
coloured by cell type.

``` r
counts_SE.norm.PCA %>% pivot_sample() %>% select(contains("PC"), everything())
```

    ## # A tibble: 48 x 15
    ##        PC1   PC2    PC3     PC4    PC5   PC6 sample  Cell.type   time  condition
    ##      <dbl> <dbl>  <dbl>   <dbl>  <dbl> <dbl> <chr>   <chr>       <chr> <chr>    
    ##  1 -12.6   -2.52 -14.9  -0.424  -0.592 -1.22 SRR174… b_cell      0 d   TRUE     
    ##  2 -12.6   -2.57 -15.2  -0.140  -0.388 -1.30 SRR174… b_cell      1 d   TRUE     
    ##  3 -12.6   -2.41 -14.5  -0.714  -0.344 -1.10 SRR174… b_cell      3 d   TRUE     
    ##  4 -12.5   -2.34 -14.9  -0.816  -0.427 -1.00 SRR174… b_cell      7 d   TRUE     
    ##  5   0.189 13.0    1.66 -0.0269  4.64  -1.35 SRR174… dendritic_… 0 d   FALSE    
    ##  6  -0.293 12.9    1.76 -0.0727  4.21  -1.28 SRR174… dendritic_… 1 d   FALSE    
    ##  7   0.407 13.0    1.42 -0.0529  5.37  -1.01 SRR174… dendritic_… 3 d   FALSE    
    ##  8  -0.620 13.0    1.73 -0.201   4.17  -1.07 SRR174… dendritic_… 7 d   FALSE    
    ##  9   2.56  13.5    2.32  2.03   -4.32  -1.22 SRR174… monocyte    0 d   FALSE    
    ## 10   2.65  13.1    2.21  1.80   -4.29  -1.30 SRR174… monocyte    1 d   FALSE    
    ## # … with 38 more rows, and 5 more variables: batch <chr>,
    ## #   factor_of_interest <chr>, merged.transcripts <dbl>, TMM <dbl>,
    ## #   multiplier <dbl>

``` r
counts_SE.norm.PCA %>%
    pivot_sample() %>%
    GGally::ggpairs(columns = 11:13, ggplot2::aes(colour=`Cell.type`))
```

![](man/figures/plot_pca-1.png)<!-- -->

**tSNE**

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.tSNE =
    breast_tcga_mini_SE %>%
    identify_abundant() %>%
    reduce_dimensions(
        method = "tSNE",
        perplexity=10,
        pca_scale =TRUE
    )
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
count_m_log = log(count_m + 1)

tsne = Rtsne::Rtsne(
    t(count_m_log),
    perplexity=10,
        pca_scale =TRUE
)$Y
tsne$cell_type = tibble_counts[
    match(tibble_counts$sample, rownames(tsne)),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

Plot

``` r
counts_SE.norm.tSNE %>%
    pivot_sample() %>%
    select(contains("tSNE"), everything()) 
```

    ## # A tibble: 251 x 4
    ##     tSNE1   tSNE2 sample                       Call 
    ##     <dbl>   <dbl> <chr>                        <fct>
    ##  1  9.14   -9.88  TCGA-A1-A0SD-01A-11R-A115-07 LumA 
    ##  2 -0.393   8.79  TCGA-A1-A0SF-01A-11R-A144-07 LumA 
    ##  3  2.84  -15.6   TCGA-A1-A0SG-01A-11R-A144-07 LumA 
    ##  4  4.59   -2.77  TCGA-A1-A0SH-01A-11R-A084-07 LumA 
    ##  5  0.946  -6.42  TCGA-A1-A0SI-01A-11R-A144-07 LumB 
    ##  6 12.9     4.83  TCGA-A1-A0SJ-01A-11R-A084-07 LumA 
    ##  7  2.69   32.6   TCGA-A1-A0SK-01A-12R-A084-07 Basal
    ##  8  5.67   -0.335 TCGA-A1-A0SM-01A-11R-A084-07 LumA 
    ##  9  5.37    1.07  TCGA-A1-A0SN-01A-11R-A144-07 LumB 
    ## 10  8.97  -26.0   TCGA-A1-A0SQ-01A-21R-A144-07 LumA 
    ## # … with 241 more rows

``` r
counts_SE.norm.tSNE %>%
    pivot_sample() %>%
    ggplot(aes(x = `tSNE1`, y = `tSNE2`, color=Call)) + geom_point() + my_theme
```

![](man/figures/unnamed-chunk-13-1.png)<!-- -->

## Rotate `dimensions`

We may want to rotate the reduced dimensions (or any two numeric columns
really) of our data, of a set angle. `rotate_dimensions` takes a tibble,
column names (as symbols; for `sample`, `transcript` and `count`) and an
angle as arguments and returns a tibble with additional columns for the
rotated dimensions. The rotated dimensions will be added to the original
data set as `<NAME OF DIMENSION> rotated <ANGLE>` by default, or as
specified in the input arguments.

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.MDS.rotated =
  counts_SE.norm.MDS %>%
  rotate_dimensions(`Dim1`, `Dim2`, rotation_degrees = 45, action="get")
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
rotation = function(m, d) {
    r = d * pi / 180
    ((bind_rows(
        c(`1` = cos(r), `2` = -sin(r)),
        c(`1` = sin(r), `2` = cos(r))
    ) %>% as_matrix) %*% m)
}
mds_r = pca %>% rotation(rotation_degrees)
mds_r$cell_type = counts[
    match(counts$sample, rownames(mds_r)),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

**Original** On the x and y axes axis we have the first two reduced
dimensions, data is coloured by cell type.

``` r
counts_SE.norm.MDS.rotated %>%
  ggplot(aes(x=`Dim1`, y=`Dim2`, color=`Cell.type` )) +
  geom_point() +
  my_theme
```

![](man/figures/plot_rotate_1-1.png)<!-- -->

**Rotated** On the x and y axes axis we have the first two reduced
dimensions rotated of 45 degrees, data is coloured by cell type.

``` r
counts_SE.norm.MDS.rotated %>%
  pivot_sample() %>%
  ggplot(aes(x=`Dim1_rotated_45`, y=`Dim2_rotated_45`, color=`Cell.type` )) +
  geom_point() +
  my_theme
```

![](man/figures/plot_rotate_2-1.png)<!-- -->

## Test `differential abundance`

We may want to test for differential transcription between sample-wise
factors of interest (e.g., with edgeR). `test_differential_abundance`
takes a tibble, column names (as symbols; for `sample`, `transcript` and
`count`) and a formula representing the desired linear model as
arguments and returns a tibble with additional columns for the
statistics from the hypothesis test (e.g., log fold change, p-value and
false discovery rate).

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.de =
    counts_SE %>%
    test_differential_abundance( ~ condition, action="get")
counts_SE.de
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(edgeR)

dgList <- DGEList(counts=counts_m,group=group)
keep <- filterByExpr(dgList)
dgList <- dgList[keep,,keep.lib.sizes=FALSE]
dgList <- calcNormFactors(dgList)
design <- model.matrix(~group)
dgList <- estimateDisp(dgList,design)
fit <- glmQLFit(dgList,design)
qlf <- glmQLFTest(fit,coef=2)
topTags(qlf, n=Inf)
```

</div>

<div style="clear:both;">

</div>

The functon `test_differential_abundance` operated with contrasts too.
The constrasts hve the name of the design matrix (generally
<NAME_COLUMN_COVARIATE><VALUES_OF_COVARIATE>)

``` r
counts_SE.de =
    counts_SE %>%
    identify_abundant(factor_of_interest = condition) %>%
    test_differential_abundance(
        ~ 0 + condition,                  
        .contrasts = c( "conditionTRUE - conditionFALSE"),
        action="get"
    )
```

## Adjust `counts`

We may want to adjust `counts` for (known) unwanted variation.
`adjust_abundance` takes as arguments a tibble, column names (as
symbols; for `sample`, `transcript` and `count`) and a formula
representing the desired linear model where the first covariate is the
factor of interest and the second covariate is the unwanted variation,
and returns a tibble with additional columns for the adjusted counts as
`<COUNT COLUMN>_adjusted`. At the moment just an unwanted covariated is
allowed at a time.

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.adj =
    counts_SE.norm %>% adjust_abundance(    ~ factor_of_interest + batch)
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(sva)

count_m_log = log(count_m + 1)

design =
        model.matrix(
            object = ~ factor_of_interest + batch,
            data = annotation
        )

count_m_log.sva =
    ComBat(
            batch = design[,2],
            mod = design,
            ...
        )

count_m_log.sva = ceiling(exp(count_m_log.sva) -1)
count_m_log.sva$cell_type = counts[
    match(counts$sample, rownames(count_m_log.sva)),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

## Deconvolve `Cell type composition`

We may want to infer the cell type composition of our samples (with the
algorithm Cibersort; Newman et al., 10.1038/nmeth.3337).
`deconvolve_cellularity` takes as arguments a tibble, column names (as
symbols; for `sample`, `transcript` and `count`) and returns a tibble
with additional columns for the adjusted cell type proportions.

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.cibersort =
    counts_SE %>%
    deconvolve_cellularity(action="get", cores=1, prefix = "cibersort__") 
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
source(‘CIBERSORT.R’)
count_m %>% write.table("mixture_file.txt")
results <- CIBERSORT(
    "sig_matrix_file.txt",
    "mixture_file.txt",
    perm=100, QN=TRUE
)
results$cell_type = tibble_counts[
    match(tibble_counts$sample, rownames(results)),
    "Cell.type"
]
```

</div>

<div style="clear:both;">

</div>

With the new annotated data frame, we can plot the distributions of cell
types across samples, and compare them with the nominal cell type labels
to check for the purity of isolation. On the x axis we have the cell
types inferred by Cibersort, on the y axis we have the inferred
proportions. The data is facetted and coloured by nominal cell types
(annotation given by the researcher after FACS sorting).

``` r
counts_SE.cibersort %>%
    pivot_longer(
        names_to= "Cell_type_inferred", 
        values_to = "proportion", 
        names_prefix ="cibersort__", 
        cols=contains("cibersort__")
    ) %>%
  ggplot(aes(x=`Cell_type_inferred`, y=proportion, fill=`Cell.type`)) +
  geom_boxplot() +
  facet_wrap(~`Cell.type`) +
  my_theme +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5), aspect.ratio=1/5)
```

![](man/figures/plot_cibersort-1.png)<!-- -->

## Test differential cell-type abundance

We can also perform a statistical test on the differential cell-type
abundance across conditions

``` r
    counts_SE %>%
    test_differential_cellularity(. ~ condition )
```

We can also perform regression analysis with censored data (coxph).

``` r
    # Add survival data

    counts_SE %>%   
    test_differential_cellularity(survival::Surv(time, dead) ~ .)
```

## Cluster `samples`

We may want to cluster our data (e.g., using k-means sample-wise).
`cluster_elements` takes as arguments a tibble, column names (as
symbols; for `sample`, `transcript` and `count`) and returns a tibble
with additional columns for the cluster annotation. At the moment only
k-means clustering is supported, the plan is to introduce more
clustering methods.

**k-means**

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.cluster = counts_SE.norm.MDS %>%
  cluster_elements(method="kmeans", centers = 2, action="get" )
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
count_m_log = log(count_m + 1)

k = kmeans(count_m_log, iter.max = 1000, ...)
cluster = k$cluster

cluster$cell_type = tibble_counts[
    match(tibble_counts$sample, rownames(cluster)),
    c("Cell.type", "Dim1", "Dim2")
]
```

</div>

<div style="clear:both;">

</div>

We can add cluster annotation to the MDS dimension reduced data set and
plot.

``` r
counts_SE.norm.cluster %>%
  ggplot(aes(x=`Dim1`, y=`Dim2`, color=`cluster_kmeans`)) +
  geom_point() +
  my_theme
```

![](man/figures/plot_cluster-1.png)<!-- -->

**SNN**

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.SNN =
    counts_SE.norm.tSNE %>%
    cluster_elements(method = "SNN")
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(Seurat)

snn = CreateSeuratObject(count_m)
snn = ScaleData(
    snn, display.progress = TRUE,
    num.cores=4, do.par = TRUE
)
snn = FindVariableFeatures(snn, selection.method = "vst")
snn = FindVariableFeatures(snn, selection.method = "vst")
snn = RunPCA(snn, npcs = 30)
snn = FindNeighbors(snn)
snn = FindClusters(snn, method = "igraph", ...)
snn = snn[["seurat_clusters"]]

snn$cell_type = tibble_counts[
    match(tibble_counts$sample, rownames(snn)),
    c("Cell.type", "Dim1", "Dim2")
]
```

</div>

<div style="clear:both;">

</div>

``` r
counts_SE.norm.SNN %>%
    pivot_sample() %>%
    select(contains("tSNE"), everything()) 
```

    ## # A tibble: 251 x 5
    ##     tSNE1   tSNE2 sample                       Call  cluster_SNN
    ##     <dbl>   <dbl> <chr>                        <fct> <fct>      
    ##  1  9.14   -9.88  TCGA-A1-A0SD-01A-11R-A115-07 LumA  0          
    ##  2 -0.393   8.79  TCGA-A1-A0SF-01A-11R-A144-07 LumA  1          
    ##  3  2.84  -15.6   TCGA-A1-A0SG-01A-11R-A144-07 LumA  0          
    ##  4  4.59   -2.77  TCGA-A1-A0SH-01A-11R-A084-07 LumA  3          
    ##  5  0.946  -6.42  TCGA-A1-A0SI-01A-11R-A144-07 LumB  3          
    ##  6 12.9     4.83  TCGA-A1-A0SJ-01A-11R-A084-07 LumA  0          
    ##  7  2.69   32.6   TCGA-A1-A0SK-01A-12R-A084-07 Basal 1          
    ##  8  5.67   -0.335 TCGA-A1-A0SM-01A-11R-A084-07 LumA  3          
    ##  9  5.37    1.07  TCGA-A1-A0SN-01A-11R-A144-07 LumB  3          
    ## 10  8.97  -26.0   TCGA-A1-A0SQ-01A-21R-A144-07 LumA  0          
    ## # … with 241 more rows

``` r
counts_SE.norm.SNN %>%
    pivot_sample() %>%
    gather(source, Call, c("cluster_SNN", "Call")) %>%
    distinct() %>%
    ggplot(aes(x = `tSNE1`, y = `tSNE2`, color=Call)) + geom_point() + facet_grid(~source) + my_theme
```

![](man/figures/SNN_plot-1.png)<!-- -->

``` r
# Do differential transcription between clusters
counts_SE.norm.SNN %>%
    mutate(factor_of_interest = `cluster_SNN` == 3) %>%
    test_differential_abundance(
    ~ factor_of_interest,
    action="get"
   )
```

    ## # A SummarizedExperiment-tibble abstraction: 125,500 x 15
    ## [90m# Transcripts=500 | Samples=251 | Assays=count, count_scaled[39m
    ##    feature sample  count count_scaled Call  tSNE1 tSNE2 cluster_SNN
    ##    <chr>   <chr>   <int>        <int> <fct> <dbl> <dbl> <fct>      
    ##  1 ENSG00… TCGA-…  22114        22114 LumA   9.14 -9.88 0          
    ##  2 ENSG00… TCGA-… 128257       128257 LumA   9.14 -9.88 0          
    ##  3 ENSG00… TCGA-…  23971        23971 LumA   9.14 -9.88 0          
    ##  4 ENSG00… TCGA-…  22518        22518 LumA   9.14 -9.88 0          
    ##  5 ENSG00… TCGA-…  23250        23250 LumA   9.14 -9.88 0          
    ##  6 ENSG00… TCGA-…  30039        30039 LumA   9.14 -9.88 0          
    ##  7 ENSG00… TCGA-…  32987        32987 LumA   9.14 -9.88 0          
    ##  8 ENSG00… TCGA-…  42292        42292 LumA   9.14 -9.88 0          
    ##  9 ENSG00… TCGA-…  12417        12417 LumA   9.14 -9.88 0          
    ## 10 ENSG00… TCGA-…  40820        40820 LumA   9.14 -9.88 0          
    ## # … with 40 more rows, and 7 more variables: factor_of_interest <lgl>,
    ## #   .abundant <lgl>, logFC <dbl>, logCPM <dbl>, F <dbl>, PValue <dbl>,
    ## #   FDR <dbl>

## Drop `redundant` transcripts

We may want to remove redundant elements from the original data set
(e.g., samples or transcripts), for example if we want to define
cell-type specific signatures with low sample redundancy.
`remove_redundancy` takes as arguments a tibble, column names (as
symbols; for `sample`, `transcript` and `count`) and returns a tibble
with redundant elements removed (e.g., samples). Two redundancy
estimation approaches are supported:

-   removal of highly correlated clusters of elements (keeping a
    representative) with method=“correlation”
-   removal of most proximal element pairs in a reduced dimensional
    space.

**Approach 1**

<div class="column-left">

TidyTranscriptomics

``` r
counts_SE.norm.non_redundant =
  counts_SE.norm.MDS %>%
  remove_redundancy(method = "correlation")
```

</div>

<div class="column-right">

Standard procedure (comparative purpose)

``` r
library(widyr)

.data.correlated =
    pairwise_cor(
        counts,
        sample,
        transcript,
        rc,
        sort = TRUE,
        diag = FALSE,
        upper = FALSE
    ) %>%
    filter(correlation > correlation_threshold) %>%
    distinct(item1) %>%
    rename(!!.element := item1)

# Return non redudant data frame
counts %>% anti_join(.data.correlated) %>%
    spread(sample, rc, - transcript) %>%
    left_join(annotation)
```

</div>

<div style="clear:both;">

</div>

We can visualise how the reduced redundancy with the reduced dimentions
look like

``` r
counts_SE.norm.non_redundant %>%
  pivot_sample() %>%
  ggplot(aes(x=`Dim1`, y=`Dim2`, color=`Cell.type`)) +
  geom_point() +
  my_theme
```

![](man/figures/plot_drop-1.png)<!-- -->

**Approach 2**

``` r
counts_SE.norm.non_redundant =
  counts_SE.norm.MDS %>%
  remove_redundancy(
  method = "reduced_dimensions",
  Dim_a_column = `Dim1`,
  Dim_b_column = `Dim2`
  )
```

We can visualise MDS reduced dimensions of the samples with the closest
pair removed.

``` r
counts_SE.norm.non_redundant %>%
  pivot_sample() %>%
  ggplot(aes(x=`Dim1`, y=`Dim2`, color=`Cell.type`)) +
  geom_point() +
  my_theme
```

![](man/figures/plot_drop2-1.png)<!-- -->

## Other useful wrappers

The above wrapper streamline the most common processing of bulk RNA
sequencing data. Other useful wrappers are listed above.

## From BAM/SAM to tibble of gene counts

We can calculate gene counts (using FeatureCounts; Liao Y et al.,
10.1093/nar/gkz114) from a list of BAM/SAM files and format them into a
tidy structure (similar to counts).

``` r
counts = tidybulk_SAM_BAM(
    file_names,
    genome = "hg38",
    isPairedEnd = TRUE,
    requireBothEndsMapped = TRUE,
    checkFragLength = FALSE,
    useMetaFeatures = TRUE
)
```

## From ensembl IDs to gene symbol IDs

We can add gene symbols from ensembl identifiers. This is useful since
different resources use ensembl IDs while others use gene symbol IDs.
This currently works for human and mouse.

``` r
counts_ensembl %>% ensembl_to_symbol(ens)
```

    ## # A tibble: 119 x 8
    ##    ens    iso   `read count` sample cases_0_project… cases_0_samples… transcript
    ##    <chr>  <chr>        <dbl> <chr>  <chr>            <chr>            <chr>     
    ##  1 ENSG0… 13             144 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  2 ENSG0… 13              72 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  3 ENSG0… 13               0 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  4 ENSG0… 13            1099 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  5 ENSG0… 13              11 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  6 ENSG0… 13               2 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  7 ENSG0… 13               3 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  8 ENSG0… 13            2678 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ##  9 ENSG0… 13             751 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ## 10 ENSG0… 13               1 TARGE… Acute Myeloid L… Primary Blood D… TSPAN6    
    ## # … with 109 more rows, and 1 more variable: ref_genome <chr>

## From gene symbol to gene description (gene name in full)

We can add gene full name (and in future description) from symbol
identifiers. This currently works for human and mouse.

``` r
counts_SE %>% 
    describe_transcript() %>% 
    select(feature, description, everything())
```

    ## # A SummarizedExperiment-tibble abstraction: 408,624 x 9
    ## [90m# Transcripts=8513 | Samples=48 | Assays=count[39m
    ##    feature sample count Cell.type time  condition batch factor_of_inter…
    ##    <chr>   <chr>  <dbl> <fct>     <fct> <lgl>     <fct> <lgl>           
    ##  1 A1BG    SRR17…   153 b_cell    0 d   TRUE      0     TRUE            
    ##  2 A1BG-A… SRR17…    83 b_cell    0 d   TRUE      0     TRUE            
    ##  3 AAAS    SRR17…   868 b_cell    0 d   TRUE      0     TRUE            
    ##  4 AACS    SRR17…   222 b_cell    0 d   TRUE      0     TRUE            
    ##  5 AAGAB   SRR17…   590 b_cell    0 d   TRUE      0     TRUE            
    ##  6 AAMDC   SRR17…    48 b_cell    0 d   TRUE      0     TRUE            
    ##  7 AAMP    SRR17…  1257 b_cell    0 d   TRUE      0     TRUE            
    ##  8 AANAT   SRR17…   284 b_cell    0 d   TRUE      0     TRUE            
    ##  9 AAR2    SRR17…   379 b_cell    0 d   TRUE      0     TRUE            
    ## 10 AARS2   SRR17…   685 b_cell    0 d   TRUE      0     TRUE            
    ## # … with 40 more rows, and 1 more variable: description <chr>
