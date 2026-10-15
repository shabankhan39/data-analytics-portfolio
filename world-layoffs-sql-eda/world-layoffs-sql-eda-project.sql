-- Exploratory Data Analysis

SELECT * from layoffs_stagging2;

Select year(`date`),sum(total_laid_off ) as total_laid_off
from layoffs_stagging2
group by  year(`date`)
order by 1 desc;

Select country,sum(total_laid_off ) as total_laid_off
from layoffs_stagging2
group by country
order by 2 desc;


Select country,year(`date`),sum(total_laid_off ) as total_laid_off
from layoffs_stagging2
group by country, year(`date`)
order by 1,2;


SELECT substring(`date`,1,7) AS `MONTH`, sum(total_laid_off) total_laid_off, SUM(sum(total_laid_off)) OVER (order by substring(`date`,1,7)) as Rolling_Total
from layoffs_stagging2
where substring(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1;

-- With CTE

with rolling_total
as
(SELECT substring(`date`,1,7) AS `MONTH`, sum(total_laid_off) total_laid_off
from layoffs_stagging2
where substring(`date`,1,7) IS NOT NULL
group by `MONTH`
order by 1)
SELECT `MONTH`,total_laid_off, SUM(total_laid_off) OVER (order by `MONTH`) as rolling_total
from rolling_total;



with Company_Year as(

SELECT 
company, year(`date`) as Years,sum(total_laid_off) as total_laid_offs
from layoffs_stagging2
group by company , year(`date`)
), 
Company_Ranking AS(
select *,
dense_rank() over(partition by Years order by total_laid_offs desc) as Rankings
from Company_Year
where Years IS NOT NULL
)
Select * from 
Company_Ranking
where Rankings<=5;