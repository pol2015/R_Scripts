
# Load libraries ---------------------------

library(stringr)


# Load data directories ---------------------------

userP <- Sys.getenv('USERPROFILE')

dirD <- "\\OneDrive\\MASTER_FILES\\My Documents\\2022_P0\\G_MED_SUPERMARKET\\DATA2"

dirF <- paste(userP,dirD,sep="")



# Reading data files ---------------------------

jumbo_section_files <- list.files(dirF,pattern = ".csv", full.names = TRUE)

str(jumbo_section_files)

i <- 1

pattern_simple_filename1 <- ".*DATA2/"
pattern_simple_filename2 <- "\\.csv"

jumbo_section_name <- str_replace(jumbo_section_files[i], pattern_simple_filename1, "")
jumbo_section_name <- str_replace(jumbo_section_name, pattern_simple_filename2, "")

jumbo_section_merge <- read.csv(jumbo_section_files[i])

jumbo_section_merge$Category <- jumbo_section_name


for (i in 2:length(jumbo_section_files)) {
  
  jumbo_section <- read.csv(jumbo_section_files[i])

  jumbo_section_name <- str_replace(jumbo_section_files[i], pattern_simple_filename1, "")
  jumbo_section_name <- str_replace(jumbo_section_name, pattern_simple_filename2, "")
  
  jumbo_section$Category <- jumbo_section_name
  
  jumbo_section_merge <- rbind(jumbo_section_merge,jumbo_section)
 
  
}



args()