# E-Commerce-Profitability-Analysis
- Author: Chau My Phuong
- Date: 6/3/2026

## SCENERIO:
I am a financial analyst at a direct-to-consumer e-commerce brand that sells products across multiple categories and channels.While top-line revenue looks healthy, the CEO suspects that not all product categories and sales channels are actually profitable once you account for shipping, returns, platform fees, and marketing costs. In this project you will perform a true profitability analysis by connecting order-level transaction data with product costs and marketing spend to find out where the company is actually making (and losing) money.

## ABOUT COMPANY:
BrightCart is an online retailer selling products across 8 categories through their website, mobile app, third-party marketplaces, and social commerce. The company did $1M+ in gross revenue over the past two years, but net margins have been shrinking. The CEO wants to know which product categories and sales channels are truly profitable after all costs, which marketing platforms are delivering the best return on ad spend, and whether the return rate is eating into margins. You have three datasets: order-level transactions, a product catalog with cost data, and monthly marketing spend by platform.

## 1. Business Problem
Although the company has generated over $1M in gross revenue over the past two years, the CEO has noticed that net profit margins have been declining. The leadership team suspects that some product categories, sales channels, and marketing platforms may not actually be profitable after considering operational costs. The objective of this project is to perform a true profitability analysis to identify where the company is making money and where it is losing money.

## Questions to Answer
- What is the average profit margin by product category? Which categories are the most and least profitable, and what is driving the difference (product cost, shipping, returns, or discounts)?
- How does profitability differ across sales channels (Website, Mobile App, Marketplace, Social Commerce)? Which channel has the best and worst profit per order after accounting for platform fees?
- What is the return rate by category and channel? Estimate how much total revenue was lost to returns over the analysis period.
- Analyze the marketing spend data: Which advertising platform delivers the best ROAS (Return on Ad Spend)? Are there any platforms where the company is spending money but not getting a positive return?
- If the CEO asked you to cut 20% of the marketing budget, which platforms and months would you recommend reducing spend on? Support your recommendation with data.

## Tech Stack
This project uses the following tools:
- SQL (MySQL) – Data querying and aggregation
- Python (Pandas, NumPy) – Data exploration and cleaning
- Excel – Data validation
- Power BI – Interactive dashboard visualization
- Google Colab / Jupyter Notebook – Analysis environment

## Project Workflow
The analysis pipeline follows the workflow below:

Raw CSV Data
      ↓
Data Import (SQL)
      ↓
Data Exploration
      ↓
Data Cleaning
      ↓
Data Modeling (Star Schema)
      ↓
SQL Analysis
      ↓
Power BI Dashboards
      ↓
Business Insights & Recommendations

### 1. Import and Explore
- Load all three CSVs.
- Verify that order-level costs add up correctly (product cost + shipping + fees = total costs).
- Check for any data quality issues.

### 2. Category Profitability
- Group orders by product category.
- Calculate total revenue, total costs, total profit, and profit margin for each.
- Identify the top and bottom performers.

### 3. Channel Analysis
- Group by sales channel.
- Compare average order value, average profit, and return rate across channels.
- Factor in platform fees for Marketplace and Social Commerce.

### 4. Marketing ROI
- Analyze the marketing spend dataset.
- Calculate ROAS, cost per acquisition, and cost per click by platform.
- Identify which platforms are underperforming.

### 5. Recommendations
- Create a one-page summary with your top 3 recommendations for improving profitability.
- Include specific numbers (e.g., cutting X platform saves $Y with minimal revenue impact).

## 1. Dataset Overview
### Raw data description
**Data set:**
- marketing_spend.csv: Monthly ad spend and engagement metrics by platform.
- orders.csv: Transaction-level data including revenue, costs, and shipping info.
- products.csv: A master catalog of products, costs, and supplier details.
### Raw data table
**marketing_spend.csv**
| Column             | Description                                                                              |
| ------------------ | ---------------------------------------------------------------------------------------- |
| month              | The reporting period in YYYY-MM format.                                                  |
| platform           | Advertising platform used for the campaign (e.g., Google Ads, Facebook Ads, TikTok Ads). |
| spend              | Total marketing budget spent on the platform during the month.                           |
| impressions        | Total number of times ads were displayed to users.                                       |
| clicks             | Number of times users clicked on the ads.                                                |
| conversions        | Number of successful actions generated from ads (e.g., purchases).                       |
| revenue_attributed | Revenue directly attributed to the marketing campaign.                                   |
| cpc                | Cost per click calculated as spend / clicks.                                    |
| cpa                | Cost per acquisition calculated as pend / conversions.                         |
| roas               | Return on Ad Spend calculated as revenue_attributed / spend.                    |


**orders.csv**
| Column           | Description                                                                |
| ---------------- | -------------------------------------------------------------------------- |
| order_id         | Unique identifier for each order transaction.                              |
| customer_id      | Unique identifier for the customer placing the order.                      |
| order_date       | Date when the order was placed.                                            |
| channel          | Sales channel where the order was made (Website, Mobile App, Marketplace). |
| payment_method   | Payment method used by the customer (Credit Card, PayPal, etc.).           |
| region           | Geographic region of the customer.                                         |
| items_ordered    | Total number of items in the order.                                        |
| primary_category | Main product category purchased in the order.                              |
| gross_revenue    | Total revenue before discounts.                                            |
| discount_pct     | Percentage discount applied to the order.                                  |
| discount_amount  | Total discount value applied to the order.                                 |
| shipping_cost    | Cost of shipping the order.                                                |
| product_cost     | Total cost of goods sold for the order.                                    |
| platform_fee     | Fee charged by marketplace or platform.                                    |
| transaction_fee  | Payment processing fee for the order.                                      |
| returned         | Indicates whether the order was returned (Yes/No).                         |
| refund_amount    | Amount refunded to the customer if the order was returned.                 |
| net_revenue      | Revenue after discounts and refunds.                                       |
| total_costs      | Sum of product_cost, shipping_cost, platform_fee, and transaction_fee.     |
| profit           | Net profit calculated as net_revenue minus total_costs.                    |

**products.csv**
| Column                 | Description                                       |
| ---------------------- | ------------------------------------------------- |
| product_id             | Unique SKU identifier for the product.            |
| product_name           | Name of the product.                              |
| category               | Main product category.                            |
| sub_category           | More specific classification within the category. |
| unit_cost              | Cost of goods sold per unit.                      |
| selling_price          | Standard retail selling price.                    |
| shipping_cost_per_unit | Shipping cost associated with each unit sold.     |
| weight_lbs             | Product weight measured in pounds.                |
| supplier               | The supplier providing the product.               |


## 2. Data cleaning
**marketing_spend.csv**
- Converted month column to date format for time-series analysis.
- Check all column value.
- Checked for missing values in spend, clicks, and conversions.
- Converted all number column to number type

**orders.csv**
- Converted order_date to date format.
- Check all column value.
- Converted all number column to number type

**products.csv**
- Checked for duplicate product_id values.
- Standardized category and sub_category naming conventions.
- Ensured unit_cost < selling_price to avoid negative margins.
- Converted weight_lbs to numeric format.
- Verified missing supplier values and replaced them with Unknown Supplier if necessary.

## 3. Data Modeling
### ERD
A star schema was designed to support efficient analysis.
**Dimension Tables**
- dim_order – Order metadata
- dim_customer – Customer information
- dim_products – Product catalog
- dim_platform – Marketing platforms

**Fact Tables**
- fact_orders_details – Transaction-level sales and cost data
- fact_marketing – Monthly marketing performance

This structure enables flexible analysis across:
- products
- customers
- channels
- marketing platforms
- time periods

### Entities description
**dim_order**

**Entity Description**: `dim_order` stores **order-level information**. Each record represents a single order and provides contextual details such as the order date and region. This dimension enables analysis of sales performance across time and geographic regions.

| Attribute     | Description                                |
| ------------- | ------------------------------------------ |
| order_id (PK) | Unique identifier for each order           |
| order_date    | Date when the order was placed             |
| region        | Geographic region where the order was made |


**dim_customer**

**Entity Description**:
`dim_customer` represents the customer dimension. Each record corresponds to a unique customer and allows sales and behavioral analysis at the customer level, such as identifying purchasing patterns and customer value.

| Attribute        | Description                         |
| ---------------- | ----------------------------------- |
| customer_id (PK) | Unique identifier for each customer |

**dim_products**

**Entity Description**:

`dim_products` contains descriptive information about the products sold. It allows analysts to evaluate sales performance by product, category, supplier, and other product attributes.

| Attribute              | Description                                           |
| ---------------------- | ----------------------------------------------------- |
| product_id (PK)        | Unique identifier for each product                    |
| supplier               | Supplier providing the product                        |
| category               | Main product category                                 |
| sub_category           | Subcategory within the main category                  |
| product_name           | Name of the product                                   |
| unit_cost              | Cost incurred to acquire or produce the product       |
| selling_price          | Price at which the product is sold                    |
| shipping_cost_per_unit | Shipping cost associated with one unit of the product |
| weight_lbs             | Product weight in pounds                              |

**fact_orders_details**

**Entity Description**: 
`fact_orders_details` is the central fact table that records **transaction-level sales data**. Each record represents a product purchased within an order. This table contains key metrics such as revenue, costs, and profit, enabling detailed sales and profitability analysis.

| Attribute        | Description                                       |
| ---------------- | ------------------------------------------------- |
| order_id (FK)    | Reference to the order in dim_order               |
| customer_id (FK) | Reference to the customer in dim_customer         |
| product_id (FK)  | Reference to the product in dim_products          |
| payment_method   | Method used to complete the payment               |
| items_ordered    | Number of product units ordered                   |
| gross_revenue    | Total revenue before discounts and costs          |
| discount_pct     | Percentage discount applied                       |
| discount_amount  | Total discount value applied to the order         |
| shipping_cost    | Shipping cost for the order                       |
| platform_fee     | Fee charged by the sales platform                 |
| transaction_fee  | Payment processing fee                            |
| returned         | Indicator showing whether the item was returned   |
| refund_amount    | Amount refunded to the customer                   |
| net_revenue      | Revenue after discounts and refunds               |
| total_costs      | Total operational costs associated with the order |
| profit           | Net profit generated from the order               |

**dim_platform**

**Entity Description**:
`dim_platform` stores information about marketing platforms used for advertising campaigns. It allows marketing performance to be analyzed by advertising platform.

| Attribute     | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| platform (PK) | Name of the marketing platform (e.g., Google, Facebook, TikTok) |

**fact_marketing**

**Entity Description**:
`fact_marketing` records aggregated marketing performance metrics by platform and month. It enables analysis of advertising efficiency, campaign effectiveness, and return on investment across different marketing channels.

| Attribute          | Description                                  |
| ------------------ | -------------------------------------------- |
| platform (FK)      | Reference to the marketing platform          |
| month              | Month of the marketing campaign              |
| spend              | Total marketing spend during the month       |
| impressions        | Number of times the ad was displayed         |
| clicks             | Number of ad clicks                          |
| conversions        | Number of successful conversions generated   |
| revenue_attributed | Revenue attributed to the marketing campaign |
| cpc                | Cost per click                               |
| cpa                | Cost per acquisition                         |
| roas               | Return on ad spend                           |

## 4. Visualisation and Insight
**Dashboard Overview**

The analysis results are presented in Power BI dashboards. Main dashboards include:
- Business Overview Dashboard
- Marketing Performance Dashboard
- Product & Sales Detail Dashboard
- Customer Insights Dashboard

**Key Metric**
- Revenue = Gross Revenue - Discounts
- Net Revenue = Gross Revenue - Discounts - Refunds
- Profit = Net Revenue - Total Costs
- Profit Margin = Profit / Net Revenue
- ROAS = Revenue Attributed / Marketing Spend
- Return Rate = Returned Orders / Total Orders

### Overview Dashboard 
**Key Insights**
- The business generated $236.88K in net revenue and $56.54K in profit, resulting in an overall profit margin of ~24%.
- Electronics is the largest revenue contributor ($70K+), but also shows the highest return rate (24.2%), which significantly impacts profitability.
- Home & Kitchen and Food & Beverage categories demonstrate more stable profit margins, suggesting stronger operational efficiency.
- Several products show 100% return rates, indicating potential product quality issues or mismatched customer expectations.

**Business Recommendation**
- Focus on reducing return rates in Electronics and reviewing unprofitable SKUs to improve overall margins.

### Category & Product Performance
**Key Insights**
- Electronics leads in revenue but suffers from the highest return rate, which reduces its profit contribution.
- Home & Kitchen and Food & Beverage generate consistent profit with relatively low return rates, making them reliable revenue drivers.
- Certain SKUs show negative profit and extremely high return rates, highlighting possible problems with product quality, pricing strategy, or supplier reliability.

**Business Recommendation**
- Prioritize marketing and inventory for high-margin categories, while reviewing or discontinuing low-performing products.
### Channel Performance Analysis
**Key Insights**
- Mobile App generates the highest profit per order (~$36), indicating strong customer engagement and higher purchasing intent.
- Website also performs well with stable revenue and profit margins.
- Marketplace channels show lower profit per order (~$15) due to platform fees and higher competitive pricing.
- Social Commerce provides moderate profitability but relies heavily on marketing efforts.

**Business Recommendation**
- Shift customer acquisition toward owned channels (Mobile App & Website) to maximize profitability and reduce dependency on marketplaces.

### Marketing & Customer Insights
**Key Insights**
- Total marketing spend reached $503K, generating $12.75M in attributed revenue, with an overall ROAS of 2.29.
- Influencer Marketing and Google Ads demonstrate higher marketing efficiency and strong conversion potential.
- Email Marketing shows high spending but comparatively lower efficiency, suggesting diminishing returns.
- Revenue is highly concentrated among VIP and Loyal customers, who generate significantly higher profit margins than standard customers.

**Business Recommendation**
- Optimize marketing allocation toward high-performing channels and develop loyalty programs targeting high-value customers.

### Overall Strategic Insights
1. Focus on profitable categories

- Promote:
    * Home & Kitchen
    * Food & Beverage
    * Electronics

2. Grow Mobile App channel

- Mobile app users have:
    * higher profit per order
    * better loyalty

3. Reduce product returns

- Improve:
    * product descriptions
    * size guides
    * product quality


4. Optimize marketing budget

- Best platforms:
    * Influencer
    * Google Ads
    * Instagram Ads

- Reduce spending on:
    * TikTok Ads
    * Email Marketing

5. Invest in loyal customers
- High-value segments drive most profit.
- Introduce:
    * VIP rewards
    * loyalty programs
    * personalized marketing

## Project Value
This project demonstrates how data analytics can support business decisions by:
- Identifying profitable products and channels
- Optimizing marketing budget allocation
- Reducing operational inefficiencies
- Improving customer retention strategies
- The insights generated help leadership maximize profitability while maintaining revenue growth.