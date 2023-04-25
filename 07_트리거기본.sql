
/* 
트리거는 테이블에 부착된 형태로써, INSERT 나 UPDATE 나 DELETE 작업이 수행 될 떄,
특정 코드가 작동되도록 하는 구문입니다.
VIEW에는 부착이 불가능하다.

트리거를 만들 때, 범위를 지정하고 F5 버튼으로 부분실행 해야 한다. (프로시저처럼)
그렇기 않으면 하나의 구문으로 인식되어 정상 동작 하지 않습니다.
*/

CREATE TABLE tbl_test(
    id NUMBER(10),
    text VARCHAR2(20)
);


/*트리거를 제작해보자*/
CREATE OR REPLACE TRIGGER trg_test
/* 트리거가 발동하는 시점을 적어주면 된다. before 혹은 after가 들어간다. */
AFTER DELETE OR UPDATE /* 지금은 삭제 혹은 수정 이후에 동작 하라는 뜻이다. */
ON tbl_test/*ON절에는 트리거를 부착할 테이블을 사용한다. */

/*트리거가 동작하는 빈도를 적어주자*/
FOR EACH ROW 
/*각 행에 모두 적용이 된다는 뜻이다. 이거는 생략이 가능하다.
생략 시에는 단 한번만 실행하게 된다.
*/
DECLARE /*선언할게 딱히 없으면 생략 가능이지만 BEGIN과 END는 꼭 써줘야 한다. */
BEGIN DBMS_output.put_line('트리거가 동작함!');  /*이벤트가 발생 할 때 마다 실행하고자 하는 코드를 비긴과 엔드 사이에 넣는다.*/
END;

/*이제 위의 tbl_test 테이블(현재비어있음) 만들어논거에 인서트, 딜리트, 업데이트를 해보자*/
INSERT INTO tbl_test VALUES(1, '김철수');
/*우리가 작성한 트리거는 딜레트나 업데이트 이후에 발생이 되니 인서트에는 트리거가 발생하지 않는다.*/

/*그러면 트리거 동작을 위해 업데이트를 해보자*/
UPDATE tbl_test SET text = '김뽀삐' WHERE id = 1;

/*딜레트를 보자*/
DELETE FROM tbl_test WHERE id = 1;







