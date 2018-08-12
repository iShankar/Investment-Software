SEC letter has been used as a screening tool for a [study](http://web.nacva.com/JFIA/Issues/JFIA-2010-2_12.pdf) on fraudulent behavior by companies. In my SIP-Excel-R process, I have developed a Fraud Score ( 0 to 5). The intent is to determine if any of the companies that pass the criteria of Pat O'S Millenial Portfolio have a high fraud score and if so, is there an SEC letter in their immediate past? If so, expect that the company will underperform and exclude from the portfolio. 

Here are some URLs at SEC that are relevant: [How to Search EDGAR for correspondence](https://www.sec.gov/answers/edgarletters.htm), [Accessing Edgar Data](https://www.sec.gov/edgar/searchedgar/accessing-edgar-data.htm), and [Full Text Search](https://searchwww.sec.gov/EDGARFSClient/jsp/EDGAR_MainAccess.jsp?search_text=comment%20letters&isAdv=false). 

Some images are included here that show the process:

The image below shows an advanced search for Unisys. The Upload on 10/2016 shows that SEC has some balance sheet concerns. Subsequent Corresp from Unisys clarifies. The matter was resolved in 2/2017 with an upload from SEC. 
![alt text](https://github.com/iShankar/Investment-Software/blob/master/images/SEC%20Comment%20letter%20search.png)

The image below shows communication about a trade with a foreign country on a US watch list. Abbott showed in their response that the amount of trade was less than 0.01% of its total global trade. 
![alt text](https://github.com/iShankar/Investment-Software/blob/master/images/SEC%20Full%20Text%20Search%20example.png)

In summary: Use 'corresp' for company's responses and 'UPLOAD' for SEC's queries. As the process is bureaucratic, Look at the latest set for some final decision if any. On many an occasion, it is a harmless correspondence for certain clarifications. But in some cases, it is clear that there are serious discrepancies. 

Start from the Full Text Search page [here](https://searchwww.sec.gov/EDGARFSClient/jsp/EDGAR_MainAccess.jsp?search_text=comment%20letters&isAdv=false). Enter 'corresp or UPLOAD' and click on 'Advanced search page' button. Enter company's name (not Tikcer) and date range. It will help narrow the search as shown in one of the images above. 

If I can download the entire archive for a given date range (seems possible), then I should be able to do an automated R search for the list of companies with such letters. Next action step. 

Interesting info about crowdfunding: https://www.sec.gov/dera/data/crowdfunding-offerings-data-sets. 
