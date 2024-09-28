### Cleaning and Exploratory Analysis - full project

## Steps I took and findings:

# First I will be cleaning the data and for that I will do the following:
1. Remove duplicates
2. Standardize the data
3. Null values or blank values
4. Remove any columns
# Then I will be performing exploratory data analysis on the cleaned version of this data to find trends and patterns by running different queries.



## Cleaning Data:

-- I will make another table bcz I dont wanna change the original data.

-- duplicated rows deleted.

-- standardizing data: 

-- I will now be trimming spaces


-- Now I will be standardizing the names of industries

-- Now, fixing format of date

-- Now, working with null and blank values

-- There is no row for Bally where the industry is not null to populate.

-- Deleting null rows where there are no lay offs.

-- Now, I will delete the extra column I initially created.

-- Data has been cleaned.

-- Next I will be performing exploratory data analysis using this cleaned data to find trends and patterns by running different queries.


### Exploratory Data Analysis

-- I will now look at the maximum laid off and mainly companies that laid all their staff off.

-- So, maximum laid off is 12,000 by Google and 2nd largest laid off is 10,000 by Microsaoft.

-- Now I will look at companies that laid all their staff off

-- So, companies 1.Britishvolt, 2.EMX Digital, 3.Openpay laid all their staff off and all in the first 2 months of 2023.

-- Now I will look at the fundings these companies raised.

-- Out of these companies, Britishvolt got the most funding which is 2.4 billion.

-- Now I will look at the lay off companywise.

-- now i will look at dates when these companies laid off to find trends.

-- So the layoff date starts from March of 2020, which is around the same time when covid hit and the ending date is almost exactly 3 years later i.e, March 2023.

-- Now, I will look at what industry had the most impact of covid in terms of layoffs.

-- So, comsumer and retail industry had the most layoffs which makes sense.

-- The industry that were not impacted a lot are manufacturing with only 20 layoffs and fintech with only 215 layoffs.

-- Now I will look at the layoffs impact on different countries.

-- United states had the most layoffs according to the data available. Next is India where people lost most jobs.alter

-- Now I wanna look at dates and when exactly the layoffs happened.alter

-- So the most layoffs i.e, 16,171 happened in January 2023

-- I will now look at the years.

-- So, 2022 had the most layoffs i.e, 160,661. 
-- In 2023, just in the first 3 months, 125,677 people were laid off. So, if we got the data of the full 2023 year, it would most likely be even more than 2022.

-- Now I will look at the stages that the reported companies are in

-- So, post IPOs had the most layoffs. These are the large companies.

-- Now, I will look at average percentages.

-- Now I wanna look at the progression of lay offs and I will use rolling sum for that.

-- I will do this based on the months.

-- Now I want rolling sum of this.

-- 2021 year looks good comparitively. 2022, around 150,000 which is a lot.

-- So, October 2022 to January 2023 were the worst months in terms of lay off impact.

-- Now I wanna look at rolling total while also looking at companies.

-- Now I wanna look at the layoffs companywise and per year.

-- So, in 2020, UBER laid off most of the people i.e, 7,525. In 2021, bytedance laid off most people i.e, 3,600.In 2022, Meta laid off most people i.e, 11,000. In 2023, Google laid off most people i.e, 12,000.












