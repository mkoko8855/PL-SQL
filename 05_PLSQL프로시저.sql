
/* 
���ν���(procedure) > �⺻���´� void�޼���� �����ϴ�. �׷��� ���ϵ� �����ϴ� 

���ν�����? Ư���� ������ ó���ϰ� ������� ��ȯ���� �ʴ� �ڵ� ���(����)
������ ���ν����� ���ؼ� ���� �����ϴ� ����� �ִ�. ���� �⺻ ���´� ��ȯ ���� ������, ��ȯ�ϴ� ��쵵 �ִٴ� ���̴�.
*/


/*�Ű���(�μ�) �� ���� ���ν���*/
/*CREATE�� �̿��ؼ� �����Ѵ�!*/
CREATE PROCEDURE p_test
IS /*���⼭���� ����ΰ� ����. ���� DECLARE�� �����. ���������� ���� ���� �κ��̴�.*/
    /*v_msg��� ������ Hello Procedure!�� �ٷ� �����Ͽ���.*/
    v_msg VARCHAR2(30) := 'Hello Procedure!'; 
BEGIN
    /*����� ������̸� �����ϰ� ����غ���*/
    DBMS_output.put_line(v_msg);
END; /*CREATE���� ���� ���� �� �� EXEC P_test�� ȣ���ϴ� ���̴�.*/
/*���� ���ν��� ȣ���غ���*/
EXEC p_test;  









/* ���ν����� ���� �޾Ƽ� ó���� �� �ִ� ������ �ִ�. */
/* ���� ���޹޴´ٴ� �ǹ̿��� IN�̶�� Ű���尡 �ִ�.*/

/* ��, IN �Է°��� ���޹޴� �Ķ����*/
/*IN�� �Ẹ�� ���� ���ν��� �����غ���*/
CREATE PROCEDURE my_new_job_proc
    /*��ġ �Լ��� �Ű������� �����ϴ� �� ó�� ������ ������ �� �ִ�.*/
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE,
     p_max_sal IN jobs.max_salary%TYPE
    )
    /*
    ������� 4���� ������ ������ �ްڴ� ��� ������ INŰ���带 ����ߴ�. ���ν��� ������ 4���� ���� ���´ٴ� ���̴�.
    */
IS
/*IS�� ������ �����ϴ� �ܰ鵥 ���� ���� �ҰԾ����� �ѱ���*/
BEGIN
/*INSERT�� �غ���*/
INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal); /*������ �Ű������鿡 ���� �־���*/
COMMIT;

END;

EXEC my_new_job_proc('JOB1','test job1', 7777, 9999); /*�̷��� ȣ���� �ϰڴ� ��� �ǹ��̴�. �� ������ ���� IN���� ��������.*/
/*������, jobs���̺��� Ȯ���غ���*/
SELECT *
FROM jobs;












/* �׷����� ������ ���� �����غ��� */
/* �並 �����ҋ� CREATE OR REPLACE�� ����߾���. ���ν����� �Ȱ��� ������ �� �ִ�. ������ ������ �Ǵ� ���̴�. ������ �ִ� ���ν����� ���ν����� �����ǰ���*/

/*��, job_id�� Ȯ���ؼ� �̹� �����ϴ� �����Ͷ�� ����, ���ٸ� ���Ӱ� �߰��ϴ� ����� ������*/
CREATE OR REPLACE PROCEDURE my_new_job_proc /*���� ���ν����� �ణ�� �����ϰڴ�.*/
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE,
     p_max_sal IN jobs.max_salary%TYPE
    )
    /*
    ������� 4���� ������ ������ �ްڴ� ��� ������ INŰ���带 ����ߴ�. ���ν��� ������ 4���� ���� ���´ٴ� ���̴�.
    */
IS
/*������ �Ű������� ������ �� 4�� �Ű��͵��� select������ Ȯ���ؼ�, �ش� job_id�� �����Ѵٸ� insert���� update�� ������ ���̴�.
����, �������� �ʴٸ� insert�� ������ �� ���̴�. ���ǹ��� �ʿ��ϰ���. �׷��� ������ ��������.
*/
    v_cnt NUMBER := 0; /*COUNT�� �� ���� ����.*/
    
BEGIN
/*������ job_id�� �ִ������� üũ > �����ϸ� 1, �������� ������ 0 > �� ���θ� v_cnt�� �����Ұ��̴�.*/

    SELECT COUNT(*) /*�� ī��Ʈ�� ����� v_cnt�� ������� INTO�� ������*/
    INTO
        v_cnt /*�ش� job_id�� �����ϴ��� Ȯ���� �� �ְ��� ���� ���ǹ��������� IF�� ����*/
    FROM jobs
    WHERE job_id = p_job_id; 
    
    IF v_cnt = 0 THEN /*0�̶�� �� job_id�� ���ٴ� ���̴� INSERT ����� ����*/
        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE /* job_id�� �ִ°Ŵ� UPDATE�� �����ؾ߰���*/
        UPDATE jobs
        SET job_title = p_job_title, /*job_title�̶�� �÷��� p_job_title���� �ִ´�.*/
        min_salary = p_min_sal,
        max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;
















/*�̹��� �Ű���(�μ�)�� ����Ʈ ��(�⺻��)�� �����Ѵ�. */
CREATE OR REPLACE PROCEDURE my_new_job_proc 
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE := 0,/*max�� min�� �⺻���� �����غ���*/
     p_max_sal IN jobs.max_salary%TYPE := 1000 /*�̰Թ������̳�? �ΰ� �ƽ� ���� �������������� 0�� 1õ���� �����ϰڴٴ� ���̴�.*/
    )
IS
    v_cnt NUMBER := 0; 
BEGIN
    SELECT COUNT(*) 
    INTO
        v_cnt 
    FROM jobs
    WHERE job_id = p_job_id; 

    IF v_cnt = 0 THEN
        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE 
        UPDATE jobs
        SET job_title = p_job_title,
        min_salary = p_min_sal,
        max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;
/*ȣ������*/
EXEC my_new_job_proc('JOB5', 'test job5');

SELECT * FROM jobs; /*0�� 1õ�� �� ���� �� �� �ִ�. */









/*--------------------------------------------------------------------------*/







/* IN���� OUT���ְ� INOUT�� ������ ����غ���*/
/* OUT�� ���ν��� �ٱ����� ���� ���� �� �ִ�. OUT�� �̿��ؼ� ���� ���� �ٱ� �͸� ��Ͽ��� �����ؾ� �Ѵ�. */
CREATE OR REPLACE PROCEDURE my_new_job_proc 
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE := 0,/*max�� min�� �⺻���� �����غ���*/
     p_max_sal IN jobs.max_salary%TYPE := 1000, /*�̰Թ������̳�? �ΰ� �ƽ� ���� �������������� 0�� 1õ���� �����ϰڴٴ� ���̴�.*/
     p_result OUT VARCHAR2 /*�ٱ��ʿ��� ����� �ϱ� ���� ����*/
    )
IS
    v_cnt NUMBER := 0; 
    v_result VARCHAR(100) := '���� ��� INSERT ó�� �Ǿ����ϴ�.';
    
BEGIN
    SELECT COUNT(*) 
    INTO
        v_cnt 
    FROM jobs
    WHERE job_id = p_job_id; 

    IF v_cnt = 0 THEN
        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE 
       /*������Ʈ�� �����, �̹��� ������ �����ϴ� �����Ͷ�� ����� ���� �� ���̴�. v_result������ ��Ƽ� �ٱ����� ���� ���̴�. */
       /*�����ִ�. ��, ������ �����Ѵٸ�*/
       SELECT
        p_job_id || '�� �ִ� ����: ' || max_salary || ', �ּ� ������: ' || min_salary
        INTO
            v_result /*SELECT�� ����� v_result�� ���� ���̴�.*/
       FROM jobs
       WHERE job_id = p_job_id;
    END IF;
    /*OUT �Ű������� ����� �Ҵ��ϰڴ�.*/
    p_result := v_result;
    
    COMMIT;
END;
/*my_new_job_proc�� �θ��� > �͸����� �̸��� ����.*/
DECLARE
    str VARCHAR2(100);
BEGIN
    my_new_job_proc(
        'job1', 'test_job1', 2000, 8000, str);
        /*������ ������ str���� ���� ���������� > ��? my_new_job_proc�� ���� �Ű����� 5���޴´�. 
        4���� IN�ε�, IN�� ���� �����ϸ� ���� ���ν��� ���ο��� ��������� ������ �ϳ��� ���� OUT������ ������ 
        str������ p_result���� ������ ���� Ȱ���ϴ� ���̴�.
        */
        DBMS_output.put_line(str);
        my_new_job_proc('CEO', 'test_CEO', 20000, 80000, str); /*���غ����� ���. ������ CEO�� ������ INSERTó���� �ǰ��� > ���� ������ INSERT�Ǿ����ϴٰ� ����� �ȴ�.*/
        DBMS_output.put_line(str);
END;






/*--------------------------------------------------------------------------*/





/*INOUT�� �Ẹ�� > IN OUT INOUT�´� Ȯ���غ���*/
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
/*�Ű��� �޴� ��ȣ �����*/
    (
        /*IN�� �ޱ⸸ �ϰ� ��ȯ�� �Ұ����ϴ�.*/
        p_var1 IN VARCHAR2,
        /*OUT�� ���ν����� ������ ������ ���� �Ҵ��� �ȵ�. �����߸� OUT�� ����. ��, �޴¿뵵�δ� �� �� ����. �޴� �뵵�� ������ IN�� ����ؾ� �Ѵ�. */
        p_var2 OUT VARCHAR2,
        /*IN OUT�� IN���ǰ� OUT�� �ȴ�.*/
        p_var3 IN OUT VARCHAR2
    )
/*IS�� �����ʿ������*/
IS

BEGIN
    DBMS_output.put_line('p_var1: ' || p_var1); /*��*/
    DBMS_output.put_line('p_var2: ' || p_var2); /*OUT�� �޴� �뵵�� �� ������ �ȵǰ���*/
    DBMS_output.put_line('p_var3: ' || p_var3); /*IN�� ���������� ��*/
    
--    p_var1 := '���1';
    p_var2 := '���2';
    p_var3 := '���3';

    
END;


/*�͸��� ����*/
DECLARE
    v_var1 VARCHAR2(10) := 'value1';
    v_var2 VARCHAR2(10) := 'value2';
    v_var3 VARCHAR2(10) := 'value3';
BEGIN
    /*���ν���ȣ��*/
    my_parameter_test_proc(v_var1, v_var2, v_var3); /*3�� �� ���ν������� �����غ��� > var1�� p_var1����, var2�� p_var2 �̷�������.. �޴��� �ȹ޴��� üũ�غ���*/

    
    DBMS_output.put_line('v_var1: ' || v_var1);
    DBMS_output.put_line('v_var2: ' || v_var2);
    DBMS_output.put_line('v_var3: ' || v_var3);

END;
/*����� p_var1: value1 > IN���� ���������� �ȴ�. */
/*����� p_var2: value2 > OUT���� ���������� �ȵȴ�. OUT�� ���� ������ �ȵǴ� �ȵȴ�.*/
/*����� p_var3: value3 > INOUT���� ���������� �ȴ�. */



/*
�̹��� ���� �Ҵ��غ��� BEGIN���� �߰����� > ���� �����ؼ� �ٱ����� �������������˾ƺ�������! 
p_var = ��� ���� ���ְ�
���� �͸������� �����ͼ� OUT�� �Ǵ��� Ȯ���� �غ���
BEGIN���� �� DBMS���� �߰�������. �غ��� ������ ����. p_var1�� �Ҵ��� ������� Ȱ���� �� ���ٰ� �Ѵ�.
��, ���ν��� ��ü�� �ȸ�������ٴ� �Ŵ�. ��, IN������ ���� ���� ��ü�� �ȵǰ� ���޹޴� �뵵�θ� ����� �ȴ�. ���� �Ҵ��� �ƿ� �Ұ����ϴ�.
���1, 2, 3�ذſ� ���1�� �ּ�ó�� �ϰ� �ٽ� �����ϸ� �� �ȴ�.


��� ���
p_var1: value1
p_var2: 
p_var3: value3
v_var1: value1
v_var2: ���2
v_var3: ���3
*/






/*--------------------------------------------------------------*/



/*�̹��� RETURN Ű���� �̴�. > ���ν��� ���� ���ῡ �� �� �ִ�. */



CREATE OR REPLACE PROCEDURE my_new_job_proc 
    (p_job_id IN jobs.job_id%TYPE,
     p_result OUT VARCHAR2 /*�ٱ��ʿ��� ����� �ϱ� ���� ����*/
    )
IS
    v_cnt NUMBER := 0; 
    v_result VARCHAR(100) := '���� ��� INSERT ó�� �Ǿ����ϴ�.';
    
BEGIN
    SELECT COUNT(*) 
    INTO
        v_cnt 
    FROM jobs
    WHERE job_id = p_job_id; 

        IF v_cnt = 0 THEN /*������� INSERT �ڸ�����, ������ ����� ����� ��� ������*/
        DBMS_output.put_line(p_job_id || '�� ���̺� �������� �ʽ��ϴ�.');
        RETURN; /*���ν��� ���� ���� > �׷��� ���� ELSE�� �ʿ䰡 ����. ELSE����� END IF������*/
        END IF;
        
        SELECT
        p_job_id || '�� �ִ� ����: ' || max_salary || ', �ּ� ������: ' || min_salary
        INTO
            v_result /*SELECT�� ����� v_result�� ���� ���̴�.*/
        FROM jobs
        WHERE job_id = p_job_id;
        
        /*OUT�Ű������� �Ҵ��ϴ� �κ�*/
        p_result := v_result;
        COMMIT;
END;

/*������ ������ �͸��Ͽ��� �׽�Ʈ����~*/
DECLARE
    str VARCHAR2(100);
BEGIN
    my_new_job_proc('�޷�', str);
    
    
    /*str������ out�Ǵ� ���� �������ֱ� ���� ���Ű� �޷��� ���� ���� ������.*/
    DBMS_output.put_line(str);
    /*��� : �޷��� ���̺� �������� �ʽ��ϴ�.*/

    
    /*���� �ִ°Ÿ� ����� �߰���*/
    my_new_job_proc('IT_PROG', str);
    DBMS_output.put_line(str);
    /*IT_PROG�� �ִ� ����: 10000, �ּ� ������: 4000*/
END;









/*------------------------------------------------------*/







/* ������ ����ó�� �̴�. */
DECLARE
    v_num NUMBER := 0;
BEGIN
    v_num := 10 / 0;
    

/*
����� OTHERS �ڸ��� ���� Ÿ���� �ۼ����� ���� �ִ�.
ACCESS_INTO_NULL -> ��ü �ʱ�ȭ�� �Ǿ� ���� ���� ���¿��� ����Ϸ��� �ҋ�.
NO_DATE_FOUND -> SELECT INTO �� �����Ͱ� �� �ǵ� ���� ��
ZERO_DIVIDE -> 0���� ���� ��
VALUE_ERROR -> ��ġ �Ǵ� ���� ������ ���� ��
INVALID_NUMBER -> ���ڸ� ���ڷ� ��ȯ�� �� ������ ���
*/
    
/*����Ȯ�������� ����ó������*/
EXCEPTION WHEN OTHERS THEN 
    DBMS_output.put_line('0���� ���� ���� �����ϴ�.');
    /*�����ڵ嵵 ����� �����ϴ�.*/
    DBMS_output.put_line('SQL ERROR CODE: ' || SQLCODE);
    /*�����޽����� ����� �����ϴ�.*/
    DBMS_output.put_line('SQL ERROR MSG: ' || SQLERRM);
END; /*���������. �Ϻη� ������ �� ���̴�. �ö󰡼� ����ó��������*/

/*WHEN ZERO_DIVIDE THEN
DBMS~~
DBMS~~
DBMS~~
WHEN OTHERS THEN
DBMS~~('�˼����¿��ܹ߻�'); �̷������ε� ��
*/


