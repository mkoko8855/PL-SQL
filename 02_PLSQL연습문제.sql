SET SERVEROUTPUT ON;


/* 1. ������ �� 3���� ����ϴ� �͸� ����� ����� ���� (��¹� 9���� �����ؼ� ������)*/

DECLARE
    
BEGIN
   DBMS_OUTPUT.PUT_LINE('3 * 1 = ' || 3*1); 
   DBMS_OUTPUT.PUT_LINE('3 * 2 = ' || 3*2); 
   DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3*3); 
   DBMS_OUTPUT.PUT_LINE('3 * 4 = ' || 3*4); 
   DBMS_OUTPUT.PUT_LINE('3 * 5 = ' || 3*5); 
   DBMS_OUTPUT.PUT_LINE('3 * 6 = ' || 3*6); 
   DBMS_OUTPUT.PUT_LINE('3 * 7 = ' || 3*7); 
   DBMS_OUTPUT.PUT_LINE('3 * 8 = ' || 3*8); 
   DBMS_OUTPUT.PUT_LINE('3 * 9 = ' || 3*9);
END;


/* 2. employees ���̺��� 201�� ����� �̸��� �̸��� �ּҸ� ����ϴ� �͸���(��Ŭ,���,����)�� ����� ����
(������ ��Ƽ� ����� �غ���)
*/

DECLARE
     v_emp_name employees.first_name%TYPE;  
     v_emp_email employees.EMAIL%TYPE; 
BEGIN
    SELECT first_name, email
    INTO /*�������� INTO Ű���带 ����Ѵ�*/
    v_emp_name, v_emp_email
    FROM employees
    WHERE employee_id = 201;
    DBMS_OUTPUT.put_line(v_emp_name || ': ' || v_emp_email);
END;
    










/*
  3. employees ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� �� (MAX�Լ����),
  �� ��ȣ +1������ �Ʒ��� ����� emps��� ���̺� employee_id, last_name, email, hire_date, job_id��
  �ű� �����ϴ� �͸� ����� ���弼��.
  SELECT �� ���Ŀ� INSERT�� ����� �����ϴ�.
  
  ����� : steven
  �̸��� : stevenjobs
  �Ի����� : ���ó�¥
  job_id : CEO
  �� �־�����.
*/

DROP TABLE emps;
CREATE TABLE emps AS (SELECT * FROM employees WHERE 1 = 2);


DECLARE
    v_emp_id employees.employee_id%TYPE;
BEGIN
   SELECT max(employee_id) 
   INTO v_emp_id /*206���� ����ٰ� �����Ѵ�.*/
   FROM employees;
   INSERT INTO emps
    (employee_id, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES
    (v_emp_id+1, 'steven', 'stevenjobs', sysdate, 'CEO');
END;



