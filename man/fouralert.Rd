% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alert_functions.R
\name{fouralert}
\alias{fouralert}
\title{Define conditions to issue a four level alert Green-Yellow-Orange-Red.}
\usage{
fouralert(obj, pars, crit, pop, miss = "last")
}
\arguments{
\item{obj}{dataset from the mergedata function.}

\item{pars}{list of parameters for the alerta, defined in config.R}

\item{crit}{criteria for the alert colors, defined in configglobal.R}

\item{miss}{how missing data is treated. "last" if last value is repeated. 
It is currently the only option}
}
\value{
list with data.frame with the week condition and the number of weeks within the 
last lag weeks with conditions = TRUE, data, and rules.
}
\description{
Yellow is raised when environmental conditions required for
positive mosquito population growth are detected, green otherwise.Orange 
indicates evidence of sustained transmission, red indicates evidence of 
an epidemic scenario.
}
\examples{
# Getting the data (requires a con connection)
tw = getTweet(city = 3200136, datasource = con) 
cli = getWU(stations = 'SBVT', vars=c("temp_min", "umid_min"), datasource=con)
cas = getCases(city = 3200136,datasource=con)
# Organizing the data
casfit<-adjustIncidence(obj=cas, method="bayesian")
casr<-Rt(obj = casfit, count = "tcasesmed", gtdist="normal", meangt=3, sdgt = 1)
d<- mergedata(cases = casr, tweet = tw, climate = cli)
d$temp_min <- nafill(d$temp_min, rule = "arima") 
d$umid_min <- nafill(d$umid_min, rule = "arima") 
# Parameters of the alert model (usually set up in the globalconfig and config files)
criteriaU = list(crity = c("temp_min > tcrit & inc > 0", 3, 1),
crito = c("p1 > 0.95 & inc > preseas", 3, 1),
critr = c("inc > inccrit", 2, 2))
gtdist="normal"; meangt=3; sdgt = 1.2
pars.ES <- NULL
pars.ES[["Central"]] <- list(pdig = c(2.997765,0.7859499),tcrit=NA, ucrit=87, inccrit = 100, preseas=8.28374162389761, 
posseas = 7.67878514885295, legpos="bottomright")
# Running the alert
ale <- fouralert(d, pars = pars.ES[["Central"]], crit = criteriaU, pop = 1000000)
ale <- fouralert(d, pars = pars.ES[["Central"]], crit = criteriaU, pop = 1000000)
# For a more useful output
res <- write.alerta(ale)
tail(res)
}
