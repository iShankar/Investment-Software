# This is V4 of Pat-James_My Composites. 7/21/18 & 7/23/18
# uses Pat screen to choose ~1458 stocks of which the goal is to find
# 25 for Pat's fund; 
# As an intermediate step, I will choose the top 200 and compare Jim's 
# composites with NA at 50 (and not). Also Fraud flag will be set
# I have implemented Jim's Value, financial, and Accounting composites, and momentum screen
# All those will be computed here and correlated with others. 
# Z_Bad_Int_Flag was fixed on 7/23/18 and the notebook was copied and pasted into Excel again. 

setwd("C:/Investment/Programs")  
library(fBasics)
library(readxl)
getwd()
#options("scipen"=-100, "digits"=4)

fPath <- "C:/Investment/Data/Pat_Jim_RS"  # Add local directory name

excelfile <- "Pat_Jim_RS_V4.2_07232018.xlsx"
#excelfile <- "SimpleRExample.xlsx"
invest <- paste(fPath, excelfile, sep="/")
print(invest)

# *** Start of the part to access different sheets
# gnam not used so far. So default of 1 is used. 

gnam <- 1
# Per sheet info
investData <- read_excel(invest, sheet = gnam) #change sheetname or number for other sheets
df.inv <- as.data.frame(investData, stringsAsFactors=FALSE)
head(df.inv[,1:4])
#rownames(df.inv)
colnames(df.inv)
summary(df.inv)

# Many variables are characters, not numerics. 
# Convert all but the company name and Ticker to numerics.
# Avoid using numeric values for columns - they may change from one import to the next
nCompany <- which( colnames(df.inv)== "Company name")
nTicker <- which( colnames(df.inv)== "Ticker")
df.inv.nums <- df.inv[, -c(nCompany, nTicker)]
df.inv.numb <- as.data.frame(sapply(df.inv.nums, as.numeric))
df.invest <- cbind(df.inv[, c(nCompany, nTicker)], df.inv.numb)
summary(df.invest)
rm(df.inv.nums, df.inv.numb, df.inv, investData)

# Ref: https://stats.stackexchange.com/questions/11924/computing-percentile-rank-in-r

perc.rank <- function(x) {
  rank <- trunc(rank(x))/length(x)
  #return(rank)
}
# Pat O'S does not include any company with NAs; 
# Shaun O'S includes them in % ranking, with NA replaced with 50
# I will try correlations with and without 50 for NA
# 

# Pat composite starts here

#1 Subtract % Rank-Price/FCFPS from 100 to get % Rank-FCFPS/Price
df.invest$'% Rank-FCFPS/Price' <- 100 - df.invest$`% Rank-Price/FCFPS`
head(df.invest$`% Rank-Price/FCFPS`)
head(df.invest$`% Rank-FCFPS/Price`)
ln <- length(df.invest)
ln
# Find column numbers and use them in print. This avoids hard-coding. 
nPtoFCFPS <- which( colnames(df.invest)== "% Rank-Price/FCFPS")
nFCFPStoP <- which( colnames(df.invest)== "% Rank-FCFPS/Price") # Pat Metric

print (df.invest[1:10, c(nPtoFCFPS, nFCFPStoP)])
#print(df.invest[1:10,c(3,19)]) # this commented out line is hard-coding. Avoid these. 

#2 Calculate %Rank for POShaugh-EPSQuality and POShaugh-ShOrientation
EPS <- df.invest$`POShaugh-EPSQuality`
ShOr <- df.invest$`POShaugh-ShOrientation`
RetIC <- df.invest$`Return on inv cap Y1`  

# restrict to only decimal values
df.invest <- within(df.invest, '% Rank-EPSQual' <- round(100* perc.rank(EPS)))
df.invest <- within(df.invest, '% Rank-ShOrient' <- round(100* perc.rank(ShOr)))
df.invest <- within(df.invest, '% Rank-ROIC' <- round(100* perc.rank(RetIC)))
# Avoid hard-coding
nEPS_SIP <- which( colnames(df.invest)== "POShaugh-EPSQuality")  
nSh_SIP <- which( colnames(df.invest)== "POShaugh-ShOrientation" )
nROIC_SIP <- which( colnames(df.invest)== "Return on inv cap Y1" )
nEPSQual <- which( colnames(df.invest)== "% Rank-EPSQual") # Pat Metric
nShOrient <- which( colnames(df.invest)== "% Rank-ShOrient") # Pat Metric
nROIC <-  which( colnames(df.invest)== "% Rank-ROIC") # Pat Metric

print(df.invest[1:10,c(nEPS_SIP, nEPSQual, nSh_SIP, nShOrient, nROIC_SIP, nROIC )]) 

# 
nRelStr <- which( colnames(df.invest)== "% Rank-Rel Strength 26 week") # Pat Metric

df.invest$PatScore <- rowSums(df.invest[, c(nFCFPStoP, nEPSQual, nShOrient, nROIC, nRelStr)])
nPScore <- which( colnames(df.invest)== "PatScore") # Pat Composite
print(df.invest[1:10,c(nFCFPStoP, nEPSQual, nShOrient, nROIC, nRelStr, nPScore)])
# -- Pat metrics is completed here


# -- James metrics start here
# Remove hardcoding 
# calculate Value Composites 1 and 3 based on O'S metrics
# replace NAs with 50 and then substract from 100
# d[is.na(d)] <- 0

nRPtoBk <- which( colnames(df.invest)== "% Rank-Price/Book")
nRPtoCFPS <- which( colnames(df.invest)== "% Rank-Price/CFPS")
nRPtoE <- which( colnames(df.invest)== "% Rank-PE")
nRPtoS <- which( colnames(df.invest)== "% Rank-Price/Sales")

# Calculate with NAs left as is. NAs are left as is for these computations. 
df.preval <- df.invest[, c(nRPtoBk,nRPtoCFPS,nRPtoE,nRPtoS)]
df.preval <- 100- df.preval

# Replace NAs with 50 - as per Jim's comments for his value composites
df.val <- df.preval
df.val[is.na(df.val)] <- 50

# change column names
colnames(df.preval) <- c("% Rank-Book/Price", "% Rank-CFPS/Price", "% Rank-Erng/Price","% Rank-Sales/Price")
colnames(df.val) <- c("Val_BktoP", "Val_CFtoP", "Val_EtoP", "Val_StoP")

# sanity check
head(df.preval); head(df.val) 

# convert EV/EBITDA and Shareholder_Yield to % Rank. Low and High good respectively.
EV_EBITDA <- df.invest$`Enterprise Value/EBITDA`
ShareYld <- df.invest$`Shareholder Yield`

# Find median and use it. Not needed now, can put 50 after %Rank 
#df.val2 <- as.data.frame(cbind(EV_EBITDA, ShareYld)) 
#df.val2.median <- sapply(df.val2, median, na.rm=TRUE) -- Useful in momentum screen
#EV_EBITDA[is.na(EV_EBITDA)]<- df.val2.median[1] 
#ShareYld[is.na(ShareYld)] <- df.val2.median[2]

# EBITDA/EV and ShareYld - high is good. 
# Note subtraction from 100 for the first one. 
df.invest <- within(df.invest, '% Rank-EBITDA/EV' <- (100-round(100* perc.rank(EV_EBITDA))))
df.invest <- within(df.invest, '% Rank-ShareYld' <- round(100* perc.rank(ShareYld)))

# find column numbers
nEVtoEBIT <- which( colnames(df.invest)== "Enterprise Value/EBITDA")
nShYld <-  which( colnames(df.invest)== "Shareholder Yield")
nREBITtoEV <- which( colnames(df.invest)== "% Rank-EBITDA/EV")
nRShYld <- which( colnames(df.invest)== "% Rank-ShareYld")
# sanity check
print(df.invest[1:10,c(nEVtoEBIT, nREBITtoEV, nShYld, nRShYld)]) 

df.val2 <- df.invest[, c(nREBITtoEV, nRShYld)] 
df.val2[is.na(df.val2)] <- 50
colnames(df.val2) <- c("Val_EBITtoEV", "Val_ShYld")
# sanity check
head (df.invest[, c(nREBITtoEV,nRShYld )]); head(df.val2) 

df.invest <- cbind(df.invest, df.preval, df.val, df.val2)

ln <- length(df.invest)
ln
print(df.invest[1:10,c((ln-10):ln)])

# Calculate composite score with NA as is ('preval') and with NA replaced with 50 ('val')
# Find column numbers
# Known are: nREBITtoEV, nRShYld
# Find nVREBITtoEV, nVShYld
# Find nRBKtoP, nRCFtoP, nREtoP,nRStoP
# Find nVBktoP, nVCFtoP, nVEtoP, nVStoP
# TO COMPLETE ITEMS above -- 7/21/18 11 PM
#nEVtoEBIT <- which( colnames(df.invest)== "Enterprise Value/EBITDA")  - template to use
nVREBITtoEV <- which( colnames(df.invest)== "Val_EBITtoEV") 
nVShYld <- which( colnames(df.invest)== "Val_ShYld") 
nRBKtoP <- which( colnames(df.invest)== "% Rank-Book/Price") 
nRCFtoP <- which( colnames(df.invest)== "% Rank-CFPS/Price") 
nREtoP <- which( colnames(df.invest)== "% Rank-Erng/Price") 
nRStoP <- which( colnames(df.invest)== "% Rank-Sales/Price") 
nVBktoP <- which( colnames(df.invest)== "Val_BktoP") 
nVCFtoP <- which( colnames(df.invest)== "Val_CFtoP") 
nVEtoP <- which( colnames(df.invest)== "Val_EtoP") 
nVStoP <- which( colnames(df.invest)== "Val_StoP") 


df.invest$PreValScore <- rowSums(df.invest[, c(nRBKtoP,nRCFtoP,nREtoP,nRStoP,nREBITtoEV, nRShYld)])
df.invest$ValScore <- rowSums(df.invest[, c(nVBktoP, nVCFtoP, nVEtoP, nVStoP,nVREBITtoEV, nVShYld)])

#nEVtoEBIT <- which( colnames(df.invest)== "Enterprise Value/EBITDA")  - template to use
nPreValScore <- which( colnames(df.invest)== "PreValScore")   # for use later
nValScore <- which( colnames(df.invest)== "ValScore")   # for use later

ln <- length(df.invest)
ln
print(df.invest[1:10,c((ln-12):ln)])

# Even if one entry has an NA, preValue becomes NA in the PreValue composite
# Jim Value (and PreValue) composite calculations completed here. 

# calculate medians for all at once
# commented out for now - Is it needed?



# calculate Jim's momentum composite 
#nEVtoEBIT <- which( colnames(df.invest)== "Enterprise Value/EBITDA")  - template to use
nTradVol <- which( colnames(df.invest)== "Trading_Volume_Dollars")
nPrMom6mo <- which( colnames(df.invest)== "Price_Change_6mo")
nPrMom3mo <- which( colnames(df.invest)== "Price_Change_3mo")
nPrVol12mo <- which( colnames(df.invest)== "Price_Volatility_12mo_Abs")
nPrCh5Yrs <- which( colnames(df.invest)== "Price_Change_5Yrs_Abs")

#Caclulate medians
#invest_median <- sapply(df.invest[, 3:22], median, na.rm=TRUE) #- computes for all at once. 
medMom <- sapply(df.invest[, c(nTradVol, nPrVol12mo, nPrMom3mo, nPrCh5Yrs, nPrMom6mo)], median, na.rm=TRUE)
meanMom <- sapply(df.invest[, c(nTradVol, nPrVol12mo, nPrMom3mo, nPrCh5Yrs, nPrMom6mo)], mean, na.rm=TRUE)
sdMom <- sapply(df.invest[, c(nTradVol, nPrVol12mo, nPrMom3mo, nPrCh5Yrs, nPrMom6mo)], sd, na.rm=TRUE)
# Calculate Momentum Flags
TradVolFlag <- df.invest[,nTradVol] < medMom["Trading_Volume_Dollars"]
PrVol12moFlag <- df.invest[,nPrVol12mo]< medMom["Price_Volatility_12mo_Abs"]
# Mean + Sd limits the range to about 33%; Jim wants <30%. close enough
PrCh5YrsFlag <- df.invest[,nPrCh5Yrs] < (meanMom["Price_Change_5Yrs_Abs"] + sdMom["Price_Change_5Yrs_Abs"])
PrMom6moFlag <- df.invest[,nPrMom6mo] > medMom["Price_Change_6mo"]
PrMom3moFlag <- df.invest[,nPrMom3mo] > medMom["Price_Change_3mo"]
MomentumFlag <- TradVolFlag & PrVol12moFlag & PrCh5YrsFlag & PrMom6moFlag & PrMom3moFlag
df.momentum <- data.frame(MomentumFlag)
# sanity check. Are there any companies that pass all these criteria? 
sum(MomentumFlag, na.rm=TRUE)
df.invest <- cbind(df.invest, df.momentum)

# calculate Fraud measure
# Yet to implement a flag for the SEC Letter
#medMom <- sapply(df.invest[, c(nTradVol, nPrVol12mo, nPrMom3mo, nPrCh5Yrs, nPrMom6mo)], median, na.rm=TRUE)
nQoEFlag <- which( colnames(df.invest)== "QualOfEarnings_Bad_Flag")
nQoRFlag <- which( colnames(df.invest)== "QualOfRevenue_Bad_Flag")
nQoAFlag <- which( colnames(df.invest)== "QualOfAssets_Bad_Flag")
nZBadFlag <- which( colnames(df.invest)== "Z_Bad_Int_Flag")
nFCFEFlag <- which( colnames(df.invest)== "FCFE_Neg_Flag")

#FraudScore <- sapply(df.invest[, c(nQoEFlag, nQoRFlag, nQoAFlag, nZBadFlag, nFCFEFlag)], sum, na.rm=TRUE)
FraudScore <- rowSums(df.invest[, c(nQoEFlag, nQoRFlag, nQoAFlag, nZBadFlag, nFCFEFlag)],na.rm=TRUE )
df.FraudScore <- data.frame(FraudScore)
df.invest <- cbind(df.invest, df.FraudScore)
#TACC
#TACCFlag <- (df.invest$TotalAccrual>

# calculate Financial and Accounting composites. 
# to do soon. 




# The section below for saving is OK. The items in-between, on Jim's composites is incomplete. 
#head(df.invest[,1:4])
#head(df.invest$bv)
investFile1 <- paste0(fPath, "/Pat_Jim_RS_V4.2.csv")
investFile1
write.csv(df.invest, file = investFile1, row.names=FALSE)
#df.sort <- sort(df.invest$CompositeScore)
#newdata <- mtcars[order(mpg, -cyl),] 
df.invest200 <- df.invest[order(-df.invest$PatScore),]
print(df.invest200[1:10, c(1,22)])
df.invest200 <- df.invest200[1:200,]
investFile2 <- paste0(fPath, "/PatTop200_JIm_RS_V4.2.csv")
investFile2
write.csv(df.invest200, file = investFile2, row.names=FALSE)

# Note - Percent rank gives percentiles at and below, not below only. 
#my.df <- data.frame(x=rnorm(200))
#my.df <- within(my.df, xr <- perc.rank(x))
#my.df
#plot(my.df[[2]], my.df[[1]])

# Table styling refs: https://stackoverflow.com/questions/31323885/how-to-color-specific-cells-in-a-data-frame-table-in-r
# https://rstudio.github.io/DT/010-style.html
