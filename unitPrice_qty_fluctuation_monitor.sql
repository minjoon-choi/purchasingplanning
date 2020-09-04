USE purchasingRecord;


/*----------------------------------------------------
                 �迭�簣�ŷ� ��� 
----------------------------------------------------*/ 

CREATE TABLE #BETWEEN_COMPANY (
KEY_CODE VARCHAR(30),
�������� VARCHAR(20), 
�ǰ���ó�ڵ� VARCHAR(20),
�ǰ���ó�� VARCHAR(50))

GO

INSERT INTO #BETWEEN_COMPANY
SELECT DISTINCT �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS KEY_CODE, IIF(����ó�� LIKE '%����������%', 'GFS����', '���Ŵ���') AS ��������, 
                IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS �ǰ���ó�ڵ� , IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) AS �ǰ���ó��

FROM (SELECT * FROM GR_2020 UNION ALL SELECT * FROM GR_2019) A

WHERE  (IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%�︳%' 
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%�ĸ�ũ%' 
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%�����ǿ�%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%����%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%���%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%�дٿ�%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%�׸�%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%ȣ������%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%������%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%��ؿ���%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%����%'
OR IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%������%'
)
AND �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) NOT IN ('A100>10271','B100>10568','B100>11832','E100>15224')

ORDER BY �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�);

GO


/*----------------------------------------------------
                 ���� �������� ���̺�
----------------------------------------------------*/ 


-- SL ���ڽĺ�
CREATE TABLE #IMPORT_VENDOR 
(
KEY_CODE VARCHAR(30), 
�ǰ���ó�ڵ� VARCHAR(20),
�ǰ���ó�� VARCHAR(100),
�������� VARCHAR(20)
);

GO

INSERT INTO #IMPORT_VENDOR SELECT DISTINCT �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS KEY_CODE,  IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS �ǰ���ó�ڵ� , 
                IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) AS �ǰ���ó��, IIF(����ó�� LIKE '%����������%', 'GFS����', '���Ŵ���') AS ��������
FROM (SELECT * FROM GR_2020 UNION ALL SELECT * FROM GR_2019) A 
WHERE IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) LIKE '%����ǰ����%' AND �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) NOT IN ('A100>10271','B100>10568','B100>11832','E100>15224');

GO

-- PC, BR ���ڽĺ�

INSERT INTO #IMPORT_VENDOR SELECT DISTINCT �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS KEY_CODE,  IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS �ǰ���ó�ڵ� , 
                IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) AS �ǰ���ó��, IIF(����ó�� LIKE '%����������%', 'GFS����', '���Ŵ���') AS ��������
FROM (SELECT * FROM GR_2020 UNION ALL SELECT * FROM GR_2019) A 
WHERE �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) LIKE 'PC00>2%' OR �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) LIKE 'SP00>2%' 
OR �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) LIKE 'BR00>2%' OR �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) LIKE '1000>2%';

GO


/*----------------------------------------------------
                    FILTERED DATA
----------------------------------------------------*/ 

CREATE TABLE #FILTERED_SUM_DATA_TABLE 
(
KEY_CODE VARCHAR(20),
KEY_CODE2 VARCHAR(20), 
�����ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20),
�ǰ��޾�ü�ڵ� VARCHAR(10),
�ǰ��޾�ü�� VARCHAR(100), 
�������� VARCHAR(20), 
�����ڱ��� VARCHAR(10),
�԰���� VARCHAR(10),
�԰�� VARCHAR(20),
���ż��� FLOAT,
���űݾ� FLOAT
);

GO

CREATE TABLE #ASSIGN_BUYER_TABLE
(
ROW_NUM INT,
KEY_CODE2 VARCHAR(20),
����ںμ� VARCHAR(30),
����ڼ��� VARCHAR(20),
�԰����� DATE
);

CREATE TABLE #RECENT_PRODUCT_NAME_TABLE
(
ROW_NUM INT,
KEY_CODE2 VARCHAR(20),
ǰ�� VARCHAR(100),
�԰����� DATE
);

GO

CREATE TABLE #RECENT_CATE_NAME_TABLE
(
ROW_NUM INT,
KEY_CODE2 VARCHAR(20),
ī�װ� VARCHAR(100),
�԰����� DATE
);

GO

CREATE TABLE #RESULT_TEMP_TABLE
(
KEY_CODE VARCHAR(20), 
KEY_CODE2 VARCHAR(20), 
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
ǰ�� VARCHAR(100),
�ǰ��޾�ü�ڵ� VARCHAR(10), 
�ǰ��޾�ü�� VARCHAR(100), 
�������� VARCHAR(20), 
�����ڱ��� VARCHAR(10), 
�԰���� VARCHAR(10), 
�԰�� VARCHAR(20), 
���ż��� FLOAT, 
���űݾ� FLOAT, 
����ںμ� VARCHAR(30), 
����ڼ��� VARCHAR(20)
);

GO

CREATE TABLE #RESULT_TABLE
(
KEY_CODE VARCHAR(20), 
KEY_CODE2 VARCHAR(20), 
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
ǰ�� VARCHAR(100),
�ǰ��޾�ü�ڵ� VARCHAR(10), 
�ǰ��޾�ü�� VARCHAR(100), 
�������� VARCHAR(20), 
�����ڱ��� VARCHAR(10), 
�԰���� VARCHAR(10), 
�԰�� VARCHAR(20), 
���ż��� FLOAT, 
���űݾ� FLOAT, 
����ںμ� VARCHAR(30), 
����ڼ��� VARCHAR(20),
ī�װ� VARCHAR(100)
);

GO

WITH FILTERED_SUM_DATA AS 
(
SELECT 
    �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%',�ǰ���ó�ڵ�, ����ó�ڵ�) AS KEY_CODE,  �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, 
    �����ڵ�, �迭��ǰ���ڵ�, IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) AS �ǰ��޾�ü�ڵ�, 
    IIF(����ó�� LIKE '%����������%', �ǰ���ó��, ����ó��) AS �ǰ��޾�ü��, IIF(����ó�� LIKE '%����������%', 'GFS����', '���Ŵ���') AS ��������,
	IIF((�����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) IN (SELECT KEY_CODE FROM #IMPORT_VENDOR)), '����','����') AS �����ڱ���, 
	�԰����, �԰�����, �԰����, �԰�ݾ� 
FROM 
    (SELECT �����ڵ�, �迭��ǰ���ڵ�, ����ó�ڵ�, ����ó��, �ǰ���ó�ڵ�, �ǰ���ó��, �԰�����, �԰����, �԰�ݾ�, �԰���� FROM GR_2020
	UNION ALL 
	SELECT �����ڵ�, �迭��ǰ���ڵ�, ����ó�ڵ�, ����ó��, �ǰ���ó�ڵ�, �ǰ���ó��, �԰�����, �԰����, �԰�ݾ�, �԰���� FROM GR_2019) A
WHERE 
    �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) NOT IN (SELECT KEY_CODE FROM #BETWEEN_COMPANY) 
    AND �迭��ǰ���ڵ� <> '7777777777' AND �����ڵ� <> 'SM00' 
    AND �����ڵ� + '>' +IIF(����ó�� LIKE '%����������%', �ǰ���ó�ڵ�, ����ó�ڵ�) NOT LIKE 'SL00>7%' AND �迭��ǰ���ڵ� <> '' 
) 
INSERT INTO #FILTERED_SUM_DATA_TABLE 
SELECT 
    KEY_CODE, KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �ǰ��޾�ü�ڵ�, �ǰ��޾�ü��, ��������, �����ڱ���, �԰����, 
    CONCAT(YEAR(�԰�����), '-', MONTH(�԰�����)) AS �԰��, SUM(�԰����) AS ���ż���, SUM(�԰�ݾ�) AS ���űݾ� 
FROM 
    FILTERED_SUM_DATA
GROUP BY 
    KEY_CODE, KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �ǰ��޾�ü�ڵ�, �ǰ��޾�ü��, ��������, �����ڱ���, �԰����, YEAR(�԰�����), MONTH(�԰�����)

GO

WITH ASSIGN_BUYER AS
(
SELECT 
    ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �迭��ǰ���ڵ� ORDER BY �԰����� DESC) AS ROW_NUM, �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, 
	����ںμ�, ����ڼ���, �԰�����

FROM 
    (SELECT �����ڵ�, �迭��ǰ���ڵ�, ����ڼ���, ����ںμ�, �԰����� FROM GR_2020 WHERE �迭��ǰ���ڵ� <> '' AND �����ڵ� <> 'SM00' 
     AND �迭��ǰ���ڵ� <> '' AND �迭��ǰ���ڵ� <> '7777777777'
     
	 UNION ALL 
	 
	 SELECT �����ڵ�, �迭��ǰ���ڵ�, ����ڼ���, ����ںμ�, �԰����� FROM GR_2019  WHERE �迭��ǰ���ڵ� <> '' AND �����ڵ� <> 'SM00' 
	 AND �迭��ǰ���ڵ� <> '' AND �迭��ǰ���ڵ� <> '7777777777') A
)

INSERT INTO #ASSIGN_BUYER_TABLE 
SELECT * 
FROM ASSIGN_BUYER WHERE ROW_NUM = 1;


WITH RECENT_PRODUCT_NAME AS  
(
SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �迭��ǰ���ڵ� ORDER BY �԰����� DESC) AS ROW_NUM, �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, ǰ��, �԰����� 
FROM (SELECT �����ڵ�, �迭��ǰ���ڵ�, ǰ��, �԰����� FROM GR_2020 WHERE �迭��ǰ���ڵ� <> '' AND �����ڵ� <> 'SM00' AND �迭��ǰ���ڵ� <> '' AND �迭��ǰ���ڵ� <> '7777777777'
      UNION ALL 
	  SELECT �����ڵ�, �迭��ǰ���ڵ�, ǰ��, �԰����� FROM GR_2019  WHERE �迭��ǰ���ڵ� <> '' AND �����ڵ� <> 'SM00' AND �迭��ǰ���ڵ� <> '' AND �迭��ǰ���ڵ� <> '7777777777') A
) INSERT INTO #RECENT_PRODUCT_NAME_TABLE SELECT * FROM RECENT_PRODUCT_NAME WHERE ROW_NUM = 1;

GO

WITH RECENT_CATE_NAME AS  
(
SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �迭��ǰ���ڵ� ORDER BY �԰����� DESC) AS ROW_NUM, �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, ī�װ�, �԰����� 
FROM (SELECT �����ڵ�, �迭��ǰ���ڵ�, ī�װ�, �԰����� FROM GR_2020 WHERE �迭��ǰ���ڵ� <> '' AND �����ڵ� <> 'SM00' AND �迭��ǰ���ڵ� <> '' AND �迭��ǰ���ڵ� <> '7777777777'
      UNION ALL 
	  SELECT �����ڵ�, �迭��ǰ���ڵ�, ī�װ�, �԰����� FROM GR_2019  WHERE �迭��ǰ���ڵ� <> '' AND �����ڵ� <> 'SM00' AND �迭��ǰ���ڵ� <> '' AND �迭��ǰ���ڵ� <> '7777777777') A
) INSERT INTO #RECENT_CATE_NAME_TABLE SELECT * FROM RECENT_CATE_NAME WHERE ROW_NUM = 1;

GO

WITH RESULT_TEMP_TABLE AS (
SELECT A.KEY_CODE, A.KEY_CODE2, A.�����ڵ�, A.�迭��ǰ���ڵ�, A.�ǰ��޾�ü�ڵ�, A.�ǰ��޾�ü��, A.��������, A.�����ڱ���, A.�԰����, A.�԰��, A.���ż���, A.���űݾ�, B.����ںμ�, B.����ڼ��� 
FROM #FILTERED_SUM_DATA_TABLE A LEFT JOIN #ASSIGN_BUYER_TABLE B ON A.KEY_CODE2 = B.KEY_CODE2) 
INSERT INTO #RESULT_TEMP_TABLE SELECT A.KEY_CODE, A.KEY_CODE2, A.�����ڵ�, A.�迭��ǰ���ڵ�, B.ǰ��, A.�ǰ��޾�ü�ڵ�, A.�ǰ��޾�ü��, A.��������, A.�����ڱ���, A.�԰����, A.�԰��, A.���ż���, A.���űݾ�, A.����ںμ�, A.����ڼ���
FROM RESULT_TEMP_TABLE A LEFT JOIN #RECENT_PRODUCT_NAME_TABLE B ON A.KEY_CODE2 = B.KEY_CODE2;

WITH RESULT_TABLE AS (
SELECT A.KEY_CODE, A.KEY_CODE2, A.�����ڵ�, A.�迭��ǰ���ڵ�, A.ǰ��, A.�ǰ��޾�ü�ڵ�, A.�ǰ��޾�ü��, A.��������, A.�����ڱ���, A.�԰����, A.�԰��, A.���ż���, A.���űݾ�, A.����ںμ�, A.����ڼ���, B.ī�װ� 
FROM #RESULT_TEMP_TABLE A LEFT JOIN #RECENT_CATE_NAME_TABLE B ON A.KEY_CODE2 = B.KEY_CODE2) 
INSERT INTO #RESULT_TABLE SELECT * FROM RESULT_TABLE


-- DROP TABLE MONTHLY_GR_LIST;
GO
CREATE TABLE MONTHLY_GR_LIST
(
KEY_CODE VARCHAR(20), 
KEY_CODE2 VARCHAR(20), 
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
ǰ�� VARCHAR(100),
�ǰ��޾�ü�ڵ� VARCHAR(10), 
�ǰ��޾�ü�� VARCHAR(100), 
�������� VARCHAR(20), 
�����ڱ��� VARCHAR(10), 
�԰���� VARCHAR(10), 
�԰�� VARCHAR(20), 
���ż��� FLOAT, 
���űݾ� FLOAT, 
����ںμ� VARCHAR(30), 
����ڼ��� VARCHAR(20),
ī�װ� VARCHAR(100)
);

GO

INSERT INTO MONTHLY_GR_LIST SELECT * FROM #RESULT_TABLE


GO 


/*----------------------------------------------------
            ǰ�� �ܰ� ��� ������ ����
----------------------------------------------------*/ 

CREATE TABLE #UNIT_AVG_RECENT_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
�԰�� VARCHAR(20),
���Ŵܰ� FLOAT
);

GO


CREATE TABLE #UNIT_AVG_RECENT_3MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_6MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_12MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_THIS_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_LAST_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20),
���Ŵܰ� FLOAT
);

GO


-- �ֱ� �� ���Ŵܰ� ��� 

-- �԰���� ���ڿ��̱� ������, 10�����ʹ� DESC �� �����ؾ���!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �迭��ǰ���ڵ� ORDER BY �԰�� DESC) AS ROW_NUM,
        �����ڵ� +'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �԰��,
		���űݾ�, ���ż���
 FROM MONTHLY_GR_LIST)

INSERT INTO #UNIT_AVG_RECENT_PROD 

SELECT KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �԰�� AS �����԰��, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �԰��

GO

-- �ֱ� 3���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_3MONTH_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5')

GROUP BY �����ڵ�, �迭��ǰ���ڵ�

GO

-- �ֱ� 6���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_6MONTH_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY �����ڵ�, �迭��ǰ���ڵ�


GO

-- �ֱ� 12���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_12MONTH_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY �����ڵ�, �迭��ǰ���ڵ�

GO

-- �ݳ� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_THIS_YEAR_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2020'

GROUP BY �����ڵ�, �迭��ǰ���ڵ�

GO

-- ���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_LAST_YEAR_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2019'

GROUP BY �����ڵ�, �迭��ǰ���ڵ�



/*----------------------------------------------------
           ǰ�� ���� ��� ������ ����
----------------------------------------------------*/ 

CREATE TABLE #QTY_AVG_RECENT_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
�԰�� VARCHAR(20),
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_3MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_6MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_12MONTH_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_THIS_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_LAST_YEAR_PROD
(
KEY_CODE2 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

-- �ֱ� �� ���ż��� ��� 

-- �԰���� ���ڿ��̱� ������, 10�����ʹ� DESC �� �����ؾ���!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �迭��ǰ���ڵ� ORDER BY �԰�� DESC) AS ROW_NUM,
        �����ڵ� +'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �԰��,
		���űݾ�, ���ż���
 FROM MONTHLY_GR_LIST)

INSERT INTO #QTY_AVG_RECENT_PROD 

SELECT KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �԰�� AS �����԰��, AVG(���ż���) AS ���ż���

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, �԰��

GO

-- �ֱ� 3���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_3MONTH_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5')

GROUP BY �����ڵ�, �迭��ǰ���ڵ�

GO

-- �ֱ� 6���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_6MONTH_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY �����ڵ�, �迭��ǰ���ڵ�


GO

-- �ֱ� 12���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_12MONTH_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY �����ڵ�, �迭��ǰ���ڵ�

GO

-- �ݳ� ���ż��� ��� 
INSERT INTO #QTY_AVG_THIS_YEAR_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2020'

GROUP BY �����ڵ�, �迭��ǰ���ڵ�

GO

-- ���� ���ż��� ��� 
INSERT INTO #QTY_AVG_LAST_YEAR_PROD
SELECT �����ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2019'

GROUP BY �����ڵ�, �迭��ǰ���ڵ�




/*----------------------------------------------------
------------����ó�� �ܰ� ��� ������ ����--------------
----------------------------------------------------*/ 


CREATE TABLE #UNIT_AVG_RECENT_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
�԰�� VARCHAR(20),
���Ŵܰ� FLOAT
);

GO


CREATE TABLE #UNIT_AVG_RECENT_3MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_6MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_12MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_THIS_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_LAST_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20),
���Ŵܰ� FLOAT
);

GO

-- �ֱ� �� ���Ŵܰ� ��� 

-- �԰���� ���ڿ��̱� ������, 10�����ʹ� DESC �� �����ؾ���!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �ǰ��޾�ü�ڵ� ORDER BY �԰�� DESC) AS ROW_NUM,
        �����ڵ� +'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE2, �����ڵ�, �ǰ��޾�ü�ڵ�, �԰��,
		���űݾ�, ���ż���
 FROM MONTHLY_GR_LIST)

INSERT INTO #UNIT_AVG_RECENT_VENDOR 

SELECT KEY_CODE2, �����ڵ�, �ǰ��޾�ü�ڵ�, �԰�� AS �����԰��, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, �����ڵ�, �ǰ��޾�ü�ڵ�, �԰��

GO


-- �ֱ� 3���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_3MONTH_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�

GO

-- �ֱ� 6���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_6MONTH_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�


GO

-- �ֱ� 12���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_12MONTH_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�

GO

-- �ݳ� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_THIS_YEAR_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2020'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�

GO

-- ���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_LAST_YEAR_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2019'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�



/*----------------------------------------------------
-------------����ó�� ���� ��� ������ ����-------------
----------------------------------------------------*/ 

CREATE TABLE #QTY_AVG_RECENT_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
�԰�� VARCHAR(20),
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_3MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_6MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_12MONTH_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_THIS_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_LAST_YEAR_VENDOR
(
KEY_CODE VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

-- �ֱ� �� ���ż��� ��� 

-- �԰���� ���ڿ��̱� ������, 10�����ʹ� DESC �� �����ؾ���!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �ǰ��޾�ü�ڵ� ORDER BY �԰�� DESC) AS ROW_NUM,
        �����ڵ� +'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE2, �����ڵ�, �ǰ��޾�ü�ڵ�, �԰��,
		���űݾ�, ���ż���
 FROM MONTHLY_GR_LIST)

INSERT INTO #QTY_AVG_RECENT_VENDOR

SELECT KEY_CODE2, �����ڵ�, �ǰ��޾�ü�ڵ�, �԰�� AS �����԰��, AVG(���ż���) AS ���ż���

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE2, �����ڵ�, �ǰ��޾�ü�ڵ�, �԰��

GO

-- �ֱ� 3���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_3MONTH_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�

GO

-- �ֱ� 6���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_6MONTH_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�


GO

-- �ֱ� 12���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_12MONTH_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�

GO

-- �ݳ� ���ż��� ��� 
INSERT INTO #QTY_AVG_THIS_YEAR_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2020'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�

GO

-- ���� ���ż��� ��� 
INSERT INTO #QTY_AVG_LAST_YEAR_VENDOR
SELECT �����ڵ�+'>'+�ǰ��޾�ü�ڵ� AS KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2019'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�;


/*----------------------------------------------------
-------------      ��� ������ ����      -------------
----------------------------------------------------*/ 


-- ǰ�� ����Ʈ 

WITH TEMP_REPORT AS
(

SELECT DISTINCT A.KEY_CODE2, A.�����ڵ�, A.�迭��ǰ���ڵ�, A.ǰ��, A.ī�װ�,A.����ںμ�,A.����ڼ���, A.�����ڱ���, A.�԰����, 

	AB.���Ŵܰ� AS UNIT_AVG_LAST_YEAR_PROD, 
	AC.���Ŵܰ� AS UNIT_AVG_THIS_YEAR_PROD, 
	AD.���Ŵܰ� AS UNIT_AVG_RECENT_3MONTH_PROD, 
	AE.���Ŵܰ� AS UNIT_AVG_RECENT_6MONTH_PROD, 
	AF.���Ŵܰ� AS UNIT_AVG_RECENT_12MONTH_PROD, 
	AG.���Ŵܰ� AS UNIT_AVG_RECENT_PROD,

	AH.���ż��� AS QTY_AVG_LAST_YEAR_PROD,
	AI.���ż��� AS QTY_AVG_THIS_YEAR_PROD,
	AJ.���ż��� AS QTY_AVG_RECENT_3MONTH_PROD,
	AK.���ż��� AS QTY_AVG_RECENT_6MONTH_PROD,
	AL.���ż��� AS QTY_AVG_RECENT_12MONTH_PROD,
	AM.���ż��� AS QTY_AVG_RECENT_PROD

FROM MONTHLY_GR_LIST A 
    
	LEFT JOIN #UNIT_AVG_LAST_YEAR_PROD AB ON A.KEY_CODE2 = AB.KEY_CODE2             -- ǰ�� ���� ��մܰ�
	LEFT JOIN #UNIT_AVG_THIS_YEAR_PROD AC ON A.KEY_CODE2 = AC.KEY_CODE2             -- ǰ�� �ݳ� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_3MONTH_PROD AD ON A.KEY_CODE2 = AD.KEY_CODE2        -- ǰ�� �ֱ� 3���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_6MONTH_PROD AE ON A.KEY_CODE2 = AE.KEY_CODE2        -- ǰ�� �ֱ� 6���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_12MONTH_PROD AF ON A.KEY_CODE2 = AF.KEY_CODE2       -- ǰ�� �ֱ� 12���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_PROD AG ON A.KEY_CODE2 = AG.KEY_CODE2                -- ǰ�� �ֱ� �԰� �ܰ�
	
	LEFT JOIN #QTY_AVG_LAST_YEAR_PROD AH ON A.KEY_CODE2 = AH.KEY_CODE2              -- ǰ�� ���� ��� ����
	LEFT JOIN #QTY_AVG_THIS_YEAR_PROD AI ON A.KEY_CODE2 = AI.KEY_CODE2              -- ǰ�� �ݳ� ��� ����
	LEFT JOIN #QTY_AVG_RECENT_3MONTH_PROD AJ ON A.KEY_CODE2 = AJ.KEY_CODE2         -- ǰ�� �ֱ� 3���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_6MONTH_PROD AK ON A.KEY_CODE2 = AK.KEY_CODE2         -- ǰ�� �ֱ� 6���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_12MONTH_PROD AL ON A.KEY_CODE2 = AL.KEY_CODE2        -- ǰ�� �ֱ� 12���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_PROD AM ON A.KEY_CODE2 = AM.KEY_CODE2                 -- ǰ�� �ֱ� �԰� ���� 

)
SELECT 
	KEY_CODE2, �����ڵ�, �迭��ǰ���ڵ�, ǰ��, ī�װ�, ����ںμ�,����ڼ���, �����ڱ���, �԰����,

	
	/*----------------------------------------------------
	                  ǰ�� ���� ������ 
	----------------------------------------------------*/ 

	-- ������� VS �ݳ����
	IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0,ROUND( (QTY_AVG_THIS_YEAR_PROD - QTY_AVG_LAST_YEAR_PROD)/ QTY_AVG_LAST_YEAR_PROD ,2)) AS QTY_YEAR_OVER_YEAR,
	IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_PROD - UNIT_AVG_LAST_YEAR_PROD)/ UNIT_AVG_LAST_YEAR_PROD,2)) AS UNIT_YEAR_OVER_YEAR,
	IIF((IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0,ROUND( (QTY_AVG_THIS_YEAR_PROD - QTY_AVG_LAST_YEAR_PROD)/ QTY_AVG_LAST_YEAR_PROD ,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_PROD - UNIT_AVG_LAST_YEAR_PROD)/ UNIT_AVG_LAST_YEAR_PROD,2)) >= 0), 'Y','N') AS YEAR_OVER_YEAR,

	-- ������� VS ����
	IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) AS QTY_LAST_YEAR_OVER_LAST_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) AS UNIT_LAST_YEAR_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_LAST_MONTH,

	-- ������� VS �ֱ� 3���� ���
	IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) AS QTY_LAST_YEAR_OVER_3_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) AS UNIT_LAST_YEAR_OVER_3_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_PROD = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_PROD - QTY_AVG_LAST_YEAR_PROD)/QTY_AVG_LAST_YEAR_PROD,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_PROD - UNIT_AVG_LAST_YEAR_PROD)/UNIT_AVG_LAST_YEAR_PROD,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_3_MONTH,

	-- �ֱ� 12���� ��� VS ����
	IIF(QTY_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_12MONTH_PROD)/QTY_AVG_RECENT_12MONTH_PROD,2)) AS QTY_12_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_12MONTH_PROD)/UNIT_AVG_RECENT_12MONTH_PROD,2)) AS UNIT_12_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_12MONTH_PROD)/QTY_AVG_RECENT_12MONTH_PROD,2)) > 0) AND (IIF(UNIT_AVG_RECENT_12MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_12MONTH_PROD)/UNIT_AVG_RECENT_12MONTH_PROD,2)) >= 0), 'Y','N') AS RECENT_12_MONTH_OVER_LAST_MONTH,

	-- �ֱ� 6���� ��� VS ����
	IIF(QTY_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_6MONTH_PROD)/QTY_AVG_RECENT_6MONTH_PROD,2)) AS QTY_6_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_6MONTH_PROD)/UNIT_AVG_RECENT_6MONTH_PROD,2)) AS UNIT_6_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_6MONTH_PROD)/QTY_AVG_RECENT_6MONTH_PROD,2)) > 0) AND (IIF(UNIT_AVG_RECENT_6MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_6MONTH_PROD)/UNIT_AVG_RECENT_6MONTH_PROD,2)) >= 0), 'Y','N') AS RECENT_6_MONTH_OVER_LAST_MONTH,
	
	-- �ֱ� 3���� ��� VS ����
	IIF(QTY_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_3MONTH_PROD)/QTY_AVG_RECENT_3MONTH_PROD,2)) AS QTY_3_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_3MONTH_PROD)/UNIT_AVG_RECENT_3MONTH_PROD,2)) AS UNIT_3_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((QTY_AVG_RECENT_PROD - QTY_AVG_RECENT_3MONTH_PROD)/QTY_AVG_RECENT_3MONTH_PROD,2)) > 0) AND (IIF(UNIT_AVG_RECENT_3MONTH_PROD = 0, 0, ROUND((UNIT_AVG_RECENT_PROD - UNIT_AVG_RECENT_3MONTH_PROD)/UNIT_AVG_RECENT_3MONTH_PROD,2)) >= 0), 'Y','N') AS RECENT_3_MONTH_OVER_LAST_MONTH

FROM 
	TEMP_REPORT;



	-- ����ó�� ����Ʈ 

WITH TEMP_REPORT AS
(

SELECT DISTINCT A.KEY_CODE, A.�����ڵ�, A.�ǰ��޾�ü�ڵ�, A.�ǰ��޾�ü��, 

	AB.���Ŵܰ� AS UNIT_AVG_LAST_YEAR_VENDOR, 
	AC.���Ŵܰ� AS UNIT_AVG_THIS_YEAR_VENDOR, 
	AD.���Ŵܰ� AS UNIT_AVG_RECENT_3MONTH_VENDOR, 
	AE.���Ŵܰ� AS UNIT_AVG_RECENT_6MONTH_VENDOR, 
	AF.���Ŵܰ� AS UNIT_AVG_RECENT_12MONTH_VENDOR, 
	AG.���Ŵܰ� AS UNIT_AVG_RECENT_VENDOR,

	AH.���ż��� AS QTY_AVG_LAST_YEAR_VENDOR,
	AI.���ż��� AS QTY_AVG_THIS_YEAR_VENDOR,
	AJ.���ż��� AS QTY_AVG_RECENT_3MONTH_VENDOR,
	AK.���ż��� AS QTY_AVG_RECENT_6MONTH_VENDOR,
	AL.���ż��� AS QTY_AVG_RECENT_12MONTH_VENDOR,
	AM.���ż��� AS QTY_AVG_RECENT_VENDOR

FROM MONTHLY_GR_LIST A 
    
	LEFT JOIN #UNIT_AVG_LAST_YEAR_VENDOR AB ON A.KEY_CODE = AB.KEY_CODE             -- ǰ�� ���� ��մܰ�
	LEFT JOIN #UNIT_AVG_THIS_YEAR_VENDOR AC ON A.KEY_CODE = AC.KEY_CODE             -- ǰ�� �ݳ� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_3MONTH_VENDOR AD ON A.KEY_CODE = AD.KEY_CODE        -- ǰ�� �ֱ� 3���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_6MONTH_VENDOR AE ON A.KEY_CODE = AE.KEY_CODE        -- ǰ�� �ֱ� 6���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_12MONTH_VENDOR AF ON A.KEY_CODE = AF.KEY_CODE       -- ǰ�� �ֱ� 12���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_VENDOR AG ON A.KEY_CODE = AG.KEY_CODE                -- ǰ�� �ֱ� �԰� �ܰ�
	
	LEFT JOIN #QTY_AVG_LAST_YEAR_VENDOR AH ON A.KEY_CODE = AH.KEY_CODE              -- ǰ�� ���� ��� ����
	LEFT JOIN #QTY_AVG_THIS_YEAR_VENDOR AI ON A.KEY_CODE = AI.KEY_CODE              -- ǰ�� �ݳ� ��� ����
	LEFT JOIN #QTY_AVG_RECENT_3MONTH_VENDOR AJ ON A.KEY_CODE = AJ.KEY_CODE         -- ǰ�� �ֱ� 3���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_6MONTH_VENDOR AK ON A.KEY_CODE = AK.KEY_CODE         -- ǰ�� �ֱ� 6���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_12MONTH_VENDOR AL ON A.KEY_CODE = AL.KEY_CODE        -- ǰ�� �ֱ� 12���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_VENDOR AM ON A.KEY_CODE = AM.KEY_CODE                 -- ǰ�� �ֱ� �԰� ���� 

)
SELECT 
	KEY_CODE, �����ڵ�, �ǰ��޾�ü�ڵ�, �ǰ��޾�ü��, 

	
	/*----------------------------------------------------
	                  ǰ�� ���� ������ 
	----------------------------------------------------*/ 

	-- ������� VS �ݳ����
	IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0,ROUND((QTY_AVG_THIS_YEAR_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) AS QTY_YEAR_OVER_YEAR,
	IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) AS UNIT_YEAR_OVER_YEAR,
	IIF((IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0,ROUND((QTY_AVG_THIS_YEAR_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) >= 0), 'Y','N') AS YEAR_OVER_YEAR,

	-- ������� VS ����
	IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) AS QTY_LAST_YEAR_OVER_LAST_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) AS UNIT_LAST_YEAR_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_LAST_MONTH,

	-- ������� VS �ֱ� 3���� ���
	IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) AS QTY_LAST_YEAR_OVER_3_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) AS UNIT_LAST_YEAR_OVER_3_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_VENDOR - QTY_AVG_LAST_YEAR_VENDOR)/QTY_AVG_LAST_YEAR_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_VENDOR - UNIT_AVG_LAST_YEAR_VENDOR)/UNIT_AVG_LAST_YEAR_VENDOR,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_3_MONTH,

	-- �ֱ� 12���� ��� VS ����
	IIF(QTY_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_12MONTH_VENDOR)/QTY_AVG_RECENT_12MONTH_VENDOR,2)) AS QTY_12_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_12MONTH_VENDOR)/UNIT_AVG_RECENT_12MONTH_VENDOR,2)) AS UNIT_12_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_12MONTH_VENDOR)/QTY_AVG_RECENT_12MONTH_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_RECENT_12MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_12MONTH_VENDOR)/UNIT_AVG_RECENT_12MONTH_VENDOR,2)) >= 0), 'Y','N') AS RECENT_12_MONTH_OVER_LAST_MONTH,

	-- �ֱ� 6���� ��� VS ����
	IIF(QTY_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_6MONTH_VENDOR)/QTY_AVG_RECENT_6MONTH_VENDOR,2)) AS QTY_6_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_6MONTH_VENDOR)/UNIT_AVG_RECENT_6MONTH_VENDOR,2)) AS UNIT_6_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_6MONTH_VENDOR)/QTY_AVG_RECENT_6MONTH_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_RECENT_6MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_6MONTH_VENDOR)/UNIT_AVG_RECENT_6MONTH_VENDOR,2)) >= 0), 'Y','N') AS RECENT_6_MONTH_OVER_LAST_MONTH,
	
	-- �ֱ� 3���� ��� VS ����
	IIF(QTY_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_3MONTH_VENDOR)/QTY_AVG_RECENT_3MONTH_VENDOR,2)) AS QTY_3_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_3MONTH_VENDOR)/UNIT_AVG_RECENT_3MONTH_VENDOR,2)) AS UNIT_3_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((QTY_AVG_RECENT_VENDOR - QTY_AVG_RECENT_3MONTH_VENDOR)/QTY_AVG_RECENT_3MONTH_VENDOR,2)) > 0) AND (IIF(UNIT_AVG_RECENT_3MONTH_VENDOR = 0, 0, ROUND((UNIT_AVG_RECENT_VENDOR - UNIT_AVG_RECENT_3MONTH_VENDOR)/UNIT_AVG_RECENT_3MONTH_VENDOR,2)) >= 0), 'Y','N') AS RECENT_3_MONTH_OVER_LAST_MONTH

FROM 
	TEMP_REPORT;


	

/*----------------------------------------------------
          ����ó��/ǰ�� �ܰ� ��� ������ ����
----------------------------------------------------*/ 

CREATE TABLE #UNIT_AVG_RECENT_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10), 
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
�԰�� VARCHAR(20),
���Ŵܰ� FLOAT
);

GO


CREATE TABLE #UNIT_AVG_RECENT_3MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_6MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_RECENT_12MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_THIS_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���Ŵܰ� FLOAT
);

GO

CREATE TABLE #UNIT_AVG_LAST_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20),
���Ŵܰ� FLOAT
);

GO


-- �ֱ� �� ���Ŵܰ� ��� 

-- �԰���� ���ڿ��̱� ������, 10�����ʹ� DESC �� �����ؾ���!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �迭��ǰ���ڵ�,�ǰ��޾�ü�ڵ� ORDER BY �԰�� DESC) AS ROW_NUM,
        �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, �԰��,
		���űݾ�, ���ż���
 FROM MONTHLY_GR_LIST)

INSERT INTO #UNIT_AVG_RECENT_MIX 

SELECT KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, �԰�� AS �����԰��, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, �԰��;

GO

-- �ֱ� 3���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_3MONTH_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;

GO

-- �ֱ� 6���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_6MONTH_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;


GO

-- �ֱ� 12���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_RECENT_12MONTH_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;

GO

-- �ݳ� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_THIS_YEAR_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2020'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;

GO

-- ���� ���Ŵܰ� ��� 
INSERT INTO #UNIT_AVG_LAST_YEAR_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, IIF(SUM(���ż���) = 0, 0, SUM(���űݾ�)/SUM(���ż���)) AS ���Ŵܰ�

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2019'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;



/*----------------------------------------------------
       ����ó��/ ǰ�� ���� ��� ������ ����
----------------------------------------------------*/ 

CREATE TABLE #QTY_AVG_RECENT_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
�԰�� VARCHAR(20),
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_3MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_6MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_RECENT_12MONTH_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_THIS_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

CREATE TABLE #QTY_AVG_LAST_YEAR_MIX
(
KEY_CODE3 VARCHAR(20),
�����ڵ� VARCHAR(10),  
�ǰ��޾�ü�ڵ� VARCHAR(10),
�迭��ǰ���ڵ� VARCHAR(20), 
���ż��� FLOAT
);

GO

-- �ֱ� �� ���ż��� ��� 

-- �԰���� ���ڿ��̱� ������, 10�����ʹ� DESC �� �����ؾ���!!!!!!!


WITH TEMP_LAST_MONTH AS
(SELECT ROW_NUMBER()OVER(PARTITION BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ� ORDER BY �԰�� DESC) AS ROW_NUM,
        �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, �԰��,
		���űݾ�, ���ż���
 FROM MONTHLY_GR_LIST)

INSERT INTO #QTY_AVG_RECENT_MIX 

SELECT KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, �԰�� AS �����԰��, AVG(���ż���) AS ���ż���

FROM TEMP_LAST_MONTH

WHERE ROW_NUM = 1

GROUP BY KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, �԰��;

GO

-- �ֱ� 3���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_3MONTH_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;

GO

-- �ֱ� 6���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_6MONTH_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;


GO

-- �ֱ� 12���� ���ż��� ��� 
INSERT INTO #QTY_AVG_RECENT_12MONTH_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE �԰�� IN ('2020-7','2020-6','2020-5','2020-4','2020-3','2020-2','2020-1','2019-12','2019-11','2019-10','2019-9','2019-8')

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;

GO

-- �ݳ� ���ż��� ��� 
INSERT INTO #QTY_AVG_THIS_YEAR_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2020'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;

GO

-- ���� ���ż��� ��� 
INSERT INTO #QTY_AVG_LAST_YEAR_MIX
SELECT �����ڵ� +'>'+ �ǰ��޾�ü�ڵ�+'>'+�迭��ǰ���ڵ� AS KEY_CODE3, �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�, AVG(���ż���) AS ���ż���

FROM MONTHLY_GR_LIST

WHERE LEFT(�԰��,4) = '2019'

GROUP BY �����ڵ�, �ǰ��޾�ü�ڵ�, �迭��ǰ���ڵ�;




-- ����ó�� ǰ�� ����Ʈ 

WITH TEMP_REPORT AS
(

SELECT DISTINCT A.�����ڵ�, A.�ǰ��޾�ü�ڵ�, A.�ǰ��޾�ü��, A.�迭��ǰ���ڵ�, A.ǰ��, A.ī�װ�,A.����ںμ�,A.����ڼ���, A.�����ڱ���, A.�԰����,

	AB.���Ŵܰ� AS UNIT_AVG_LAST_YEAR_MIX, 
	AC.���Ŵܰ� AS UNIT_AVG_THIS_YEAR_MIX, 
	AD.���Ŵܰ� AS UNIT_AVG_RECENT_3MONTH_MIX, 
	AE.���Ŵܰ� AS UNIT_AVG_RECENT_6MONTH_MIX, 
	AF.���Ŵܰ� AS UNIT_AVG_RECENT_12MONTH_MIX, 
	AG.���Ŵܰ� AS UNIT_AVG_RECENT_MIX,

	AH.���ż��� AS QTY_AVG_LAST_YEAR_MIX,
	AI.���ż��� AS QTY_AVG_THIS_YEAR_MIX,
	AJ.���ż��� AS QTY_AVG_RECENT_3MONTH_MIX,
	AK.���ż��� AS QTY_AVG_RECENT_6MONTH_MIX,
	AL.���ż��� AS QTY_AVG_RECENT_12MONTH_MIX,
	AM.���ż��� AS QTY_AVG_RECENT_MIX

FROM (SELECT *, �����ڵ� +'>' + �ǰ��޾�ü�ڵ� +'>' + �迭��ǰ���ڵ� AS KEY_CODE3 FROM MONTHLY_GR_LIST) A 
    
	LEFT JOIN #UNIT_AVG_LAST_YEAR_MIX AB ON A.KEY_CODE3 = AB.KEY_CODE3             -- ǰ�� ���� ��մܰ�
	LEFT JOIN #UNIT_AVG_THIS_YEAR_MIX AC ON A.KEY_CODE3 = AC.KEY_CODE3             -- ǰ�� �ݳ� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_3MONTH_MIX AD ON A.KEY_CODE3 = AD.KEY_CODE3        -- ǰ�� �ֱ� 3���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_6MONTH_MIX AE ON A.KEY_CODE3 = AE.KEY_CODE3        -- ǰ�� �ֱ� 6���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_12MONTH_MIX AF ON A.KEY_CODE3 = AF.KEY_CODE3       -- ǰ�� �ֱ� 12���� ��մܰ�
	LEFT JOIN #UNIT_AVG_RECENT_MIX AG ON A.KEY_CODE3 = AG.KEY_CODE3                -- ǰ�� �ֱ� �԰� �ܰ�
	
	LEFT JOIN #QTY_AVG_LAST_YEAR_MIX AH ON A.KEY_CODE3 = AH.KEY_CODE3              -- ǰ�� ���� ��� ����
	LEFT JOIN #QTY_AVG_THIS_YEAR_MIX AI ON A.KEY_CODE3 = AI.KEY_CODE3              -- ǰ�� �ݳ� ��� ����
	LEFT JOIN #QTY_AVG_RECENT_3MONTH_MIX AJ ON A.KEY_CODE3 = AJ.KEY_CODE3         -- ǰ�� �ֱ� 3���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_6MONTH_MIX AK ON A.KEY_CODE3 = AK.KEY_CODE3         -- ǰ�� �ֱ� 6���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_12MONTH_MIX AL ON A.KEY_CODE3 = AL.KEY_CODE3        -- ǰ�� �ֱ� 12���� ��ռ���
	LEFT JOIN #QTY_AVG_RECENT_MIX AM ON A.KEY_CODE3 = AM.KEY_CODE3                 -- ǰ�� �ֱ� �԰� ���� 

)
SELECT 
	�����ڵ�, �ǰ��޾�ü�ڵ�, �ǰ��޾�ü��, �迭��ǰ���ڵ�, ǰ��, ī�װ�,����ںμ�,����ڼ���, �����ڱ���, �԰����,

	
	/*----------------------------------------------------
	             ����ó�� / ǰ�� ���� ������ 
	----------------------------------------------------*/ 

	-- ������� VS �ݳ����
	IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0,ROUND((QTY_AVG_THIS_YEAR_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) AS QTY_YEAR_OVER_YEAR,
	IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) AS UNIT_YEAR_OVER_YEAR,
	IIF((IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0,ROUND((QTY_AVG_THIS_YEAR_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_THIS_YEAR_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) >= 0), 'Y','N') AS YEAR_OVER_YEAR,

	-- ������� VS ����
	IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) AS QTY_LAST_YEAR_OVER_LAST_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) AS UNIT_LAST_YEAR_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_LAST_MONTH,

	-- ������� VS �ֱ� 3���� ���
	IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) AS QTY_LAST_YEAR_OVER_3_MONTH,
	IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) AS UNIT_LAST_YEAR_OVER_3_MONTH,
	IIF((IIF(QTY_AVG_LAST_YEAR_MIX = 0, 0, ROUND((QTY_AVG_RECENT_3MONTH_MIX - QTY_AVG_LAST_YEAR_MIX)/QTY_AVG_LAST_YEAR_MIX,2)) > 0) AND (IIF(UNIT_AVG_LAST_YEAR_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_3MONTH_MIX - UNIT_AVG_LAST_YEAR_MIX)/UNIT_AVG_LAST_YEAR_MIX,2)) >= 0), 'Y','N') AS LAST_YEAR_OVER_3_MONTH,

	-- �ֱ� 12���� ��� VS ����
	IIF(QTY_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_12MONTH_MIX)/QTY_AVG_RECENT_12MONTH_MIX,2)) AS QTY_12_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_12MONTH_MIX)/UNIT_AVG_RECENT_12MONTH_MIX,2)) AS UNIT_12_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_12MONTH_MIX)/QTY_AVG_RECENT_12MONTH_MIX,2)) > 0) AND (IIF(UNIT_AVG_RECENT_12MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_12MONTH_MIX)/UNIT_AVG_RECENT_12MONTH_MIX,2)) >= 0), 'Y','N') AS RECENT_12_MONTH_OVER_LAST_MONTH,

	-- �ֱ� 6���� ��� VS ����
	IIF(QTY_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_6MONTH_MIX)/QTY_AVG_RECENT_6MONTH_MIX,2)) AS QTY_6_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_6MONTH_MIX)/UNIT_AVG_RECENT_6MONTH_MIX,2)) AS UNIT_6_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_6MONTH_MIX)/QTY_AVG_RECENT_6MONTH_MIX,2)) > 0) AND (IIF(UNIT_AVG_RECENT_6MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_6MONTH_MIX)/UNIT_AVG_RECENT_6MONTH_MIX,2)) >= 0), 'Y','N') AS RECENT_6_MONTH_OVER_LAST_MONTH,
	
	-- �ֱ� 3���� ��� VS ����
	IIF(QTY_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_3MONTH_MIX)/QTY_AVG_RECENT_3MONTH_MIX,2)) AS QTY_3_MONTH_OVER_LAST_MONTH,
	IIF(UNIT_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_3MONTH_MIX)/UNIT_AVG_RECENT_3MONTH_MIX,2)) AS UNIT_3_MONTH_OVER_LAST_MONTH,
	IIF((IIF(QTY_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((QTY_AVG_RECENT_MIX - QTY_AVG_RECENT_3MONTH_MIX)/QTY_AVG_RECENT_3MONTH_MIX,2)) > 0) AND (IIF(UNIT_AVG_RECENT_3MONTH_MIX = 0, 0, ROUND((UNIT_AVG_RECENT_MIX - UNIT_AVG_RECENT_3MONTH_MIX)/UNIT_AVG_RECENT_3MONTH_MIX,2)) >= 0), 'Y','N') AS RECENT_3_MONTH_OVER_LAST_MONTH

FROM 
	TEMP_REPORT;


