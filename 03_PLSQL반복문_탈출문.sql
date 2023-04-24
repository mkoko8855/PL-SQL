
/* while�� */

DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1; /*������λ���Ұ���*/
BEGIN
    WHILE v_count <= 10
    LOOP
        DBMS_OUTPUT.put_line(v_num);
        v_count := v_count + 1; /*������*/
        
    END LOOP;
END;








/* Ż�⹮ */
DECLARE
    v_num NUMBER := 3;
    v_count NUMBER := 1; /*������λ���Ұ���*/
BEGIN
    WHILE v_count <= 10
    LOOP
        DBMS_OUTPUT.put_line(v_num);
        EXIT WHEN v_count = 5; /*v_count�� 1�� �ö����� 5�� �Ǵ� ���� Ż���ϰڴ�*/
        v_count := v_count + 1; /*������ > 1�� �ö󰡸鼭 v_num�� ����ϰ� �ִ�.*/
        
    END LOOP;
END; /* 3�� 10���� �ƴ϶� 5�� �ݺ��ǰڴ�~*/





/* for�� */
DECLARE
    v_num NUMBER := 3;
BEGIN
    FOR i IN 1..9 /*i��� ������ 1���� 9���� �ѹ����� �ϳ��� ����. .�� �ΰ� �ۼ��ؼ� ������ ǥ���Ѵ�.*/
    LOOP
        DBMS_output.put_line(v_num || 'X' || i || '=' || v_num*i);
    END LOOP;
END;






/* continue */
DECLARE
    v_num NUMBER := 3;
BEGIN
    FOR i IN 1..9 /*i��� ������ 1���� 9���� �ѹ����� �ϳ��� ����. .�� �ΰ� �ۼ��ؼ� ������ ǥ���Ѵ�.*/
    LOOP
        CONTINUE WHEN i = 5; /*5���� �����ϰ� ���´�~*/
        DBMS_output.put_line(v_num || 'X' || i || '=' || v_num*i);
    END LOOP;
END;






/* 1. ��� �������� ����ϴ� �͸� ����� ���弼��. (2�ܺ��� 9�ܱ���) > �����ȿ� ������ ���� loop�� and loop�� �߾���*/
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
�� Ǯ�� :
BEGIN
    FOR DAN IN 2..9
    LOOP
        DBMS_output.put_line('������ : ' || dan || '��');
        FOR hang IN 1..9
        LOOP
                    DBMS_output.put_line(dan || 'x' || hang || '=' || dan*hang);
        END LOOP;
        DBMS_output.put_line('---------------------------------------');
    END LOOP;
END;
*/



/* 2. INSERT�� 300�� �����ϴ� �͸� ����� ó���ϼ��� 

board��� �̸��� ���̺��� ���弼��. (bno, writer, title �÷��� �����Ѵ�.)
bno�� SEQUENCE�� �÷� �ֽð�, writer�� title�� ��ȣ�� �ٿ��� INSERT ������ �ּ���.
EX) 1, test1, title1 > 2, test2, title2 > 3, test3 title3 (��, �ݺ������� INSERT 300��������)
���Ϲ��̵� �����̵� ���X
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