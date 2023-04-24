
/* while문 */

DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1; /*제어변수로사용할것임*/
BEGIN
    WHILE v_count <= 10
    LOOP
        DBMS_OUTPUT.put_line(v_num);
        v_count := v_count + 1; /*증감식*/
        
    END LOOP;
END;








/* 탈출문 */
DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1; /*제어변수로사용할것임*/
BEGIN
    WHILE v_count <= 10
    LOOP
        DBMS_OUTPUT.put_line(v_num);
        EXIT WHEN v_count = 5; /*v_count가 1씩 올라가지만 5가 되는 순간 탈출하겠다*/
        v_count := v_count + 1; /*증감식 > 1씩 올라가면서 v_num을 출력하고 있다.*/
        
    END LOOP;
END; /* 3이 10번이 아니라 5번 반복되겠다~*/





/* for문 */
DECLARE
    v_num NUMBER := 3;
BEGIN
    FOR i IN 1..9 /*i라는 변수에 1부터 9까지 한바퀴에 하나씩 들어간다. .을 두개 작성해서 범위를 표현한다.*/
    LOOP
        DBMS_output.put_line(v_num || 'X' || i || '=' || v_num*i);
    END LOOP;
END;






/* continue */
DECLARE
    v_num NUMBER := 3;
BEGIN
    FOR i IN 1..9 /*i라는 변수에 1부터 9까지 한바퀴에 하나씩 들어간다. .을 두개 작성해서 범위를 표현한다.*/
    LOOP
        CONTINUE WHEN i = 5; /*5행은 제외하고 나온다~*/
        DBMS_output.put_line(v_num || 'X' || i || '=' || v_num*i);
    END LOOP;
END;






/* 1. 모든 구구단을 출력하는 익명 블록을 만드세요. (2단부터 9단까지) > 포문안에 포문을 열되 loop랑 and loop를 잘쓰자*/
DECLARE
v_num NUMBER := 1;
BEGIN
    FOR i IN 1..9
    LOOP
        FOR j IN 1..9
        LOOP
        DBMS_output.put_line(i || 'X' || j || '=' || i*j);
        END LOOP;
    END LOOP;
END;

/*
쌤 풀이 :
BEGIN
    FOR DAN IN 2..9
    LOOP
        DBMS_output.put_line('구구단 : ' || dan || '단');
        FOR hang IN 1..9
        LOOP
                    DBMS_output.put_line(dan || 'x' || hang || '=' || dan*hang);
        END LOOP;
        DBMS_output.put_line('---------------------------------------');
    END LOOP;
END;
*/



/* 2. INSERT를 300번 실행하는 익명 블록을 처리하세요 

board라는 이름의 테이블을 만드세요. (bno, writer, title 컬럼이 존재한다.)
bno는 SEQUENCE로 올려 주시고, writer와 title에 번호를 붙여서 INSERT 진행해 주세요.
EX) 1, test1, title1 > 2, test2, title2 > 3, test3 title3 (즉, 반복문으로 INSERT 300번때려라)
와일문이든 포문이든 상관X
*/

CREATE TABLE board
( 
    bno NUMBER PRIMARY KEY,
    writer VARCHAR2(50) NOT NULL,
    title VARCHAR2(50) NOT NULL
);

CREATE SEQUENCE b_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 1000
    NOCYCLE
    NOCACHE;
    
DECLARE
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 300
    LOOP
        INSERT INTO board
        VALUES(b_seq.NEXTVAL, 'text'||v_num, 'title'||v_num);
        v_num := v_num + 1;
    END LOOP;
    COMMIT;
END;

SELECT *
FROM board
ORDER BY bno DESC;