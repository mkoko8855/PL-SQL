CREATE TABLE users(
    user_number NUMBER(5) PRIMARY KEY,
    user_name VARCHAR2(20) NOT NULL,
    phone_number VARCHAR2(30) NOT NULL,
    total_paying NUMBER(10) DEFAULT 0,
    grade VARCHAR2(10) DEFAULT 'BRONZE'
);

CREATE SEQUENCE users_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 100000 /*5��� ���������ϱ� 10������*/
    NOCYCLE
    NOCACHE;






SELECt *
FROM users;  /*1���� 1���� ȸ�������ý��� > �ű�ȸ���߰� ����� �Ϸ�� ���� �� �� �ִ�. ��, �����Ͱ� ���Դ�.*/








CREATE TABLE movie (
    serialNumber NUMBER(5) PRIMARY KEY,
    movie_name VARCHAR2(50) NOT NULL,
    nation VARCHAR2(20) NOT NULL,
    pub_year DATE,
    rental VARCHAR2(1) NOT NULL
);

CREATE SEQUENCE movie_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 100000
    NOCYCLE
    NOCACHE;


SELECT *
FROM movie;



DROP TABLE order_history;


CREATE TABLE order_history (
    order_no NUMBER(5) PRIMARY KEY,
    user_number NUMBER(5) NOT NULL,
    serial_number NUMBER(5) NOT NULL,
    order_date DATE DEFAULT sysdate, /*�μ�Ʈ�ɶ� �ڵ����� �Ǳ� ���� ����Ʈ*/
    return_date DATE DEFAULT sysdate + 3
);

CREATE SEQUENCE order_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 100000
    NOCYCLE
    NOCACHE;
    


/*Ʈ���Ÿ� ��������*/
CREATE OR REPLACE TRIGGER trg_order_history
 AFTER INSERT
 ON order_history
 FOR EACH ROW

DECLARE
 --�ٸ� ���̺��� ������ ���� �������� ���̴�
 --������ ���� �ľ��� �ʿ� ������ ��ȭ ��ȣ�� ����
 v_serial_number NUMBER;
BEGIN
 SELECT
    :NEW.serial_number
INTO v_serial_number --�� new.~~�ѹ��� �� �������� �ְڴ�. �׷��� ���� ������Ʈ ����
 FROM dual;
 
 UPDATE movie SET rental = 'false'
 WHERE serial_number = v_serial_number; 
 
 --�뿩�� �����ؼ� �̷��� ���. ������ �ݳ��� ����ؾ� �Ѵ�.
 
END;

