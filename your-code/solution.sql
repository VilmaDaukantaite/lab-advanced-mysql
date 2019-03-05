## Challenge 1 (all 3 steps)

SELECT au_id, (sum_by_title + advance_per_title) AS profits
from( 
	SELECT au_id, title_id, SUM(royalties_paid.royalties) AS sum_by_title, advance_per_title
	FROM (
		SELECT titleauthor.au_id, titleauthor.title_id, titles.title, round((titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100), 2) AS royalties, round((titles.advance * titleauthor.royaltyper / 100), 2) AS advance_per_title
	FROM titleauthor
	LEFT JOIN titles
	ON titleauthor.title_id = titles.title_id
		LEFT JOIN sales
		ON sales.title_id = titles.title_id
	) royalties_paid
	GROUP BY au_id, title_id
) final
GROUP BY au_id, profits
ORDER BY profits desc
LIMIT 3

## Challenge 2

CREATE TEMPORARY TABLE royalties_paid
SELECT titleauthor.au_id, titleauthor.title_id, titles.title, round((titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100), 2) AS royalties, round((titles.advance * titleauthor.royaltyper / 100), 2) AS advance_per_title
FROM titleauthor
LEFT JOIN titles
ON titleauthor.title_id = titles.title_id
	LEFT JOIN sales
	ON sales.title_id = titles.title_id;
		
SELECT * FROM royalties_paid;

CREATE TEMPORARY TABLE final_result
SELECT au_id, title_id, SUM(royalties) AS sum_by_title, advance_per_title
FROM royalties_paid
GROUP BY au_id, title_id, advance_per_title;

Select * From final_result;

SELECT au_id, (sum_by_title + advance_per_title) AS profits
FROM final_result
GROUP BY au_id, profits
ORDER BY profits desc
LIMIT 3;

## Challenge 3


CREATE TABLE most_profiting_authors
SELECT au_id, (sum_by_title + advance_per_title) AS profits
FROM final_result
GROUP BY au_id, profits
ORDER BY profits desc;

