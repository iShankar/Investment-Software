##  Stock Metrics Software

Books and Tutorials tend to use examples such as Amazon, Yahoo, and Google to showcase the effectiveness of different metrics. 
Here I will use dividend paying stocks that are well known, but undervalued at present, since my goal is to use these metrics to
improve buy/sell signals for such stocks.  My first learn-along example does use Amazon, but I have also added IBM to that example, 
which is at present an undervalued large cap stock which pays dividends. Dividend paying stocks use the 'Adjusted' stock price
instead of the 'Close' price, since the stock price is impacted by the dividend payments. A dividend payment is declared for a near 
future payment date. Ex-dividend date, or ex-date, typically one week after the declaration date is  of significance. Stock price entries
for the 'Close' and 'Adjusted' categories match after the ex-date, but would have the 'Adjusted' lower by about the dividend amount
relative to the 'Close' value. Any return calculated post ex-date will be higher by that amount. 

So, **use the 'Adjusted' price for calculating the return (for dividend paying stocks)**. The 'Adjusted' close price for prior periods
changers after each dividend payment (same for stock splits). So, a future download of data may not match with an earlier date data
(but returns calculated will be correct).

The zoo class, implemented with the 'zoo' package, is designed to handle time series data with an arbitrary ordered time index (or irregular time series). The original ts class, used in R for representing a time series, is inadequate for representing financial data, which is not regularly spaced (stock market runs M through F, and not on Sa, Su, and holidays). The zoo class is ideal for that. Note: Data stored in a data.frame is not supported by zoo. It needs to be converted to a matrix, and then to a zoo object. Here is a [reference](https://faculty.washington.edu/ezivot/econ424/Working%20with%20Time%20Series%20Data%20in%20R.pdf). 

