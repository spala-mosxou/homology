# FileToHomolFP R program

args <- commandArgs(trailingOnly = TRUE)
subject <- args[1]

source("parameters.R")

# xdsss <- 12

cat("\n  Working on subject", subject, ".\n")
startdate <- date()

inputfile <- paste(subject, inputfileappendFP, sep = "")

# Takes an 'FileToHomolP' output file as input.

system.time( homol <- FileToHomolFP(file.name = inputfile, TSEliot = NULL, rnames.in.col.1 = FALSE,
                                    roi.num = .8, thresh = xthresh, mask = useMask, noHomol = FALSE,
                                    omit.freq = omitFreq, kindOfBig = 37, maxDim=MAXDIM, drictree = inputdirFP,
                                    aList = NULL, withEuler = FALSE, tires = 3, DontSweatTheSmallStuff1 = 0,
                                    DontSweatTheSmallStuff2 = 12, traceIt = MAXDIM, returnReducedMat = TRUE,
                                    checkAcyc = FALSE, IHaveMyLimits = 45000, constant.comment = commentFP,
                                    verbosity = vrbst, blahblahblah = 3) )

SI()

cat(" Check filtration condition.\n")

x <- homol$homology.output

n <- length(x) 

if(n > 1) {
    zyx <- matrix(rep(NA, 2*(n-1)), ncol = 2)
    dimnames(zyx) <- list( as.character(2:n), c("acyclic", "wholeEnchilada") )

    for(i in 2:n) {
        xaw <- x[[i]]$excisionTrickPOutput; xaw <- xaw$AandWs
        xa <- xaw$acyclic
        xxx <- append(xa, xaw$whatsLeft)

        yaw <- x[[i-1]]$excisionTrickPOutput; yaw <- yaw$AandWs
        ya <- yaw$acyclic
        yyy <- append(ya, yaw$whatsLeft)

        zyx[i-1, "acyclic"] <- subCmplx(xa, ya)
        zyx[i-1, "wholeEnchilada"] <- subCmplx(xxx, yyy)
    }

    if( all( apply(zyx, 2, all) ) ) {
        cat("   Just as filtered as filtered can be!\n")
    } else {
        cat("\n   SUBJECT", subject, "IS NOT FILTERED! HERE'S SAD STORY:\n")
        print(zyx)
        break
    }
} else {
  cat("  Only one frequency level.  'Filteredness' isn't an issue.\n")
}

# Save output
outputfile <- paste(subject, outputfileappendFP, sep = ".")
save( homol, file = paste(outputdirFP, outputfile, sep = "/") )
rm(homol, MAXDIM, trighs, omitFreq, commentFP, useMask)

cat("\n\n       Done with subject ", subject, " -- started", startdate, "and ended", date(), "\n")
# This celebratory signal indicates when a subject is finished. If you've got 40 processors going,
# the din might drive you crazy so you might want to comment this out.
# alarm()
