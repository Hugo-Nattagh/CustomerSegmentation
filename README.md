# CustomerSegmentation

### Machine Learning to Find Customer Clusters with Julia

Unsupervised clustering is used to discover pattern in the data. It’s more about exploring data than solving a problem. Even when significant clusters are found, it doesn’t mean it will be useful.

The [dataset](https://archive.ics.uci.edu/ml/datasets/Online%20Retail)'s description from the source: "This is a transnational data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers."

In this script, I do data cleaning and preprocessing, as well as some feature engineering. I then use the K-Means alogrithm from the ‘Clustering’ package to find my clusters. 

K-Means is a data grouping algorithm. It delimits, without supervision and with the help of the features, some groups among the data.

The clusters are based, for a customer, on the average amount spent by purchase and the number of distinct days when a purchase was made.

![]()

This is the visualization of the results, made with Microsoft Power BI.
