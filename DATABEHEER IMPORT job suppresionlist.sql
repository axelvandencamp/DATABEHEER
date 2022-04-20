------------------------------------------------
--aanmaak temptabel [_av_temp_suppressionlist]
------------------------------------------------
DROP TABLE marketing._av_temp_suppressionlist;
CREATE TABLE marketing._av_temp_suppressionlist
	(EmailAddress text,
	 Date text,
	 Reason text,
	 dummy text);
	 
--SELECT DISTINCT reason FROM marketing._av_temp_suppressionlist;	 
	 