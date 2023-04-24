/*
    # PL/SQL
    
    ����Ŭ���� �����ϴ� SQL ���α׷��� ����̴�.
    
    �Ϲ����� ���α׷��ְ��� ���̰� ������, ����Ŭ ���ο��� ������ ó���� ����
    
    ������ �� �� �ִ� ���������� �ڵ� �ۼ� ����̴�.
    
    �������� �������� ��� ������ �ϰ� ó���ϱ� ���� �뵵�� ����Ѵ�.
*/

SET SERVEROUTPUT ON;  /*��¹� Ȱ��ȭ*/

DECLARE    /*������ �����ϴ� ���� (�����)*/
    emp_num NUMBER;
BEGIN      /*�ڵ带 �����ϴ� ���� ���� (�����)*/
    emp_num := 10;  /*emp_num�� 10�� ��*/
    
    /*����Լ�*/
    /*DBMS_OUPUT.put_line();  �̰��� PLSQL�� ��� �Լ��̴�. SET SERVEROUTPUT ON���� �̰��� ����ϸ� �ȴ�.*/
    DBMS_OUTPUT.put_line(emp_num);
    DBMS_OUTPUT.put_line('Hello pl/sql!');
END;       /*PL/SQL�� ������ ���� (�����)*/






/*������

�Ϲ� SQL���� ��� �������� ����� �����ϰ�,

**�� ������ �ǹ��Ѵ�.
*/
/*�����ڸ� ����غ���*/
DECLARE
    A NUMBER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.put_line('A: ' || TO_CHAR(A));
END;






/* 
DML �� 

DDL���� ����� �Ұ����ϰ�, �Ϲ������� SQL���� SELECT ���� ����ϴµ�,
Ư���� ���� SELECT���� �Ʒ��� INTO���� ����ؼ� ������ �Ҵ��� �� �ִ�.

*/
DECLARE
    v_emp_name VARCHAR2(50);  /*����� ���� (���ڿ� ������ ���� ������ �ʿ��ϴ�)*/
    v_dep_name VARCHAR2(50);  /*�μ��� ����*/
BEGIN
    /*sql���� �ۼ��غ���*/
    /*employees�� departments ���̺� �ֱ� ������ ������ �ؾ� �Ѵ�.*/
    SELECT e.first_name, d.department_name
    INTO
        v_emp_name, v_dep_name /*����ٰ� SELECT���̶�� ��ȸ ����� �����ϰڴ�. �׸����� DBMS�� ���*/
    FROM employees e LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.put_line(v_emp_name || '-' || v_dep_name);
END;









/*�츰 ����2��� Ÿ���� �˱� ������ ������, �� �÷� Ÿ���� �𸥴ٸ�? �Ʒ��� ���� ���� �˾Ƽ� ��������.
��, �ش� ���̺�� ���� Ÿ���� �÷� ������ �����Ϸ��� ���̺��.�÷���%TYPE�� ��������ν� Ÿ���� ������ Ȯ���ؾ��ϴ� ���ŷο��� ���� �� �ִ�.
*/
DECLARE
    v_emp_name employees.first_name%TYPE;  
    v_dep_name departments.department_name%TYPE;  
BEGIN
    SELECT e.first_name, d.department_name
    INTO
        v_emp_name, v_dep_name 
    FROM employees e LEFT OUTER JOIN departments d
    ON e.department_id = d.department_id
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.put_line(v_emp_name || '-' || v_dep_name);
END;
