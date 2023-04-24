

/*  IF문  */
DECLARE
    v_num1 NUMBER := 10;
    v_num2 NUMBER := 5;
BEGIN
    IF
        v_num1 >= v_num2 /*v_num2보다 크다면*/
    THEN
        DBMS_output.put_line(v_num1 || '이(가) 큰 수');
    ELSE
        DBMS_output.put_line(v_num2 || '이(가) 작은 수');
    END IF;
END;



/* ELSE IF절도 있다. 그러나 PLSQL에서는 ELSIF로 쓴다.*/
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1); /*일의자리를 올린다는 뜻의 -1을 해줘야 56 78 등이 60 80으로 바뀐다*/
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE department_id = v_department_id
    AND ROWNUM =1; /*첫째값만 구해서 변수에 저장하기 위해*/
    
    DBMS_output.put_line(v_salary);
    
    /* 이제 조건문을 이용해서 샐러리가 낮다 높다까지 판단해주자*/
    IF v_salary <= 5000 THEN 
        DBMS_OUTPUT.put_line('낮음');
    ELSIF v_salary <= 9000 THEN
        DBMS_OUTPUT.put_line('중간');
    ELSE
        DBMS_OUTPUT.put_line('높음');
    END IF;
END;








/* CASE문 */
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
BEGIN
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1); /*일의자리를 올린다는 뜻의 -1을 해줘야 56 78 등이 60 80으로 바뀐다*/
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE department_id = v_department_id
    AND ROWNUM =1; /*첫째값만 구해서 변수에 저장하기 위해*/
    
    DBMS_output.put_line(v_salary);
    
    /* 이제 조건문을 이용해서 샐러리가 낮다 높다까지 판단해주자*/
    CASE
    WHEN v_salary <= 5000 THEN 
        DBMS_OUTPUT.put_line('낮음');
    WHEN v_salary <= 9000 THEN
        DBMS_OUTPUT.put_line('중간');
    ELSE
        DBMS_OUTPUT.put_line('높음');
    END CASE;
END;







/* 중첩IF문 */
DECLARE
    v_salary NUMBER := 0;
    v_department_id NUMBER := 0;
    v_commission NUMBER := 0;
BEGIN
    v_department_id := ROUND(DBMS_RANDOM.VALUE(10, 120), -1); /*일의자리를 올린다는 뜻의 -1을 해줘야 56 78 등이 60 80으로 바뀐다*/
    SELECT salary, commission_pct
    INTO v_salary, v_commission
    FROM employees
    WHERE department_id = v_department_id
    AND ROWNUM =1; /*첫째값만 구해서 변수에 저장하기 위해*/
    
    DBMS_output.put_line(v_salary);
    
    IF v_commission > 0 THEN
        IF v_commission > 0.15 THEN
            DBMS_OUTPUT.PUT_LINE(v_salary * v_commission);
        END IF;
    ELSE
        DBMS_output.put_line(v_salary);
    END IF;
END;
