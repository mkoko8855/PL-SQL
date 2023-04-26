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
    MAXVALUE 100000 /*5라고 지정했으니까 10만정도*/
    NOCYCLE
    NOCACHE;






SELECt *
FROM users;  /*1번의 1번인 회원관리시스템 > 신규회원추가 기능이 완료된 것을 볼 수 있다. 즉, 데이터가 들어왔다.*/








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
    order_date DATE DEFAULT sysdate, /*인서트될때 자동으로 되기 위해 디폴트*/
    return_date DATE DEFAULT sysdate + 3
);

CREATE SEQUENCE order_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 100000
    NOCYCLE
    NOCACHE;
    


/*트리거를 제작하자*/
CREATE OR REPLACE TRIGGER trg_order_history
 AFTER INSERT
 ON order_history
 FOR EACH ROW

DECLARE
 --다른 테이블의 데이터 값을 변경해줄 것이다
 --수량은 딱히 파악할 필요 없으니 영화 번호를 얻어내자
 v_serial_number NUMBER;
BEGIN
 SELECT
    :NEW.serial_number
INTO v_serial_number --위 new.~~넘버를 이 인투절에 넣겠다. 그러고 나서 업데이트 ㄱㄱ
 FROM dual;
 
 UPDATE movie SET rental = 'false'
 WHERE serial_number = v_serial_number; 
 
 --대여만 생각해서 이렇게 썼다. 나중은 반납도 고려해야 한다.
 
END;

