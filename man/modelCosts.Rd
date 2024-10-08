% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modelcosts.R
\name{modelCosts}
\alias{modelCosts}
\title{Model the trend of invasive alien species costs over time}
\usage{
modelCosts(
  costdb,
  cost.column = "Cost_estimate_per_year_2017_USD_exchange_rate",
  year.column = "Impact_year",
  cost.transf = "log10",
  in.millions = TRUE,
  confidence.interval = 0.95,
  minimum.year = 1960,
  maximum.year = max(costdb[, year.column]),
  final.year = max(costdb[, year.column]),
  incomplete.year.threshold = NULL,
  incomplete.year.weights = NULL,
  gam.k = -1,
  mars.nprune = NULL,
  ...
)
}
\arguments{
\item{costdb}{The \bold{expanded 'InvaCost' database} output from 
\code{\link{expandYearlyCosts}},
where costs occurring over several years are expanded over each year of 
impact}

\item{cost.column}{Name of the cost column to use in \code{costdb} (usually, 
choose between the exchange rate (default) or Purchase Power Parity 
cost per year)}

\item{year.column}{Name of the year column to use in \code{costdb}}

\item{cost.transf}{Type of transformation you want to apply on cost values.
The default is a log10 transformation, which is commonly applied in 
economics,
allows to fit linear regression with a normal distribution of residuals, 
and makes plots easier to read. You can apply another transformation by 
specifying the name of the transformation function (e.g., natural
logarithm, {\code{"log"}}). Specify \code{NA} or \code{NULL} to avoid any 
transformation}

\item{in.millions}{If \code{TRUE}, cost values are transformed in 
millions (to make graphs easier to read), else if \code{}, cost values are
not transformed}

\item{confidence.interval}{A numeric value between 0 and 1, corresponding
to the desired confidence interval around model predictions}

\item{minimum.year}{The starting year of this analysis. By default, 
1960 was chosen because it marks the period from which world bank data is 
available for exchange rates and inflation values}

\item{maximum.year}{The ending year for this analysis. By default, the last
year of \code{costdb} is chosen}

\item{final.year}{The year for which the costs predicted by models is
printed in the output. Default is the last year of \code{costdb}. Note that 
this is only for convenience, since predictions for all years are available
in the \code{estimated.annual.costs} element of the output object}

\item{incomplete.year.threshold}{Estimated threshold for incomplete cost 
data. All years above or equal to this threshold will be excluded from 
model calibration, because of the time-lag between economic impacts of
invasive alien species and the documentation and publication of these impacts}

\item{incomplete.year.weights}{A named vector containing weights of years
for the regressions. Useful to decrease the weights of incomplete years
in regressions. Names of this vector must correspond to years}

\item{gam.k}{The smoothing factor of GAM; default value of -1 lets the
GAM find the smoothing factor automatically. Provide a manual value if you 
have expectations about the shape of the curve and want to avoid overfitting
because of interannual variations}

\item{mars.nprune}{The maximum number of model terms in the MARS model. 
Lowering this value reduces the number of terms in the MARS model, which
can be useful if you have expectations about the shape of the curve and want
to reduce the impact of interannual variations}

\item{...}{Other arguments (you do not need them!)}
}
\value{
A \code{list} with 3 to 6 elements (only the first three are
provided if you selected a cost transformation different from log10):

\itemize{
\item{\code{input.data}: the input cost data, for reproducibility of 
analyses}
\item{\code{cost.data}: the costs of invasions per year, as sums of all 
costs for each year}
\item{\code{parameters}: parameters used to run the function. The 
\code{minimum.year} and \code{maximum.year} are based on the input data
(i.e., the user may specify \code{minimum.year = 1960} but the input data may
only have data starting from 1970, hence the \code{minimum.year} will be
 1970)}
\item{\code{fitted.models}: a list of objects containing the fitted models. 
They can be extracted individually for refining analyses or making new
predictions}
\item{\code{estimated.annual.costs}: a data.frame containing the predicted 
cost values for each year for all the fitted models}
\item{\code{RMSE}: an array containing RMSE of models for the calibration 
data and for all data. \bold{NOTE: the RMSE for Quantile Regressions is not a 
relevant metric, IGNORE it unless you know what you are doing!}}
\item{\code{final.year.cost}: a vector containing the estimated annual
costs of invasive alien species based on all models for \code{final.year}.}
}
The structure of this object can be seen using \code{str()}.
}
\description{
This function fits different models on 'InvaCost' data expressed per year 
in order to estimate and predict the trend of invasive alien Species costs 
over time.
}
\examples{
data(invacost)

### Cleaning steps
# Eliminating data with no information on starting and ending years
invacost <- invacost[-which(is.na(invacost$Probable_starting_year_adjusted)), ]
invacost <- invacost[-which(is.na(invacost$Probable_ending_year_adjusted)), ]
# Keeping only observed and reliable costs
invacost <- invacost[invacost$Implementation == "Observed", ]
invacost <- invacost[which(invacost$Method_reliability == "High"), ]
# Eliminating data with no usable cost value
invacost <- invacost[-which(is.na(invacost$Cost_estimate_per_year_2017_USD_exchange_rate)), ]

### Expansion
\donttest{
db.over.time <- expandYearlyCosts(invacost,
                                  startcolumn = "Probable_starting_year_adjusted",
                                  endcolumn = "Probable_ending_year_adjusted")
                                  
### Analysis
res <- modelCosts(db.over.time)
res}
}
\references{
\url{https://github.com/Farewe/invacost}

Leroy Boris, Kramer Andrew M, Vaissière Anne-Charlotte, Kourantidou Melina,
Courchamp Franck & Diagne Christophe (2022). Analysing economic costs 
of invasive alien species with the invacost R package. Methods in Ecology
and Evolution. \doi{10.1111/2041-210X.13929}
}
\seealso{
\code{\link{expandYearlyCosts}} to get the database in appropriate format.
}
\author{
Boris Leroy \email{leroy.boris@gmail.com}, Andrew Kramer, Anne-Charlotte
Vaissière, Christophe Diagne
}
