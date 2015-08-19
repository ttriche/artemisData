\name{withSleuth}
\alias{withSleuth}
\docType{data}
\title{Using sleuth with the artemisData package}
\description{
  Sleuth for our purposes...
}
\examples{

  library(dplyr)
  library(sleuth)
  library(biomaRt)
 
  base_dir <- system.file("extdata", "", package="artemisData")
  sample_id <- grep("[ns][124]", dir(base_dir), value=TRUE)
  kal_dirs <- paste(base_dir, sample_id, sep=.Platform$file.sep)

  covs <- data.frame(sample=sample_id,
                     condition=as.factor(substr(sample_id, 1, 1)),
                     subject=as.factor(substr(sample_id, 2, 2)))

  mart <- biomaRt::useMart(biomart = "ensembl", 
                           dataset = "hsapiens_gene_ensembl")

  t2g <- biomaRt::getBM(mart = mart,
                        attributes = c("ensembl_transcript_id", 
                                       "ensembl_gene_id",
                                       "transcript_biotype",
                                       "gene_biotype",
                                       "external_gene_name")) 
  t2g <- dplyr::rename(t2g, 
                       target_id = ensembl_transcript_id,
                       ens_gene = ensembl_gene_id, 
                       ext_gene = external_gene_name)

  ## Showstopper: duplicated rows "LTR26B", "SVA_A" in all 6 samples!
  ## Can handle this pre-quant in artemis and/or post-quant in sleuth
  ## TxDbLite could also handle this by merging transcript annotation
  ##
  so <- sleuth_prep(kal_dirs, covs, ~ condition, target_mapping = t2g)
  so <- sleuth_fit(so)
  so <- sleuth_test(so, which_beta = 'conditions')

  ## shiny interface
  sleuth_live(so)
 
  ## static output  
  results_table <- sleuth_results(so, 'conditions') 

}
\keyword{datasets}
