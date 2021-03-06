Audit Workflow
==========================

An auditor's job is to make a jugement regarding the fairness of the presented transactions in a population, and judge if the population contains errors that are material (lower than materiality). When the auditor has access to the raw population data, she can use the *audit workflow* to calculate how many samples need to be evaluated in order to meet a certain confidence in their judgement. She can then sample these observations from the data, inspect these observations, and produce a statement about the amount of error in the population. The workflow guides the auditor through the audit process, making the correct choices of calculations along the way. The frequentist *audit workflow* may use the risk assessments from the *audit risk model* to adjust the required riks of finding material errors.

----

Workflow
-----------
The audit workflow consists of four separate stages, each with their own purpose for the analysis:
- Planning: Compute the sample size that is required for your desired population statement.
- Selection: Select the required observations from your population.
- Execution: Annotate your data set with your assessment of the fairness of the selected observations.
- Evaluation: Make a population statement based on your annotated selection.

----

Default options
-------
### Population materiality:
- Absolute: Enter your population materiality as a monetary value.
- Relative: Enter your population materiality as a percentage relative to the total value.

### Audit Risk
- Confidence: The confidence level of the analysis. The confidence level equals the audit risk of the audit.

### How would you like to evaluate your variables?
- Audit values: When selected, you will have to annotate the selection with the observations' true values. When correct, fill in the exact same value as is stated in the book value of the transaction.
- Correct / Incorrect: When selected, you will have to annotate the selection with an indicator for whether the observations are correct (0) or incorrect (1).

----

Advanced options
-------
### Inherent risk and control risk:
- High: 100%
- Medium: 60%
- Low: 50%

When both risk assessments are set to High (100%) the audit risk model is not used to adjust the detection risk.

### Expected errors:
- Absolute: Enter your expected errors as a monetary value (e.g., $1.000 in a total balance of $1.000.000).
- Relative: Enter your expected errors as a percentage relative to the total size of the selection.

### Explanatory text:
- Enables explanatory text throughout the workflow to help you interpret the statistical results and procedure.

### Planning distribution:
- Poisson: The poisson distribution for broken taints (AICPA, 2017).
- Binomial: The infinite population binomial distribution for complete taints.
- Hypergeometric: The finite population hypergeometric distribution for complete taints.

### Selection type:
- Monetary unit sampling: Performs selection on the level of individual sampling units.
- Record sampling: Performs selection on the level of individual records.

### Selection method:
- Random sampling: Performs random selection.
- Cell sampling: Performs interval selection with randomness. Any observation that is larger than twice the interval will be selected multiple times.
- Systematic sampling: Performs interval selection. Any observation that is larger than the interval will be selected multiple times.

### Seed:
- Random number generator seed to make results reproducible. This influences which samples are drawn from the population.

### Estimation method:
- Stringer: The Stringer bound (Stringer, 1963).
    - LTA adjustment: LTA adjustment for the stringer bound to incorporate understatements (Leslie, Teitlebaum, & Anderson, 1979).

----

Default Output
-------

### Planning summary
- Materiality: The population materiality.
- Inherent risk: Risk assessment for the inherent risk.
- Control risk: Risk assessment for the control risk.
- Expected errors: The number of expected errors in the selection.
- Required sample size: The sample size that is required for your population statement.

### Selection summary:
- Sample size: The size of the selected subset.
- % of total observations: The relative size of the subset.
- % of total value: The relative value of the subset.
- Interval: The size of the interval used in the selection method.

### Evaluation summary:
- Materiality: The population materiality.
- Sample size: The size of the selected subset.
- Errors: The number of erroneous elements in the selection.
- Total taining: The sum of the proportional errors.
- x-% Confidence bound: The estimate of the maximum misstatement in percentages.
- Maximum misstatement: The estimate of the projected maximum misstatement.

----

Tables and plots
-------

### Book value descriptives
- Produces a table containing several statistics about the book values including the population size, total value, mean, standard deviation and quartiles.

### Book value distribution
- Produces a histogram of the distribution of book values in the population. Important statistics like the mean, standard deviation, and quartiles are indicated with colors.

### Decision analysis
- Produces a plot that compares all planning distributions and their corresponding sample sizes.

### Display selected observations
- Produces a table containing the selected observations along with any additional observations inserted in the corresponding field

### Selection descriptives
- Produces a table containing descriptive information about numerical variables in the selection

### Most likely error (MLE)
- Adds a cell to the evaluation summary table containing an estimate of the errors in the total population

### Evaluation information
- Produces a bar chart comparing the materiality, maximum misstatement and most likely error (MLE).

### Correlation plot
- Produces a scatter plot comparing book values of the selection against their audit values. Observations that are in error are colored in red.

----

R Packages
-------
- jfa

----

References
-------

AICPA (2017). <i>Audit Guide: Audit Sampling</i>. American Institute of Certied Public Accountants.

Derks, K (2020). jfa: Bayesian and Classical Audit Sampling. R package version 0.1.0.

Interdepartementaal Overlegorgaan Departementale Accountantsdiensten (2007). <i>Handboek Auditing Rijksoverheid 2007</i>, established by the Interdepartementaal Overlegorgaan Departementale Accountantsdiensten (IODAD) on March 28, 2006, and May 29, 2007.

Leslie, D. A., Teitlebaum, A. D., Anderson, R. J. (1979). <i>Dollar-unit Sampling: A Practical Guide for Auditors</i>. Toronto: Copp Clark Pitman.

Stringer, K.W. (1963) Practical aspects of statistical sampling in auditing. <i>Proceedings of Business and Economic Statistics Section</i>, American Statistical Association.