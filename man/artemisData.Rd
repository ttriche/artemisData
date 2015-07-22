\name{artemisData}
\alias{artemisData}
\docType{data}
\title{RNAseq data for the artemis example and a more complicated dataset}
\description{
This package contains a \code{KallistoExperiment} instance, NS, as well
as 6 HDF5 files with 100 bootstraps each from an RNAseq experiment in HSPCs,
and finally raw FASTA & FASTQ files for testing the internals of artemis.
}
\examples{

## this is demo/example.R in artemis 

setwd("~")
library(artemis)
library(artemisData)
library(matrixStats)

message("Looking for Kallisto in ~/bin...")
kallisto <- paste0(path.expand("~/bin"), "/kallisto")
if(!file.exists(kallisto)) {
  message("You do not seem to have kallisto installed.  We can't proceed.")
} else {
  message("Found it, proceeding...")
}

pathBase <- system.file("extdata", "", package="artemisData")
fastaPath <- paste0(pathBase, "/fasta")
fastqPath <- paste0(pathBase, "/fastq")
samples <- c(MrN="MrN", MrT="MrT") ## normally set by appSession
fastaFiles <- c( "ERCC.fa.gz", ## spike-in controls  
                 "Homo_sapiens.RepBase.20_05.humrep.fa.gz", ## most repeats 
                 "Homo_sapiens.RepBase.20_05.humsub.fa.gz")  ## ALUs etc.

## build an index if it isn't already there (in artemisData, it is)
indexName <- indexKallisto(fastaFiles=fastaFiles, 
                           fastaPath=fastaPath)$indexName

## run pseudoalignments 
results <- lapply(samples, 
                  runKallisto,
                  indexName=indexName,
                  fastqPath=fastqPath,
                  fastaPath=fastaPath,
                  bootstraps=5,
                  outputPath=".")
merged <- suppressWarnings(mergeKallisto(samples, outputPath="."))

## plot differentially mobilized classes of repeat elements
topK <- function(x, k=50) x[rev(order(rowSds(x)))[1:k], ]
heatmap(topK(tpm(merged)), main="Repeat elements, teratoma vs. normal")

}
\keyword{datasets}
