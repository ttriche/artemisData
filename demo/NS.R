suppressPackageStartupMessages(library(artemisData))
jsonFile <- system.file("extdata/json", "NS.JSON", package="artemisData")
appSession <- fetchAppSession(jsonFile) ## autofill APPSESSION in paths
names(appSession$samples) <- appSession$samples ## so column names get set 
appSession$outputPath <- system.file("extdata", "", package="artemisData")
NS <- with(appSession, mergeKallisto(samples, outputPath=outputPath)
## head(assays(NS)$tpm)

NS$subject <- factor(substr(colnames(NS), 2, 2))
NS$treatment <- substr(colnames(NS), 1, 1) == "s"
design <- with(as(colData(NS), "data.frame"),
                  model.matrix( ~ treatment + subject ))
rownames(design) <- colnames(NS)
exptData(NS)$design <- design

## save a copy for easy retrieval & easy running of examples
## save(NS, file="~/Dropbox/artemisData/data/NS.rda", compress="xz")
