USE purchasingRecord;


/*----------------------------------------------------
                 계열사간거래 대상 
----------------------------------------------------*/ 

CREATE TABLE #BETWEEN_COMPANY (
KEY_CODE VARCHAR(30),
공급유형 VARCHAR(20), 
실공급처코드 VARCHAR(20),
실공급처명 VARCHAR(50))

GO

INSERT INTO #BETWEEN_COMPANY
SELECT DISTINCT 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS KEY_CODE, IIF(공급처명 LIKE '%지에프에스%', 'GFS매출', '구매대행') AS 공급유형, 
                IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS 실공급처코드 , IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) AS 실공급처명

FROM (SELECT * FROM GR_2020 UNION ALL SELECT * FROM GR_2019) A

WHERE  (IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%삼립%' 
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%파리크%' 
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%에스피엘%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%샤니%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%비알%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%밀다원%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%그릭%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%호진지리%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%에그팜%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%비앤에스%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%설목%'
OR IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%샌드팜%'
)
AND 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) NOT IN ('A100>10271','B100>10568','B100>11832','E100>15224')

ORDER BY 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드);

GO


/*----------------------------------------------------
                 외자 공급유형 테이블
----------------------------------------------------*/ 


-- SL 외자식별
CREATE TABLE #IMPORT_VENDOR 
(
KEY_CODE VARCHAR(30), 
실공급처코드 VARCHAR(20),
실공급처명 VARCHAR(100),
공급유형 VARCHAR(20)
);

GO

INSERT INTO #IMPORT_VENDOR SELECT DISTINCT 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS KEY_CODE,  IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS 실공급처코드 , 
                IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) AS 실공급처명, IIF(공급처명 LIKE '%지에프에스%', 'GFS매출', '구매대행') AS 공급유형
FROM (SELECT * FROM GR_2020 UNION ALL SELECT * FROM GR_2019) A 
WHERE IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) LIKE '%수입품정산%' AND 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) NOT IN ('A100>10271','B100>10568','B100>11832','E100>15224');

GO

-- PC, BR 외자식별

INSERT INTO #IMPORT_VENDOR SELECT DISTINCT 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS KEY_CODE,  IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS 실공급처코드 , 
                IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) AS 실공급처명, IIF(공급처명 LIKE '%지에프에스%', 'GFS매출', '구매대행') AS 공급유형
FROM (SELECT * FROM GR_2020 UNION ALL SELECT * FROM GR_2019) A 
WHERE 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) LIKE 'PC00>2%' OR 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) LIKE 'SP00>2%' 
OR 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) LIKE 'BR00>2%' OR 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) LIKE '1000>2%';

GO


/*----------------------------------------------------
                    FILTERED DATA
----------------------------------------------------*/ 

CREATE TABLE #FILTERED_SUM_DATA_TABLE 
(
KEY_CODE VARCHAR(20),
KEY_CODE2 VARCHAR(20), 
고객사코드 VARCHAR(10),
계열사품목코드 VARCHAR(20),
실공급업체코드 VARCHAR(10),
실공급업체명 VARCHAR(100), 
공급유형 VARCHAR(20), 
내외자구분 VARCHAR(10),
입고단위 VARCHAR(10),
입고월 VARCHAR(20),
구매수량 FLOAT,
구매금액 FLOAT
);

GO

CREATE TABLE #ASSIGN_BUYER_TABLE
(
ROW_NUM INT,
KEY_CODE2 VARCHAR(20),
담당자부서 VARCHAR(30),
담당자성명 VARCHAR(20),
입고일자 DATE
);

CREATE TABLE #RECENT_PRODUCT_NAME_TABLE
(
ROW_NUM INT,
KEY_CODE2 VARCHAR(20),
품명 VARCHAR(100),
입고일자 DATE
);

GO

CREATE TABLE #RECENT_CATE_NAME_TABLE
(
ROW_NUM INT,
KEY_CODE2 VARCHAR(20),
카테고리 VARCHAR(100),
입고일자 DATE
);

GO

CREATE TABLE #RESULT_TEMP_TABLE
(
KEY_CODE VARCHAR(20), 
KEY_CODE2 VARCHAR(20), 
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
품명 VARCHAR(100),
실공급업체코드 VARCHAR(10), 
실공급업체명 VARCHAR(100), 
공급유형 VARCHAR(20), 
내외자구분 VARCHAR(10), 
입고단위 VARCHAR(10), 
입고월 VARCHAR(20), 
구매수량 FLOAT, 
구매금액 FLOAT, 
담당자부서 VARCHAR(30), 
담당자성명 VARCHAR(20)
);

GO

CREATE TABLE #RESULT_TABLE
(
KEY_CODE VARCHAR(20), 
KEY_CODE2 VARCHAR(20), 
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
품명 VARCHAR(100),
실공급업체코드 VARCHAR(10), 
실공급업체명 VARCHAR(100), 
공급유형 VARCHAR(20), 
내외자구분 VARCHAR(10), 
입고단위 VARCHAR(10), 
입고월 VARCHAR(20), 
구매수량 FLOAT, 
구매금액 FLOAT, 
담당자부서 VARCHAR(30), 
담당자성명 VARCHAR(20),
카테고리 VARCHAR(100)
);

GO

WITH FILTERED_SUM_DATA AS 
(
SELECT 
    고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%',실공급처코드, 공급처코드) AS KEY_CODE,  고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 
    고객사코드, 계열사품목코드, IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) AS 실공급업체코드, 
    IIF(공급처명 LIKE '%지에프에스%', 실공급처명, 공급처명) AS 실공급업체명, IIF(공급처명 LIKE '%지에프에스%', 'GFS매출', '구매대행') AS 공급유형,
	IIF((고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) IN (SELECT KEY_CODE FROM #IMPORT_VENDOR)), '외자','내자') AS 내외자구분, 
	입고단위, 입고일자, 입고수량, 입고금액 
FROM 
    (SELECT 고객사코드, 계열사품목코드, 공급처코드, 공급처명, 실공급처코드, 실공급처명, 입고일자, 입고단위, 입고금액, 입고수량 FROM GR_2020
	UNION ALL 
	SELECT 고객사코드, 계열사품목코드, 공급처코드, 공급처명, 실공급처코드, 실공급처명, 입고일자, 입고단위, 입고금액, 입고수량 FROM GR_2019) A
WHERE 
    고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) NOT IN (SELECT KEY_CODE FROM #BETWEEN_COMPANY) 
    AND 계열사품목코드 <> '7777777777' AND 고객사코드 <> 'SM00' 
    AND 고객사코드 + '>' +IIF(공급처명 LIKE '%지에프에스%', 실공급처코드, 공급처코드) NOT LIKE 'SL00>7%' AND 계열사품목코드 <> '' 
) 
INSERT INTO #FILTERED_SUM_DATA_TABLE 
SELECT 
    KEY_CODE, KEY_CODE2, 고객사코드, 계열사품목코드, 실공급업체코드, 실공급업체명, 공급유형, 내외자구분, 입고단위, 
    CONCAT(YEAR(입고일자), '-', MONTH(입고일자)) AS 입고월, SUM(입고수량) AS 구매수량, SUM(입고금액) AS 구매금액 
FROM 
    FILTERED_SUM_DATA
GROUP BY 
    KEY_CODE, KEY_CODE2, 고객사코드, 계열사품목코드, 실공급업체코드, 실공급업체명, 공급유형, 내외자구분, 입고단위, YEAR(입고일자), MONTH(입고일자)

GO

WITH ASSIGN_BUYER AS
(
SELECT 
    ROW_NUMBER()OVER(PARTITION BY 고객사코드, 계열사품목코드 ORDER BY 입고일자 DESC) AS ROW_NUM, 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 
	담당자부서, 담당자성명, 입고일자

FROM 
    (SELECT 고객사코드, 계열사품목코드, 담당자성명, 담당자부서, 입고일자 FROM GR_2020 WHERE 계열사품목코드 <> '' AND 고객사코드 <> 'SM00' 
     AND 계열사품목코드 <> '' AND 계열사품목코드 <> '7777777777'
     
	 UNION ALL 
	 
	 SELECT 고객사코드, 계열사품목코드, 담당자성명, 담당자부서, 입고일자 FROM GR_2019  WHERE 계열사품목코드 <> '' AND 고객사코드 <> 'SM00' 
	 AND 계열사품목코드 <> '' AND 계열사품목코드 <> '7777777777') A
)

INSERT INTO #ASSIGN_BUYER_TABLE 
SELECT * 
FROM ASSIGN_BUYER WHERE ROW_NUM = 1;


WITH RECENT_PRODUCT_NAME AS  
(
SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 계열사품목코드 ORDER BY 입고일자 DESC) AS ROW_NUM, 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 품명, 입고일자 
FROM (SELECT 고객사코드, 계열사품목코드, 품명, 입고일자 FROM GR_2020 WHERE 계열사품목코드 <> '' AND 고객사코드 <> 'SM00' AND 계열사품목코드 <> '' AND 계열사품목코드 <> '7777777777'
      UNION ALL 
	  SELECT 고객사코드, 계열사품목코드, 품명, 입고일자 FROM GR_2019  WHERE 계열사품목코드 <> '' AND 고객사코드 <> 'SM00' AND 계열사품목코드 <> '' AND 계열사품목코드 <> '7777777777') A
) INSERT INTO #RECENT_PRODUCT_NAME_TABLE SELECT * FROM RECENT_PRODUCT_NAME WHERE ROW_NUM = 1;

GO

WITH RECENT_CATE_NAME AS  
(
SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 계열사품목코드 ORDER BY 입고일자 DESC) AS ROW_NUM, 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 카테고리, 입고일자 
FROM (SELECT 고객사코드, 계열사품목코드, 카테고리, 입고일자 FROM GR_2020 WHERE 계열사품목코드 <> '' AND 고객사코드 <> 'SM00' AND 계열사품목코드 <> '' AND 계열사품목코드 <> '7777777777'
      UNION ALL 
	  SELECT 고객사코드, 계열사품목코드, 카테고리, 입고일자 FROM GR_2019  WHERE 계열사품목코드 <> '' AND 고객사코드 <> 'SM00' AND 계열사품목코드 <> '' AND 계열사품목코드 <> '7777777777') A
) INSERT INTO #RECENT_CATE_NAME_TABLE SELECT * FROM RECENT_CATE_NAME WHERE ROW_NUM = 1;

GO

WITH RESULT_TEMP_TABLE AS (
SELECT A.KEY_CODE, A.KEY_CODE2, A.고객사코드, A.계열사품목코드, A.실공급업체코드, A.실공급업체명, A.공급유형, A.내외자구분, A.입고단위, A.입고월, A.구매수량, A.구매금액, B.담당자부서, B.담당자성명 
FROM #FILTERED_SUM_DATA_TABLE A LEFT JOIN #ASSIGN_BUYER_TABLE B ON A.KEY_CODE2 = B.KEY_CODE2) 
INSERT INTO #RESULT_TEMP_TABLE SELECT A.KEY_CODE, A.KEY_CODE2, A.고객사코드, A.계열사품목코드, B.품명, A.실공급업체코드, A.실공급업체명, A.공급유형, A.내외자구분, A.입고단위, A.입고월, A.구매수량, A.구매금액, A.담당자부서, A.담당자성명
FROM RESULT_TEMP_TABLE A LEFT JOIN #RECENT_PRODUCT_NAME_TABLE B ON A.KEY_CODE2 = B.KEY_CODE2;

WITH RESULT_TABLE AS (
SELECT A.KEY_CODE, A.KEY_CODE2, A.고객사코드, A.계열사품목코드, A.품명, A.실공급업체코드, A.실공급업체명, A.공급유형, A.내외자구분, A.입고단위, A.입고월, A.구매수량, A.구매금액, A.담당자부서, A.담당자성명, B.카테고리 
FROM #RESULT_TEMP_TABLE A LEFT JOIN #RECENT_CATE_NAME_TABLE B ON A.KEY_CODE2 = B.KEY_CODE2) 
INSERT INTO #RESULT_TABLE SELECT * FROM RESULT_TABLE


-- DROP TABLE MONTHLY_GR_LIST;
GO
CREATE TABLE MONTHLY_GR_LIST
(
KEY_CODE VARCHAR(20), 
KEY_CODE2 VARCHAR(20), 
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
품명 VARCHAR(100),
실공급업체코드 VARCHAR(10), 
실공급업체명 VARCHAR(100), 
공급유형 VARCHAR(20), 
내외자구분 VARCHAR(10), 
입고단위 VARCHAR(10), 
입고월 VARCHAR(20), 
구매수량 FLOAT, 
구매금액 FLOAT, 
담당자부서 VARCHAR(30), 
담당자성명 VARCHAR(20),
카테고리 VARCHAR(100)
);

GO

INSERT INTO MONTHLY_GR_LIST SELECT * FROM #RESULT_TABLE


GO 


/*----------------------------------------------------
            품목별 단가 평균 데이터 생성
----------------------------------------------------*/ 

CREATE TABLE #UNIT_AVG_RECENT_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
입고월 VARCHAR(20),
구매단가 FLOAT
);

GO


CREATE TABLE #UNIT_AVG_RECENT_3MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_6MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_12MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_THIS_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_LAST_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20),
구매단가 FLOAT
);

GO


-- 최근 월 구매단가 평균 

-- 입고월이 문자열이기 때문에, 10월부터는 DESC 에 유의해야함!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 계열사품목코드 ORDER BY 입고월 DESC) AS ROW_NUM,
        고객사코드 +'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, 입고월,
		구매금액, 구매수량
 FROM MONTHLY_GR_LIST)

INSERT INTO #UNIT_AVG_RECENT_PROD 

SELECT KEY_CODE2, 고객사코드, 계열사품목코드, 입고월 AS 최종입고월, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, 고객사코드, 계열사품목코드, 입고월

GO

-- 최근 3개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_3MONTH_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5')

GROUP BY 고객사코드, 계열사품목코드

GO

-- 최근 6개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_6MONTH_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY 고객사코드, 계열사품목코드


GO

-- 최근 12개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_12MONTH_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY 고객사코드, 계열사품목코드

GO

-- 금년 구매단가 평균 
INSERT INTO #UNIT_AVG_THIS_YEAR_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2020'

GROUP BY 고객사코드, 계열사품목코드

GO

-- 전년 구매단가 평균 
INSERT INTO #UNIT_AVG_LAST_YEAR_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2019'

GROUP BY 고객사코드, 계열사품목코드



/*----------------------------------------------------
           품목별 수량 평균 데이터 생성
----------------------------------------------------*/ 

CREATE TABLE #QTY_AVG_RECENT_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
입고월 VARCHAR(20),
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_3MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_6MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_12MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_THIS_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_LAST_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
고객사코드 VARCHAR(10), 
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

-- 최근 월 구매수량 평균 

-- 입고월이 문자열이기 때문에, 10월부터는 DESC 에 유의해야함!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 계열사품목코드 ORDER BY 입고월 DESC) AS ROW_NUM,
        고객사코드 +'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, 입고월,
		구매금액, 구매수량
 FROM MONTHLY_GR_LIST)

INSERT INTO #QTY_AVG_RECENT_PROD 

SELECT KEY_CODE2, 고객사코드, 계열사품목코드, 입고월 AS 최종입고월, AVG(구매수량) AS 구매수량

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, 고객사코드, 계열사품목코드, 입고월

GO

-- 최근 3개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_3MONTH_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5')

GROUP BY 고객사코드, 계열사품목코드

GO

-- 최근 6개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_6MONTH_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY 고객사코드, 계열사품목코드


GO

-- 최근 12개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_12MONTH_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY 고객사코드, 계열사품목코드

GO

-- 금년 구매수량 평균 
INSERT INTO #QTY_AVG_THIS_YEAR_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2020'

GROUP BY 고객사코드, 계열사품목코드

GO

-- 전년 구매수량 평균 
INSERT INTO #QTY_AVG_LAST_YEAR_PROD
SELECT 고객사코드+'>'+계열사품목코드 AS KEY_CODE2, 고객사코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2019'

GROUP BY 고객사코드, 계열사품목코드




/*----------------------------------------------------
------------공급처별 단가 평균 데이터 생성--------------
----------------------------------------------------*/ 


CREATE TABLE #UNIT_AVG_RECENT_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
입고월 VARCHAR(20),
구매단가 FLOAT
);

GO


CREATE TABLE #UNIT_AVG_RECENT_3MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_6MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_12MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_THIS_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_LAST_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20),
구매단가 FLOAT
);

GO

-- 최근 월 구매단가 평균 

-- 입고월이 문자열이기 때문에, 10월부터는 DESC 에 유의해야함!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 실공급업체코드 ORDER BY 입고월 DESC) AS ROW_NUM,
        고객사코드 +'>'+실공급업체코드 AS KEY_CODE2, 고객사코드, 실공급업체코드, 입고월,
		구매금액, 구매수량
 FROM MONTHLY_GR_LIST)

INSERT INTO #UNIT_AVG_RECENT_VENDOR 

SELECT KEY_CODE2, 고객사코드, 실공급업체코드, 입고월 AS 최종입고월, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, 고객사코드, 실공급업체코드, 입고월

GO


-- 최근 3개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_3MONTH_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5')

GROUP BY 고객사코드, 실공급업체코드

GO

-- 최근 6개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_6MONTH_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY 고객사코드, 실공급업체코드


GO

-- 최근 12개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_12MONTH_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY 고객사코드, 실공급업체코드

GO

-- 금년 구매단가 평균 
INSERT INTO #UNIT_AVG_THIS_YEAR_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2020'

GROUP BY 고객사코드, 실공급업체코드

GO

-- 전년 구매단가 평균 
INSERT INTO #UNIT_AVG_LAST_YEAR_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2019'

GROUP BY 고객사코드, 실공급업체코드



/*----------------------------------------------------
-------------공급처별 수량 평균 데이터 생성-------------
----------------------------------------------------*/ 

CREATE TABLE #QTY_AVG_RECENT_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
입고월 VARCHAR(20),
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_3MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_6MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_12MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_THIS_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_LAST_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

-- 최근 월 구매수량 평균 

-- 입고월이 문자열이기 때문에, 10월부터는 DESC 에 유의해야함!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 실공급업체코드 ORDER BY 입고월 DESC) AS ROW_NUM,
        고객사코드 +'>'+실공급업체코드 AS KEY_CODE2, 고객사코드, 실공급업체코드, 입고월,
		구매금액, 구매수량
 FROM MONTHLY_GR_LIST)

INSERT INTO #QTY_AVG_RECENT_VENDOR

SELECT KEY_CODE2, 고객사코드, 실공급업체코드, 입고월 AS 최종입고월, AVG(구매수량) AS 구매수량

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, 고객사코드, 실공급업체코드, 입고월

GO

-- 최근 3개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_3MONTH_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5')

GROUP BY 고객사코드, 실공급업체코드

GO

-- 최근 6개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_6MONTH_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY 고객사코드, 실공급업체코드


GO

-- 최근 12개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_12MONTH_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY 고객사코드, 실공급업체코드

GO

-- 금년 구매수량 평균 
INSERT INTO #QTY_AVG_THIS_YEAR_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2020'

GROUP BY 고객사코드, 실공급업체코드

GO

-- 전년 구매수량 평균 
INSERT INTO #QTY_AVG_LAST_YEAR_VENDOR
SELECT 고객사코드+'>'+실공급업체코드 AS KEY_CODE, 고객사코드, 실공급업체코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2019'

GROUP BY 고객사코드, 실공급업체코드;


/*----------------------------------------------------
-------------      요약 데이터 생성      -------------
----------------------------------------------------*/ 


-- 품목별 리스트 

WITH TEMP_REPORT AS
(

SELECT DISTINCT A.KEY_CODE2, A.고객사코드, A.계열사품목코드, A.품명, A.카테고리,A.담당자부서,A.담당자성명, A.내외자구분, A.입고단위, 

	AB.구매단가 AS UNIT_AVG_LAST_YEAR_PROD, 
	AC.구매단가 AS UNIT_AVG_THIS_YEAR_PROD, 
	AD.구매단가 AS UNIT_AVG_RECENT_3MONTH_PROD, 
	AE.구매단가 AS UNIT_AVG_RECENT_6MONTH_PROD, 
	AF.구매단가 AS UNIT_AVG_RECENT_12MONTH_PROD, 
	AG.구매단가 AS UNIT_AVG_RECENT_PROD,

	AH.구매수량 AS QTY_AVG_LAST_YEAR_PROD,
	AI.구매수량 AS QTY_AVG_THIS_YEAR_PROD,
	AJ.구매수량 AS QTY_AVG_RECENT_3MONTH_PROD,
	AK.구매수량 AS QTY_AVG_RECENT_6MONTH_PROD,
	AL.구매수량 AS QTY_AVG_RECENT_12MONTH_PROD,
	AM.구매수량 AS QTY_AVG_RECENT_PROD

FROM MONTHLY_GR_LIST A 
    
	LEFT JOIN #UNIT_AVG_LAST_YEAR_PROD AB ON A.KEY_CODE2 = AB.KEY_CODE2             -- 품목별 전년 평균단가
	LEFT JOIN #UNIT_AVG_THIS_YEAR_PROD AC ON A.KEY_CODE2 = AC.KEY_CODE2             -- 품목별 금년 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_3MONTH_PROD AD ON A.KEY_CODE2 = AD.KEY_CODE2        -- 품목별 최근 3개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_6MONTH_PROD AE ON A.KEY_CODE2 = AE.KEY_CODE2        -- 품목별 최근 6개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_12MONTH_PROD AF ON A.KEY_CODE2 = AF.KEY_CODE2       -- 품목별 최근 12개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_PROD AG ON A.KEY_CODE2 = AG.KEY_CODE2                -- 품목별 최근 입고 단가
	
	LEFT JOIN #QTY_AVG_LAST_YEAR_PROD AH ON A.KEY_CODE2 = AH.KEY_CODE2              -- 품목별 전년 평균 수량
	LEFT JOIN #QTY_AVG_THIS_YEAR_PROD AI ON A.KEY_CODE2 = AI.KEY_CODE2              -- 품목별 금년 평균 수량
	LEFT JOIN #QTY_AVG_RECENT_3MONTH_PROD AJ ON A.KEY_CODE2 = AJ.KEY_CODE2         -- 품목별 최근 3개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_6MONTH_PROD AK ON A.KEY_CODE2 = AK.KEY_CODE2         -- 품목별 최근 6개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_12MONTH_PROD AL ON A.KEY_CODE2 = AL.KEY_CODE2        -- 품목별 최근 12개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_PROD AM ON A.KEY_CODE2 = AM.KEY_CODE2                 -- 품목별 최근 입고 수량 

)
SELECT 
	KEY_CODE2, 고객사코드, 계열사품목코드, 품명, 카테고리, 담당자부서,담당자성명, 내외자구분, 입고단위,

	
	/*----------------------------------------------------
	                  품목별 증감 데이터 
	----------------------------------------------------*/ 

	-- 전년평균 VS 금년평균
	IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0,ROUND( (QTY_AVG_THIS_YEAR_PROD - QTY_AVG_LAST_YEAR_PROD)/ QTY_AVG_LAST_YEAR_PROD ,2)) AS QTY_YEAR_OVER_YEAR,
	IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_PROD - UNIT_AVG_LAST_YEAR_PROD)/ UNIT_AVG_LAST_YEAR_PROD,2)) AS UNIT_YEAR_OVER_YEAR,
	IIF((IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0,ROUND( (QTY_AVG_THIS_YEAR_PROD - QTY_AVG_LAST_YEAR_PROD)/ QTY_AVG_LAST_YEAR_PROD ,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_PROD - UNIT_AVG_LAST_YEAR_PROD)/ UNIT_AVG_LAST_YEAR_PROD,2)) >= 0), 'Y','N') AS YEAR_OVER_YEAR,

	-- 전년평균 VS 전월
	IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) AS QTY_LAST_YEAR_OVER_LAST_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) AS UNIT_LAST_YEAR_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_LAST_MONTH,

	-- 전년평균 VS 최근 3개월 평균
	IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) AS QTY_LAST_YEAR_OVER_3_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) AS UNIT_LAST_YEAR_OVER_3_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_3_MONTH,

	-- 최근 12개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_12MONTH_PROD)/QTY_AVG_RECENT_12MONTH_PROD,2)) AS QTY_12_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_12MONTH_PROD)/UNIT_AVG_RECENT_12MONTH_PROD,2)) AS UNIT_12_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_12MONTH_PROD)/QTY_AVG_RECENT_12MONTH_PROD,2)) > 0) AND (IIF(UNIT_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_12MONTH_PROD)/UNIT_AVG_RECENT_12MONTH_PROD,2)) >= 0), 'Y','N') AS RECENT_12_MONTH_OVER_LAST_MONTH,

	-- 최근 6개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_6MONTH_PROD)/QTY_AVG_RECENT_6MONTH_PROD,2)) AS QTY_6_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_6MONTH_PROD)/UNIT_AVG_RECENT_6MONTH_PROD,2)) AS UNIT_6_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_6MONTH_PROD)/QTY_AVG_RECENT_6MONTH_PROD,2)) > 0) AND (IIF(UNIT_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_6MONTH_PROD)/UNIT_AVG_RECENT_6MONTH_PROD,2)) >= 0), 'Y','N') AS RECENT_6_MONTH_OVER_LAST_MONTH,
	
	-- 최근 3개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_3MONTH_PROD)/QTY_AVG_RECENT_3MONTH_PROD,2)) AS QTY_3_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_3MONTH_PROD)/UNIT_AVG_RECENT_3MONTH_PROD,2)) AS UNIT_3_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_3MONTH_PROD)/QTY_AVG_RECENT_3MONTH_PROD,2)) > 0) AND (IIF(UNIT_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_3MONTH_PROD)/UNIT_AVG_RECENT_3MONTH_PROD,2)) >= 0), 'Y','N') AS RECENT_3_MONTH_OVER_LAST_MONTH

FROM 
	TEMP_REPORT;



	-- 공급처별 리스트 

WITH TEMP_REPORT AS
(

SELECT DISTINCT A.KEY_CODE, A.고객사코드, A.실공급업체코드, A.실공급업체명, 

	AB.구매단가 AS UNIT_AVG_LAST_YEAR_VENDOR, 
	AC.구매단가 AS UNIT_AVG_THIS_YEAR_VENDOR, 
	AD.구매단가 AS UNIT_AVG_RECENT_3MONTH_VENDOR, 
	AE.구매단가 AS UNIT_AVG_RECENT_6MONTH_VENDOR, 
	AF.구매단가 AS UNIT_AVG_RECENT_12MONTH_VENDOR, 
	AG.구매단가 AS UNIT_AVG_RECENT_VENDOR,

	AH.구매수량 AS QTY_AVG_LAST_YEAR_VENDOR,
	AI.구매수량 AS QTY_AVG_THIS_YEAR_VENDOR,
	AJ.구매수량 AS QTY_AVG_RECENT_3MONTH_VENDOR,
	AK.구매수량 AS QTY_AVG_RECENT_6MONTH_VENDOR,
	AL.구매수량 AS QTY_AVG_RECENT_12MONTH_VENDOR,
	AM.구매수량 AS QTY_AVG_RECENT_VENDOR

FROM MONTHLY_GR_LIST A 
    
	LEFT JOIN #UNIT_AVG_LAST_YEAR_VENDOR AB ON A.KEY_CODE = AB.KEY_CODE             -- 품목별 전년 평균단가
	LEFT JOIN #UNIT_AVG_THIS_YEAR_VENDOR AC ON A.KEY_CODE = AC.KEY_CODE             -- 품목별 금년 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_3MONTH_VENDOR AD ON A.KEY_CODE = AD.KEY_CODE        -- 품목별 최근 3개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_6MONTH_VENDOR AE ON A.KEY_CODE = AE.KEY_CODE        -- 품목별 최근 6개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_12MONTH_VENDOR AF ON A.KEY_CODE = AF.KEY_CODE       -- 품목별 최근 12개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_VENDOR AG ON A.KEY_CODE = AG.KEY_CODE                -- 품목별 최근 입고 단가
	
	LEFT JOIN #QTY_AVG_LAST_YEAR_VENDOR AH ON A.KEY_CODE = AH.KEY_CODE              -- 품목별 전년 평균 수량
	LEFT JOIN #QTY_AVG_THIS_YEAR_VENDOR AI ON A.KEY_CODE = AI.KEY_CODE              -- 품목별 금년 평균 수량
	LEFT JOIN #QTY_AVG_RECENT_3MONTH_VENDOR AJ ON A.KEY_CODE = AJ.KEY_CODE         -- 품목별 최근 3개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_6MONTH_VENDOR AK ON A.KEY_CODE = AK.KEY_CODE         -- 품목별 최근 6개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_12MONTH_VENDOR AL ON A.KEY_CODE = AL.KEY_CODE        -- 품목별 최근 12개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_VENDOR AM ON A.KEY_CODE = AM.KEY_CODE                 -- 품목별 최근 입고 수량 

)
SELECT 
	KEY_CODE, 고객사코드, 실공급업체코드, 실공급업체명, 

	
	/*----------------------------------------------------
	                  품목별 증감 데이터 
	----------------------------------------------------*/ 

	-- 전년평균 VS 금년평균
	IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0,ROUND((QTY_AVG_THIS_YEAR_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) AS QTY_YEAR_OVER_YEAR,
	IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) AS UNIT_YEAR_OVER_YEAR,
	IIF((IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0,ROUND((QTY_AVG_THIS_YEAR_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) >= 0), 'Y','N') AS YEAR_OVER_YEAR,

	-- 전년평균 VS 전월
	IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) AS QTY_LAST_YEAR_OVER_LAST_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) AS UNIT_LAST_YEAR_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_LAST_MONTH,

	-- 전년평균 VS 최근 3개월 평균
	IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) AS QTY_LAST_YEAR_OVER_3_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) AS UNIT_LAST_YEAR_OVER_3_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_3_MONTH,

	-- 최근 12개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_12MONTH_VENDOR)/QTY_AVG_RECENT_12MONTH_VENDOR,2)) AS QTY_12_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_12MONTH_VENDOR)/UNIT_AVG_RECENT_12MONTH_VENDOR,2)) AS UNIT_12_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_12MONTH_VENDOR)/QTY_AVG_RECENT_12MONTH_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_12MONTH_VENDOR)/UNIT_AVG_RECENT_12MONTH_VENDOR,2)) >= 0), 'Y','N') AS RECENT_12_MONTH_OVER_LAST_MONTH,

	-- 최근 6개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_6MONTH_VENDOR)/QTY_AVG_RECENT_6MONTH_VENDOR,2)) AS QTY_6_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_6MONTH_VENDOR)/UNIT_AVG_RECENT_6MONTH_VENDOR,2)) AS UNIT_6_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_6MONTH_VENDOR)/QTY_AVG_RECENT_6MONTH_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_6MONTH_VENDOR)/UNIT_AVG_RECENT_6MONTH_VENDOR,2)) >= 0), 'Y','N') AS RECENT_6_MONTH_OVER_LAST_MONTH,
	
	-- 최근 3개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_3MONTH_VENDOR)/QTY_AVG_RECENT_3MONTH_VENDOR,2)) AS QTY_3_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_3MONTH_VENDOR)/UNIT_AVG_RECENT_3MONTH_VENDOR,2)) AS UNIT_3_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_3MONTH_VENDOR)/QTY_AVG_RECENT_3MONTH_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_3MONTH_VENDOR)/UNIT_AVG_RECENT_3MONTH_VENDOR,2)) >= 0), 'Y','N') AS RECENT_3_MONTH_OVER_LAST_MONTH

FROM 
	TEMP_REPORT;


	

/*----------------------------------------------------
          공급처별/품목별 단가 평균 데이터 생성
----------------------------------------------------*/ 

CREATE TABLE #UNIT_AVG_RECENT_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10), 
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
입고월 VARCHAR(20),
구매단가 FLOAT
);

GO


CREATE TABLE #UNIT_AVG_RECENT_3MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_6MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_12MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_THIS_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매단가 FLOAT
);

GO

CREATE TABLE #UNIT_AVG_LAST_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20),
구매단가 FLOAT
);

GO


-- 최근 월 구매단가 평균 

-- 입고월이 문자열이기 때문에, 10월부터는 DESC 에 유의해야함!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 계열사품목코드,실공급업체코드 ORDER BY 입고월 DESC) AS ROW_NUM,
        고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, 입고월,
		구매금액, 구매수량
 FROM MONTHLY_GR_LIST)

INSERT INTO #UNIT_AVG_RECENT_MIX 

SELECT KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, 입고월 AS 최종입고월, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, 입고월;

GO

-- 최근 3개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_3MONTH_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5')

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;

GO

-- 최근 6개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_6MONTH_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;


GO

-- 최근 12개월 구매단가 평균 
INSERT INTO #UNIT_AVG_RECENT_12MONTH_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;

GO

-- 금년 구매단가 평균 
INSERT INTO #UNIT_AVG_THIS_YEAR_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2020'

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;

GO

-- 전년 구매단가 평균 
INSERT INTO #UNIT_AVG_LAST_YEAR_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, IIF(SUM(구매수량) = 0, 0, SUM(구매금액)/SUM(구매수량)) AS 구매단가

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2019'

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;



/*----------------------------------------------------
       공급처별/ 품목별 수량 평균 데이터 생성
----------------------------------------------------*/ 

CREATE TABLE #QTY_AVG_RECENT_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
입고월 VARCHAR(20),
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_3MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_6MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_12MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_THIS_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

CREATE TABLE #QTY_AVG_LAST_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
고객사코드 VARCHAR(10),  
실공급업체코드 VARCHAR(10),
계열사품목코드 VARCHAR(20), 
구매수량 FLOAT
);

GO

-- 최근 월 구매수량 평균 

-- 입고월이 문자열이기 때문에, 10월부터는 DESC 에 유의해야함!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY 고객사코드, 실공급업체코드, 계열사품목코드 ORDER BY 입고월 DESC) AS ROW_NUM,
        고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, 입고월,
		구매금액, 구매수량
 FROM MONTHLY_GR_LIST)

INSERT INTO #QTY_AVG_RECENT_MIX 

SELECT KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, 입고월 AS 최종입고월, AVG(구매수량) AS 구매수량

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, 입고월;

GO

-- 최근 3개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_3MONTH_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5')

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;

GO

-- 최근 6개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_6MONTH_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;


GO

-- 최근 12개월 구매수량 평균 
INSERT INTO #QTY_AVG_RECENT_12MONTH_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE 입고월 IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;

GO

-- 금년 구매수량 평균 
INSERT INTO #QTY_AVG_THIS_YEAR_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2020'

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;

GO

-- 전년 구매수량 평균 
INSERT INTO #QTY_AVG_LAST_YEAR_MIX
SELECT 고객사코드 +'>'+ 실공급업체코드+'>'+계열사품목코드 AS KEY_CODE3, 고객사코드, 실공급업체코드, 계열사품목코드, AVG(구매수량) AS 구매수량

FROM MONTHLY_GR_LIST

WHERE LEFT(입고월,4) = '2019'

GROUP BY 고객사코드, 실공급업체코드, 계열사품목코드;




-- 공급처별 품목별 리스트 

WITH TEMP_REPORT AS
(

SELECT DISTINCT A.고객사코드, A.실공급업체코드, A.실공급업체명, A.계열사품목코드, A.품명, A.카테고리,A.담당자부서,A.담당자성명, A.내외자구분, A.입고단위,

	AB.구매단가 AS UNIT_AVG_LAST_YEAR_MIX, 
	AC.구매단가 AS UNIT_AVG_THIS_YEAR_MIX, 
	AD.구매단가 AS UNIT_AVG_RECENT_3MONTH_MIX, 
	AE.구매단가 AS UNIT_AVG_RECENT_6MONTH_MIX, 
	AF.구매단가 AS UNIT_AVG_RECENT_12MONTH_MIX, 
	AG.구매단가 AS UNIT_AVG_RECENT_MIX,

	AH.구매수량 AS QTY_AVG_LAST_YEAR_MIX,
	AI.구매수량 AS QTY_AVG_THIS_YEAR_MIX,
	AJ.구매수량 AS QTY_AVG_RECENT_3MONTH_MIX,
	AK.구매수량 AS QTY_AVG_RECENT_6MONTH_MIX,
	AL.구매수량 AS QTY_AVG_RECENT_12MONTH_MIX,
	AM.구매수량 AS QTY_AVG_RECENT_MIX

FROM (SELECT *, 고객사코드 +'>' + 실공급업체코드 +'>' + 계열사품목코드 AS KEY_CODE3 FROM MONTHLY_GR_LIST) A 
    
	LEFT JOIN #UNIT_AVG_LAST_YEAR_MIX AB ON A.KEY_CODE3 = AB.KEY_CODE3             -- 품목별 전년 평균단가
	LEFT JOIN #UNIT_AVG_THIS_YEAR_MIX AC ON A.KEY_CODE3 = AC.KEY_CODE3             -- 품목별 금년 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_3MONTH_MIX AD ON A.KEY_CODE3 = AD.KEY_CODE3        -- 품목별 최근 3개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_6MONTH_MIX AE ON A.KEY_CODE3 = AE.KEY_CODE3        -- 품목별 최근 6개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_12MONTH_MIX AF ON A.KEY_CODE3 = AF.KEY_CODE3       -- 품목별 최근 12개월 평균단가
	LEFT JOIN #UNIT_AVG_RECENT_MIX AG ON A.KEY_CODE3 = AG.KEY_CODE3                -- 품목별 최근 입고 단가
	
	LEFT JOIN #QTY_AVG_LAST_YEAR_MIX AH ON A.KEY_CODE3 = AH.KEY_CODE3              -- 품목별 전년 평균 수량
	LEFT JOIN #QTY_AVG_THIS_YEAR_MIX AI ON A.KEY_CODE3 = AI.KEY_CODE3              -- 품목별 금년 평균 수량
	LEFT JOIN #QTY_AVG_RECENT_3MONTH_MIX AJ ON A.KEY_CODE3 = AJ.KEY_CODE3         -- 품목별 최근 3개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_6MONTH_MIX AK ON A.KEY_CODE3 = AK.KEY_CODE3         -- 품목별 최근 6개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_12MONTH_MIX AL ON A.KEY_CODE3 = AL.KEY_CODE3        -- 품목별 최근 12개월 평균수량
	LEFT JOIN #QTY_AVG_RECENT_MIX AM ON A.KEY_CODE3 = AM.KEY_CODE3                 -- 품목별 최근 입고 수량 

)
SELECT 
	고객사코드, 실공급업체코드, 실공급업체명, 계열사품목코드, 품명, 카테고리,담당자부서,담당자성명, 내외자구분, 입고단위,

	
	/*----------------------------------------------------
	             공급처별 / 품목별 증감 데이터 
	----------------------------------------------------*/ 

	-- 전년평균 VS 금년평균
	IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0,ROUND((QTY_AVG_THIS_YEAR_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) AS QTY_YEAR_OVER_YEAR,
	IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) AS UNIT_YEAR_OVER_YEAR,
	IIF((IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0,ROUND((QTY_AVG_THIS_YEAR_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) >= 0), 'Y','N') AS YEAR_OVER_YEAR,

	-- 전년평균 VS 전월
	IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) AS QTY_LAST_YEAR_OVER_LAST_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) AS UNIT_LAST_YEAR_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_LAST_MONTH,

	-- 전년평균 VS 최근 3개월 평균
	IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) AS QTY_LAST_YEAR_OVER_3_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) AS UNIT_LAST_YEAR_OVER_3_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_3_MONTH,

	-- 최근 12개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_12MONTH_MIX)/QTY_AVG_RECENT_12MONTH_MIX,2)) AS QTY_12_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_12MONTH_MIX)/UNIT_AVG_RECENT_12MONTH_MIX,2)) AS UNIT_12_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_12MONTH_MIX)/QTY_AVG_RECENT_12MONTH_MIX,2)) > 0) AND (IIF(UNIT_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_12MONTH_MIX)/UNIT_AVG_RECENT_12MONTH_MIX,2)) >= 0), 'Y','N') AS RECENT_12_MONTH_OVER_LAST_MONTH,

	-- 최근 6개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_6MONTH_MIX)/QTY_AVG_RECENT_6MONTH_MIX,2)) AS QTY_6_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_6MONTH_MIX)/UNIT_AVG_RECENT_6MONTH_MIX,2)) AS UNIT_6_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_6MONTH_MIX)/QTY_AVG_RECENT_6MONTH_MIX,2)) > 0) AND (IIF(UNIT_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_6MONTH_MIX)/UNIT_AVG_RECENT_6MONTH_MIX,2)) >= 0), 'Y','N') AS RECENT_6_MONTH_OVER_LAST_MONTH,
	
	-- 최근 3개월 평균 VS 전월
	IIF(QTY_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_3MONTH_MIX)/QTY_AVG_RECENT_3MONTH_MIX,2)) AS QTY_3_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_3MONTH_MIX)/UNIT_AVG_RECENT_3MONTH_MIX,2)) AS UNIT_3_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_3MONTH_MIX)/QTY_AVG_RECENT_3MONTH_MIX,2)) > 0) AND (IIF(UNIT_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_3MONTH_MIX)/UNIT_AVG_RECENT_3MONTH_MIX,2)) >= 0), 'Y','N') AS RECENT_3_MONTH_OVER_LAST_MONTH

FROM 
	TEMP_REPORT;


