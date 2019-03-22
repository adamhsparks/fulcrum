.validate_fileout <- function(CSV, dsn, filename, GPKG) {
	  if (!is.null(filename) & !isTRUE(CSV) & !isTRUE(GPKG)) {
	    stop("\nYou need to specify a filetype, CSV or GPKG.\n")
	  }
	  if (isTRUE(CSV) | isTRUE(GPKG)) {
	    if (is.null(dsn)) {
	      dsn <- getwd()
	    }
	    dsn <- trimws(dsn)
	  } else {
	    if (substr(dsn, nchar(dsn) - 1, nchar(dsn)) == "//") {
	      p <- substr(dsn, 1, nchar(dsn) - 2)
	    } else if (substr(dsn, nchar(dsn), nchar(dsn)) == "/" |
	               substr(dsn, nchar(dsn), nchar(dsn)) == "\\") {
	      p <- substr(dsn, 1, nchar(dsn) - 1)
	    } else {
	      p <- dsn
	    }
	    if (!file.exists(p) & !file.exists(dsn)) {
	      stop("\nFile dsn does not exist: ", dsn, ".\n")
	    }
	  }
	  if (substr(dsn, nchar(dsn), nchar(dsn)) != "/" &
	      substr(dsn, nchar(dsn), nchar(dsn)) != "\\") {
	    dsn <- paste0(dsn, "/")
	  }
	  if (is.null(filename)) {
	    filename_out <- "GSOD"
	  } else {
	    filename_out <- filename
	  }
	  outfile <- paste0(dsn, filename_out)
	  return(outfile)

