
# Load libraries -----------------------------------------------------------------------

library(stringr)
#install.packages("gitcreds")
library(gitcreds)

# Start of Functions   ------------------------------------------------------------------

# Function f_price_cleanUp   ------------------------------------------------------------

f_price_cleanUp <- function(x,y,z) {
  
  
  ind_empty_rows <- which((x) == "")
  
  if (length(ind_empty_rows) > 0)   { x[ind_empty_rows] <- "$Â 0.000,00"  }
  
  y <- (x)
  
  pattern_price_from <- "\\."
  pattern_price_to <- "xyz" 
  z <- str_replace(y, pattern_price_from, pattern_price_to)
  
  pattern_price_from <- ","
  pattern_price_to <- "\\."
  z <- str_replace(z, pattern_price_from, pattern_price_to)
  
  pattern_price_from <- "xyz" 
  pattern_price_to <- ""
  z <- str_replace(z, pattern_price_from, pattern_price_to)
  
  pattern_price_from <- "[A-z \n$Â\\s]+" 
  pattern_price_to <- ""
  z <- str_replace(z, pattern_price_from, pattern_price_to)
  
  z <- str_replace(z, pattern_price_from, pattern_price_to)
  
  z <- as.numeric(z)
  
  return(z)
}


# End of Functions   -------------------------------------------------------------------


# Load data directories ----------------------------------------------------------------

userP <- Sys.getenv('USERPROFILE')

dirD <- "\\OneDrive\\MASTER_FILES\\My Documents\\2022_P0\\G_MED_SUPERMARKET\\DATA2"

dirF <- paste(userP,dirD,sep="")



# Reading data files -------------------------------------------------------------------

jumbo_section_files <- list.files(dirF,pattern = ".csv", full.names = TRUE)

str(jumbo_section_files)

i <- 1

pattern_simple_filename1 <- ".*DATA2/"
pattern_simple_filename2 <- "\\.csv"

jumbo_section_name <- str_replace(jumbo_section_files[i], pattern_simple_filename1, "")
jumbo_section_name <- str_replace(jumbo_section_name, pattern_simple_filename2, "")

jumbo_section_merge <- read.csv(jumbo_section_files[i],encoding="UTF-8")

jumbo_section_merge$Category <- jumbo_section_name


for (i in 2:length(jumbo_section_files)) {
  
  jumbo_section <- read.csv(jumbo_section_files[i],encoding="UTF-8")

  jumbo_section_name <- str_replace(jumbo_section_files[i], pattern_simple_filename1, "")
  jumbo_section_name <- str_replace(jumbo_section_name, pattern_simple_filename2, "")
  
  jumbo_section$Category <- jumbo_section_name
  
  
  
# Merging each csv category file into single datafile -----------------------------------
  
  
  jumbo_section_merge <- rbind(jumbo_section_merge,jumbo_section)
 
  
}


# Reading data files --------------------------------------------------------------------


i <- sapply(jumbo_section_merge, is.factor)
jumbo_section_merge[i] <- lapply(jumbo_section_merge[i], as.character)


# Cleaning up text characters price columns  ---------------------------------

jumbo_section_merge$RegularPriceS <- f_price_cleanUp(jumbo_section_merge$RegularPrice)

jumbo_section_merge$AhoraPriceS <- f_price_cleanUp(jumbo_section_merge$AhoraPrice)

pattern_unit_price <- "[0-9.]+,{0,1}[0-9.]+"
jumbo_section_merge$UnitPriceS <- str_extract(jumbo_section_merge$UnitPrice, pattern_unit_price)
jumbo_section_merge$UnitPriceS <- f_price_cleanUp(jumbo_section_merge$UnitPriceS)

pattern_prime_price <- "[0-9.]+,{0,1}[0-9.]+"
jumbo_section_merge$PrimePriceS <- str_extract(jumbo_section_merge$PrimePrice, pattern_prime_price)
jumbo_section_merge$PrimePriceS <- f_price_cleanUp(jumbo_section_merge$PrimePriceS)


# Deleting original price columns  ---------------------------------


jumbo_section_merge$RegularPrice <- NULL
jumbo_section_merge$AhoraPrice <- NULL
jumbo_section_merge$UnitPrice <- NULL
jumbo_section_merge$PrimePrice <- NULL




