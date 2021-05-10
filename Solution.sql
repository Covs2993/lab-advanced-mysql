Drop Table if exists  royalties;
CREATE TEMPORARY TABLE royalties 
SELECT titles.title_id AS Title_ID, titleauthor.au_id AS Author_ID, 
titles.price * sales.qty * (titles.royalty / 100) * ( titleauthor.royaltyper / 100) AS Royalty
FROM titleauthor 
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN sales ON titles.title_id = sales.title_id;

Drop table if exists royal_au_tit;
CREATE TEMPORARY TABLE royal_au_tit
SELECT Title_ID, Author_ID, 
SUM(Royalty) AS Royalties
FROM royalties
GROUP BY royalties.Title_ID, royalties.Author_ID;

SELECT Author_ID, titles.advance * (titleauthor.royaltyper / 100)+ Royalties AS Profit
FROM royal_au_tit
JOIN titles ON royal_au_tit.Title_ID = titles.title_id
JOIN titleauthor ON titles.title_id = titleauthor.title_id
GROUP BY royal_au_tit.Author_ID
ORDER BY Profit DESC;
 