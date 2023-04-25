/* after Ʈ���� -> INSERT, UPDATE, DELETE ���� �۾� ���Ŀ� �����ϴ� Ʈ���Ÿ� �ǹ��Ѵ�. */

/* before Ʈ���� -> INSERT, UPDATE, DELETE ���� �۾� ������ �����ϴ� Ʈ���Ÿ� �ǹ��Ѵ�. */


/*
���� ������ �� ����,
:OLD -> ���� �� ���� �� (EX INSERT:�Է� �� �ڷ�, UPDATE: ���� �� �ڷ�, DELETE: ������ ��)
:NEW -> ���� �� ���� �� (EX INSERT:�Է� �� �ڷ�, UPDATE: ���� �� �ڷ�)

���̺� UPDATE�� DELETE�� �õ��ϸ� ����, �Ǵ� ������ �����͸�
������ ���̺� ������ ���� �������� Ʈ���Ÿ� ���� ����Ѵ�. 
*/


/*���̺� �����غ���*/
CREATE TABLE tbl_user(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30)
);


/* tbl_user�� ��� ���̺� �ϳ� ������̴�. ������ �͵鵵 ó���غ��� */
CREATE TABLE tbl_user_backup(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30),
    update_date Date DEFAULT sysdate, /*���� �ð�*/
    m_type VARCHAR2(10), /*���� Ÿ��*/
    m_user VARCHAR2(20)  /*������ �����(�����߿� ������ ����� �����ΰ�*/
);



/* after Ʈ���Ÿ� ���� ���� ���� */
CREATE OR REPLACE TRIGGER trg_user_backup
/*Ʈ���Ÿ� ���� ��ų ������*/
    AFTER UPDATE OR DELETE /*������Ʈ�� ����Ʈ ���Ŀ� ���۽�ų ���̴�*/
    ON tbl_user /*�������̺� ���� ���̴�.*/
    FOR EACH ROW /*��ο��� �����ϰڴ�.*/
DECLARE /*������ ���������� ����� ������ �����ϴ� ��*/
    v_type VARCHAR2(10);
BEGIN
    /*��乮���� Ʈ���Ű� ������Ʈ�� ����Ʈ ���Ŀ� ������ ���ٵ�,
      ���� Ʈ���� ������ ������Ʈ �������� ���� �������� �ľ��ؾ� �Ѵ�.
      IF���� �̿��ؼ� ������ �� ���̴�.*/
    IF UPDATING THEN /*UPDATING�� �ý��� ��ü���� ���¿� ���� ������ �����ϴ� ��Ʈ�� ����(�⺻������ �����).*/
        v_type := '����';
    ELSIF DELETING THEN
        v_type := '����';
    END IF;
    
    /* ������̺� ������� Ÿ���� �ѰŰ� ���� �������� ���� ������ �� ���̴�. */
    /* 
       ���� ���������� ���������� �Ǵ��� �ؼ� v_type������ �����̳� ���� ���� �־���,
       ���������� �� ���� �����ǰ��ִ� �� ����, �����ǰ� �ִ� �� ������ ������̺� INSERT�� �� ���̴�.
    */    
    INSERT INTO tbl_user_backup
    /*���� ���̳� ���� ���� ������ VALUES�� ������߰���.*/
    VALUES(:OLD.id, :OLD.name, :OLD.address, sysdate, v_type, user()); /*user()�� ���� �������� ����� ���� ��ü�� ǥ�����ش�. �츰 hr�� ���������� hr�� ����ڰ� �ǰڴ�.*/
END;



/* Ȯ�� */
INSERT INTO tbl_user
VALUES ('test01', 'kim', '����');
INSERT INTO tbl_user
VALUES ('test02', 'lee', '��⵵');
INSERT INTO tbl_user
VALUES ('test03', 'hong', '�λ�');

SELECT * FROM tbl_user;
SELECT * FROM tbl_user_backup; /*�� ���� ����ְ���*/


UPDATE tbl_user SET address='��õ' WHERE id='test01'; /*id�� test01�� ����� address�� ��õ���� �����ϰڴ�.*/
/*Ʈ���Ű� ���Ұ���. ����� Ȯ���غ���*/



/*�̹��� ����Ʈ*/
DELETE FROM tbl_user WHERE id = 'test01';






/*�̹��� BEFORE Ʈ���Ÿ� �����غ���*/
CREATE OR REPLACE TRIGGER trg_user_insert
    BEFORE INSERT 
    ON tbl_user /*�������̺�����*/
    FOR EACH ROW
BEGIN
    /*INSERT �Ǳ� ���� BEFOREƮ���Ű� ����ȴ�. */
    :NEW.name := SUBSTR(:NEW.name, 1, 1) || '**'; /*���� ¥���� �������� **�� ó���ϰڴ�.*/
END;

/*�μ�Ʈ�غ���*/
INSERT INTO tbl_user VALUES('test04', '�޷���', '����');

















/* 
Ʈ������ Ȱ�� -> INSERT�� ������ �ֹ� ���̺��� �̷�����. -> 
�ֹ� ���̺� INSERT Ʈ���� ���� (��ǰ ���̺� ������Ʈ ����� �ϰ� �ȴٸ�)
*/
/*�����ϰ� �ֹ��������� �������� �������� Ȯ���غ���~*/


/*�ֹ������丮*/
CREATE TABLE order_history (
    history_no NUMBER(5) PRIMARY KEY,
    order_no NUMBER(5),
    product_no NUMBER(5),
    total NUMBER(10),
    price NUMBER(10)
);

/*��ǰ (��ǰ�� �־�� �ֹ��� �����ϴ�..)*/
CREATE TABLE product(
    product_no NUMBER(5) PRIMARY KEY,
    product_name VARCHAR2(20),
    total NUMBER(5),
    price NUMBER(5)
);


/*history_no, product_no�� ���� ������ ������*/
CREATE SEQUENCE order_history_seq NOCACHE;

CREATE SEQUENCE product_seq NOCACHE;



/*���� ��ǰ�� ���� ����*/
INSERT INTO product VALUES(product_seq.NEXTVAL, '����', 100, 10000);
INSERT INTO product VALUES(product_seq.NEXTVAL, 'ġŲ', 100, 20000);
INSERT INTO product VALUES(product_seq.NEXTVAL, '�ܹ���', 100, 5000);


SELECT *
FROM product;

/*
���� 3�ǵ����� ����ǰ���� 3���� �������ϴ� 97���� �Ǿ������? 
��, �ֹ����̺� �μ�Ʈ�ɶ����� ���δ�Ʈ�� �ִ� ��ǰ������ �������Ѵ�.
Ʈ�������� ��Ű��~
*/
/*��, �ֹ� �����丮�� �����Ͱ� ������ Ʈ���Ÿ� �����غ���*/
CREATE OR REPLACE TRIGGER trg_order_history
    AFTER INSERT
    ON order_history
    FOR EACH ROW
    
DECLARE
    v_total NUMBER;
    v_product_no NUMBER;
BEGIN
    DBMS_output.put_line('Ʈ���� ����!');
    
    
    
    /*Ʈ����Ȱ��*/
    SELECT
        :NEW.total /*�μ�Ʈ�ǰ��ִ� ������ �ľ�����*/
    INTO
        v_total
        FROM dual;
    
    /*��ǰ�� ���������� Ȯ���� ���� */
    v_product_no := :new.product_no;
    UPDATE product SET total = total - v_total /*����ǰ���̺��� ������ �����ϴ� ���� �� �� �ִ�. */
    WHERE product_no = v_product_no;
END;


/*�ֹ��̵������� */
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 1, 5, 50000); /*�μ�Ʈ�ǰ��ִ� ������ �ľ�����*/
/*�׷����� ���οö󰡼� Ʈ����Ȱ��.*/

SELECT *
FROM product;
    