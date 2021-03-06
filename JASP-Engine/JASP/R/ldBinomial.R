#
# Copyright (C) 2013-2020 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

LDbinomial <- function(jaspResults, dataset, options, state=NULL){
  options <- .ldRecodeOptionsBinomial(options)
  
  #### Show binomial section ----
  .ldIntroText(jaspResults, options, "binomial distribution")
  .ldBinomialParsSupportMoments(jaspResults, options)
  
  
  pmfContainer <- .ldGetPlotContainer(jaspResults, options, "plotPMF", "Probability Mass Function", 3)
  .ldFillPMFContainer(pmfContainer, options, .ldFormulaBinomialPMF)
  
  cmfContainer <- .ldGetPlotContainer(jaspResults, options, "plotCMF", "Cumulative Distribution Function", 4)
  .ldFillCMFContainer(cmfContainer, options, .ldFormulaBinomialCDF)
  
  
  #### Generate and Display data section ----
  # simulate and read data
  .simulateData(jaspResults, options)
  
  ready <- options[['variable']] != ""
  errors <- FALSE
  if(ready && is.null(dataset)){
    dataset <- .readDataSetToEnd(columns.as.numeric = options[['variable']])
    
    variable <- dataset[[.v(options[['variable']])]]
    variable <- variable[!is.na(variable)]
    errors <- .hasErrors(dataset, type = c("observations", "variance", "infinity", "limits"),
                         observations.amount = "<1",
                         limits.min = options$support$min, limits.max = options$support$max, 
                         exitAnalysisIfErrors = FALSE)
    errors <- .ldCheckInteger(variable, errors)
  }
  
  # overview of the data
  dataContainer <- .ldGetDataContainer(jaspResults, options, errors)
  
  readyDesc <- ready && (isFALSE(errors) || (is.null(errors$infinity) && is.null(errors$observations)))
  .ldSummaryContinuousTableMain(dataContainer, variable, options, readyDesc)
  .ldObservedMomentsTableMain  (dataContainer, variable, options, readyDesc)
  .ldPlotHistogram             (dataContainer, variable, options, readyDesc, "discrete")
  .ldPlotECDF                  (dataContainer, variable, options, readyDesc)
  
  
  #### Fit data and assess fit ----
  
  readyFit <- ready && isFALSE(errors)
  #### Maximum Likelihood ----
  if(options$methodMLE){
    mleContainer <- .ldGetFitContainer(jaspResults, options, "mleContainer", "Maximum likelihood", 7, errors)
    
    # parameter estimates
    mleEstimatesTable  <- .ldEstimatesTable(mleContainer, options, TRUE, TRUE, "methodMLE")
    mleResults   <- .ldMLEResults(mleContainer, variable, options, readyFit, options$distNameInR)
    .ldFillBinomialEstimatesTable(mleEstimatesTable, mleResults, options, readyFit)
    
    # fit assessment
    mleFitContainer    <- .ldGetFitContainer(mleContainer, options, "mleFitAssessment", "Fit Assessment", 8)

    # fit statistics
    mleFitStatistics   <- .ldFitStatisticsTable(mleFitContainer, options, "methodMLE")
    mleFitStatisticsResults <- .ldFitStatisticsResults(mleContainer, mleResults$fitdist, variable, options, readyFit)
    .ldFillFitStatisticsTable(mleFitStatistics, mleFitStatisticsResults, options, readyFit)
    #return()
    # fit plots
    .ldFitPlots(mleFitContainer, mleResults$fitdist$estimate, options, variable, readyFit)
    
  }
  
  #### Method of moments ----
  
  #### Unbiased estimate ----
  
  return()
}

### options ----
.ldRecodeOptionsBinomial <- function(options){
  
  options[['parValNames']] <- c("prob", "size")
  
  options[['pars']]   <- list(prob = options[['prob']], size = options[['size']])
  options[['fix.pars']] <- list(size = options[['size']])
    
  options[['pdfFun']] <- dbinom
  options[['cdfFun']] <- pbinom
  options[['qFun']]   <- qbinom
  options[['rFun']]   <- rbinom
  options[['distNameInR']] <- "binom"
  
  options[['range_x']] <- c(options[['min_x']], options[['max_x']])
  
  options[['highlightmin']] <- options[['min']]
  options[['highlightmax']] <- options[['max']]
 
  options$support <- list(min = 0, max = options[['size']])
  options$lowerBound <- c(0)
  options$upperBound <- c(1)
  
  options$transformations <- c(prob = "prob")
  
  options
}

### text fill functions -----
.ldBinomialParsSupportMoments <- function(jaspResults, options){
  if(options$parsSupportMoments && is.null(jaspResults[['parsSupportMoments']])){
    pars <- list()
    pars[[1]] <- gettextf("probability of success: %s", "p \u2208 \u211D: 0 \u2264 p \u2264 1")
    pars[[2]] <- gettextf("number of trials: %s",       "n \u2208 \u2124: n \u2265 0")
    
    support <- "x \u2208 \u2124: 0 \u2264 x \u2264 n"
    
    moments <- list()
    moments$expectation <- "np"
    moments$variance <- "np(1-p)"
    
    jaspResults[['parsSupportMoments']] <- .ldParsSupportMoments(pars, support, moments)
  }
}

.ldFormulaBinomialPMF <- function(options){
    text <- "<MATH>
    f(x; <span style='color:red'>p</span>, <span style='color:blue'>n</span>) = 
    </MATH>"
  
  return(gsub(pattern = "\n", replacement = " ", x = text))
}

.ldFormulaBinomialCDF <- function(options){
  text <- "<MATH>
    F(x; <span style='color:red'>p</span>, <span style='color:blue'>n</span>) = 
    </MATH>"
  
  return(gsub(pattern = "\n", replacement = " ", x = text))
}

.ldFormulaBinomialQF <- function(options){
  text <- "<MATH>
    Q(x; <span style='color:red'>p</span>, <span style='color:blue'>n</span>) = 
    </MATH>"
  
  return(gsub(pattern = "\n", replacement = " ", x = text))
}

#### Table functions ----

.ldFillBinomialEstimatesTable <- function(table, results, options, ready){
  if(!ready) return()
  if(is.null(results)) return()
  if(is.null(table)) return()
  
  res <- results$structured
  res$parName <- c("p")
  
  if(results$fitdist$convergence != 0){
    table$addFootnote(gettext("The optimization did not converge, try adjusting the parameter values."), symbol = gettext("<i>Warning.</i>"))
  }
  if(!is.null(results$fitdist$optim.message)){
    table$addFootnote(results$fitdist$message, symbol = gettext("<i>Warning.</i>"))
  }
  
  table$addFootnote(message = gettextf("Parameter n was fixed at value %s.", options[['size']]))
  table$setData(res)
  
  return()
}
