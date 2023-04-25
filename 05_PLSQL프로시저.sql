
/* 
프로시저(procedure) > 기본형태는 void메서드와 유사하다. 그러나 리턴도 가능하다 

프로시저란? 특정한 로직을 처리하고 결과값을 반환하지 않는 코드 덩어리(쿼리)
하지만 프로시저를 통해서 값을 리턴하는 방법도 있다. 가장 기본 형태는 반환 하지 않지만, 반환하는 경우도 있다는 것이다.
*/


/*매개값(인수) 가 없는 프로시저*/
/*CREATE로 이용해서 생성한다!*/
CREATE PROCEDURE p_test
IS /*여기서부터 선언부가 들어간다. 어젠 DECLARE를 썼었다. 마찬가지로 변수 선언 부분이다.*/
    /*v_msg라는 변수에 Hello Procedure!를 바로 대입하였다.*/
    v_msg VARCHAR2(30) := 'Hello Procedure!'; 
BEGIN
    /*비긴은 실행부이며 간단하게 출력해보자*/
    DBMS_output.put_line(v_msg);
END; /*CREATE문을 먼저 실행 한 후 EXEC P_test를 호출하는 것이다.*/
/*이제 프로시저 호출해보자*/
EXEC p_test;  









/* 프로시저도 값을 받아서 처리할 수 있는 문법이 있다. */
/* 값을 전달받는다는 의미에서 IN이라는 키워드가 있다.*/

/* 즉, IN 입력값을 전달받는 파라미터*/
/*IN을 써보기 위해 프로시저 생성해보자*/
CREATE PROCEDURE my_new_job_proc
    /*마치 함수의 매개변수를 선언하는 것 처럼 변수를 선언할 수 있다.*/
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE,
     p_max_sal IN jobs.max_salary%TYPE
    )
    /*
    순서대로 4개의 변수에 전달을 받겠다 라는 뜻으로 IN키워드를 사용했다. 프로시저 안으로 4개의 값이 들어온다는 것이다.
    */
IS
/*IS는 변수를 선언하는 단곈데 딱히 딱히 할게없으니 넘기자*/
BEGIN
/*INSERT를 해보자*/
INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal); /*맨위의 매개변수들에 값을 넣어줌*/
COMMIT;

END;

EXEC my_new_job_proc('JOB1','test job1', 7777, 9999); /*이렇게 호출을 하겠다 라는 의미이다. 이 값들은 위의 IN절로 보내진다.*/
/*다한후, jobs테이블을 확인해보자*/
SELECT *
FROM jobs;












/* 그럼이제 기존의 것을 수정해보자 */
/* 뷰를 수정할떄 CREATE OR REPLACE를 사용했었다. 프로시저도 똑같이 적용할 수 있다. 없으면 생성이 되는 것이다. 기존에 있는 프로시저면 프로시저가 수정되겠지*/

/*즉, job_id를 확인해서 이미 존재하는 데이터라면 수정, 없다면 새롭게 추가하는 기능을 만들어보자*/
CREATE OR REPLACE PROCEDURE my_new_job_proc /*기존 프로시저를 약간만 수정하겠다.*/
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE,
     p_max_sal IN jobs.max_salary%TYPE
    )
    /*
    순서대로 4개의 변수에 전달을 받겠다 라는 뜻으로 IN키워드를 사용했다. 프로시저 안으로 4개의 값이 들어온다는 것이다.
    */
IS
/*이제는 매개값으로 들어오는 위 4개 매개것들을 select떄려서 확인해서, 해당 job_id가 존재한다면 insert말고 update를 진행할 것이다.
만약, 존재하지 않다면 insert를 진행을 할 것이다. 조건문도 필요하겠지. 그래서 변수를 선언하자.
*/
    v_cnt NUMBER := 0; /*COUNT를 찍어볼 변수 선언.*/
    
BEGIN
/*동일한 job_id이 있는지부터 체크 > 존재하면 1, 존재하지 않으면 0 > 이 여부를 v_cnt에 저장할것이다.*/

    SELECT COUNT(*) /*이 카운트의 결과를 v_cnt에 담기위해 INTO를 써주자*/
    INTO
        v_cnt /*해당 job_id가 존재하는지 확인할 수 있겠지 이제 조건문쓰러가자 IF절 ㄱㄱ*/
    FROM jobs
    WHERE job_id = p_job_id; 
    
    IF v_cnt = 0 THEN /*0이라는 건 job_id가 없다는 것이니 INSERT 해줘야 겠지*/
        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
    ELSE /* job_id가 있는거니 UPDATE를 진행해야겠지*/
        UPDATE jobs
        SET job_title = p_job_title, /*job_title이라는 컬럼에 p_job_title값을 넣는다.*/
        min_salary = p_min_sal,
        max_salary = p_max_sal
        WHERE job_id = p_job_id;
    END IF;
    COMMIT;
END;
















/*이번엔 매개값(인수)의 디폴트 값(기본값)을 설정한다. */
CREATE OR REPLACE PROCEDURE my_new_job_proc 
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE := 0,/*max와 min의 기본값을 설정해보자*/
     p_max_sal IN jobs.max_salary%TYPE := 1000 /*이게무슨뜻이냐? 민과 맥스 값을 보내주지않으면 0과 1천으로 설정하겠다는 것이다.*/
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
/*호출하자*/
EXEC my_new_job_proc('JOB5', 'test job5');

SELECT * FROM jobs; /*0과 1천이 들어간 것을 알 수 있다. */









/*--------------------------------------------------------------------------*/







/* IN말고 OUT도있고 INOUT도 있으니 사용해보자*/
/* OUT은 프로시저 바깥으로 값을 보낼 수 있다. OUT을 이용해서 보낸 값은 바깥 익명 블록에서 실행해야 한다. */
CREATE OR REPLACE PROCEDURE my_new_job_proc 
    (p_job_id IN jobs.job_id%TYPE,
     p_job_title IN jobs.job_title%TYPE,
     p_min_sal IN jobs.min_salary%TYPE := 0,/*max와 min의 기본값을 설정해보자*/
     p_max_sal IN jobs.max_salary%TYPE := 1000, /*이게무슨뜻이냐? 민과 맥스 값을 보내주지않으면 0과 1천으로 설정하겠다는 것이다.*/
     p_result OUT VARCHAR2 /*바깥쪽에서 출력을 하기 위한 변수*/
    )
IS
    v_cnt NUMBER := 0; 
    v_result VARCHAR(100) := '값이 없어서 INSERT 처리 되었습니다.';
    
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
       /*업데이트를 지우고, 이번엔 기존에 존재하는 데이터라면 결과를 추출 할 것이다. v_result변수에 담아서 바깥으로 뽑을 것이다. */
       /*값이있대. 즉, 기존에 존재한다면*/
       SELECT
        p_job_id || '의 최대 연봉: ' || max_salary || ', 최소 연봉은: ' || min_salary
        INTO
            v_result /*SELECT의 결과를 v_result에 담을 것이다.*/
       FROM jobs
       WHERE job_id = p_job_id;
    END IF;
    /*OUT 매개변수에 결과를 할당하겠다.*/
    p_result := v_result;
    
    COMMIT;
END;
/*my_new_job_proc을 부르자 > 익명블록을 이름이 없다.*/
DECLARE
    str VARCHAR2(100);
BEGIN
    my_new_job_proc(
        'job1', 'test_job1', 2000, 8000, str);
        /*위에서 선언한 str까지 같이 전달해주자 > 왜? my_new_job_proc을 보면 매개값을 5개받는다. 
        4개는 IN인데, IN은 값을 전달하면 값을 프로시저 내부에서 사용하지만 마지막 하나를 보면 OUT변수기 떄문에 
        str변수를 p_result한테 보내서 값을 활용하는 것이다.
        */
        DBMS_output.put_line(str);
        my_new_job_proc('CEO', 'test_CEO', 20000, 80000, str); /*비교해보려고 썼다. 기존의 CEO는 없으니 INSERT처리가 되겠지 > 값이 없으닌 INSERT되었습니다가 출력이 된다.*/
        DBMS_output.put_line(str);
END;






/*--------------------------------------------------------------------------*/





/*INOUT을 써보자 > IN OUT INOUT셋다 확인해보자*/
CREATE OR REPLACE PROCEDURE my_parameter_test_proc
/*매개값 받는 괄호 열어보자*/
    (
        /*IN은 받기만 하고 반환은 불가능하다.*/
        p_var1 IN VARCHAR2,
        /*OUT은 프로시저가 끝나기 전까지 값의 할당이 안됨. 끝나야만 OUT이 가능. 즉, 받는용도로는 쓸 수 없다. 받는 용도로 쓸꺼면 IN을 사용해야 한다. */
        p_var2 OUT VARCHAR2,
        /*IN OUT은 IN도되고 OUT도 된다.*/
        p_var3 IN OUT VARCHAR2
    )
/*IS는 딱히필요없으니*/
IS

BEGIN
    DBMS_output.put_line('p_var1: ' || p_var1); /*됨*/
    DBMS_output.put_line('p_var2: ' || p_var2); /*OUT은 받는 용도니 값 전달이 안되겠지*/
    DBMS_output.put_line('p_var3: ' || p_var3); /*IN의 성질로인해 됨*/
    
--    p_var1 := '결과1';
    p_var2 := '결과2';
    p_var3 := '결과3';

    
END;


/*익명블록 선언*/
DECLARE
    v_var1 VARCHAR2(10) := 'value1';
    v_var2 VARCHAR2(10) := 'value2';
    v_var3 VARCHAR2(10) := 'value3';
BEGIN
    /*프로시저호출*/
    my_parameter_test_proc(v_var1, v_var2, v_var3); /*3개 다 프로시저한테 전달해보자 > var1은 p_var1으로, var2는 p_var2 이런식으로.. 받는지 안받는지 체크해보자*/

    
    DBMS_output.put_line('v_var1: ' || v_var1);
    DBMS_output.put_line('v_var2: ' || v_var2);
    DBMS_output.put_line('v_var3: ' || v_var3);

END;
/*결과는 p_var1: value1 > IN으로 선언했으니 된다. */
/*결과는 p_var2: value2 > OUT으로 선언했으니 안된다. OUT은 값이 전달이 안되니 안된다.*/
/*결과는 p_var3: value3 > INOUT으로 선언했으니 된다. */



/*
이번엔 값을 할당해보자 BEGIN절에 추가하자 > 값을 대입해서 바깥으로 빠져나오는지알아보기위해! 
p_var = 결과 들을 써주고
이제 익명블록으로 내려와서 OUT이 되는지 확인을 해보자
BEGIN절에 또 DBMS절을 추가해주자. 해보면 에러가 난다. p_var1은 할당의 대상으로 활용할 수 없다고 한다.
즉, 프로시저 자체가 안만들어졌다는 거다. 즉, IN변수는 값의 대입 자체가 안되고 전달받는 용도로만 사용이 된다. 값의 할당이 아예 불가능하다.
결과1, 2, 3준거에 결과1을 주석처리 하고 다시 실행하면 잘 된다.


출력 결과
p_var1: value1
p_var2: 
p_var3: value3
v_var1: value1
v_var2: 결과2
v_var3: 결과3
*/






/*--------------------------------------------------------------*/



/*이번엔 RETURN 키워드 이다. > 프로시저 강제 종료에 쓸 수 있다. */



CREATE OR REPLACE PROCEDURE my_new_job_proc 
    (p_job_id IN jobs.job_id%TYPE,
     p_result OUT VARCHAR2 /*바깥쪽에서 출력을 하기 위한 변수*/
    )
IS
    v_cnt NUMBER := 0; 
    v_result VARCHAR(100) := '값이 없어서 INSERT 처리 되었습니다.';
    
BEGIN
    SELECT COUNT(*) 
    INTO
        v_cnt 
    FROM jobs
    WHERE job_id = p_job_id; 

        IF v_cnt = 0 THEN /*원래라면 INSERT 자리지만, 지금은 결과가 없어요 라고 끝내자*/
        DBMS_output.put_line(p_job_id || '는 테이블에 존재하지 않습니다.');
        RETURN; /*프로시저 강제 종료 > 그러고 나서 ELSE가 필요가 없지. ELSE지우고 END IF써주자*/
        END IF;
        
        SELECT
        p_job_id || '의 최대 연봉: ' || max_salary || ', 최소 연봉은: ' || min_salary
        INTO
            v_result /*SELECT의 결과를 v_result에 담을 것이다.*/
        FROM jobs
        WHERE job_id = p_job_id;
        
        /*OUT매개변수에 할당하는 부분*/
        p_result := v_result;
        COMMIT;
END;

/*컴파일 했으니 익명블록에서 테스트하자~*/
DECLARE
    str VARCHAR2(100);
BEGIN
    my_new_job_proc('메롱', str);
    
    
    /*str전달은 out되는 값을 전달해주기 위해 쓴거고 메롱은 없는 것을 적었다.*/
    DBMS_output.put_line(str);
    /*결과 : 메롱은 테이블에 존재하지 않습니다.*/

    
    /*만약 있는거면 제대로 뜨겠지*/
    my_new_job_proc('IT_PROG', str);
    DBMS_output.put_line(str);
    /*IT_PROG의 최대 연봉: 10000, 최소 연봉은: 4000*/
END;









/*------------------------------------------------------*/







/* 다음은 예외처리 이다. */
DECLARE
    v_num NUMBER := 0;
BEGIN
    v_num := 10 / 0;
    

/*
참고로 OTHERS 자리에 예외 타입을 작성해줄 수도 있다.
ACCESS_INTO_NULL -> 객체 초기화가 되어 있지 않은 상태에서 사용하려고 할떄.
NO_DATE_FOUND -> SELECT INTO 시 데이터가 한 건도 없을 때
ZERO_DIVIDE -> 0으로 나눌 때
VALUE_ERROR -> 수치 또는 값의 오류가 있을 때
INVALID_NUMBER -> 문자를 숫자로 변환할 때 실패한 경우
*/
    
/*에러확인했으니 예외처리하자*/
EXCEPTION WHEN OTHERS THEN 
    DBMS_output.put_line('0으로 나눌 수가 없습니다.');
    /*에러코드도 출력이 가능하다.*/
    DBMS_output.put_line('SQL ERROR CODE: ' || SQLCODE);
    /*에러메시지도 출력이 가능하다.*/
    DBMS_output.put_line('SQL ERROR MSG: ' || SQLERRM);
END; /*에러가뜬다. 일부러 에러를 낸 것이다. 올라가서 예외처리해주자*/

/*WHEN ZERO_DIVIDE THEN
DBMS~~
DBMS~~
DBMS~~
WHEN OTHERS THEN
DBMS~~('알수없는예외발생'); 이런식으로도 됨
*/


