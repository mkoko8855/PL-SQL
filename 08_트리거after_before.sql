/* after 트리거 -> INSERT, UPDATE, DELETE 등의 작업 이후에 동작하는 트리거를 의미한다. */

/* before 트리거 -> INSERT, UPDATE, DELETE 등의 작업 이전에 동작하는 트리거를 의미한다. */


/*
변수 선언을 할 껀데,
:OLD -> 참조 전 열의 값 (EX INSERT:입력 전 자료, UPDATE: 수정 전 자료, DELETE: 삭제될 값)
:NEW -> 참조 후 열의 값 (EX INSERT:입력 할 자료, UPDATE: 수정 된 자료)

테이블에 UPDATE나 DELETE를 시도하면 수정, 또는 삭제된 데이터를
별도의 테이블에 보관해 놓는 형식으로 트리거를 많이 사용한다. 
*/


/*테이블 생성해보자*/
CREATE TABLE tbl_user(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30)
);


/* tbl_user에 백업 테이블 하나 만들것이다. 수정한 것들도 처리해보자 */
CREATE TABLE tbl_user_backup(
    id VARCHAR2(20) PRIMARY KEY,
    name VARCHAR2(20),
    address VARCHAR2(30),
    update_date Date DEFAULT sysdate, /*변경 시간*/
    m_type VARCHAR2(10), /*변경 타입*/
    m_user VARCHAR2(20)  /*변경한 사용자(관리중에 승인한 사람은 누구인가*/
);



/* after 트리거를 적용 시켜 보자 */
CREATE OR REPLACE TRIGGER trg_user_backup
/*트리거를 동작 시킬 시점은*/
    AFTER UPDATE OR DELETE /*업데이트나 딜리트 이후에 동작시킬 것이다*/
    ON tbl_user /*원본테이블에 붙일 것이다.*/
    FOR EACH ROW /*모두에게 적용하겠다.*/
DECLARE /*생략도 가능하지만 사용할 변수를 선언하는 곳*/
    v_type VARCHAR2(10);
BEGIN
    /*비긴문에는 트리거가 업데이트나 딜리트 이후에 동작을 할텐데,
      지금 트리거 시점이 업데이트 이후인지 삭제 이후인지 파악해야 한다.
      IF문을 이용해서 조건을 걸 것이다.*/
    IF UPDATING THEN /*UPDATING은 시스템 자체에서 상태에 대한 내용을 지원하는 빌트인 구문(기본적으로 내장됨).*/
        v_type := '수정';
    ELSIF DELETING THEN
        v_type := '삭제';
    END IF;
    
    /* 백업테이블에 집어넣을 타입을 한거고 이제 본격적인 실행 구문을 쓸 것이다. */
    /* 
       이제 수정중인지 삭제중인지 판단을 해서 v_type변수에 수정이나 삭제 값을 넣었고,
       공통적으로 들어갈 것은 수정되고있는 그 정보, 삭제되고 있는 그 정보를 백업테이블에 INSERT를 할 것이다.
    */    
    INSERT INTO tbl_user_backup
    /*수정 전이나 삭제 전의 값들을 VALUES로 적어줘야겠지.*/
    VALUES(:OLD.id, :OLD.name, :OLD.address, sysdate, v_type, user()); /*user()는 현재 접속중인 사용자 정보 객체를 표시해준다. 우린 hr로 접속했으니 hr이 사용자가 되겠다.*/
END;



/* 확인 */
INSERT INTO tbl_user
VALUES ('test01', 'kim', '서울');
INSERT INTO tbl_user
VALUES ('test02', 'lee', '경기도');
INSERT INTO tbl_user
VALUES ('test03', 'hong', '부산');

SELECT * FROM tbl_user;
SELECT * FROM tbl_user_backup; /*얜 지금 비어있겠지*/


UPDATE tbl_user SET address='인천' WHERE id='test01'; /*id가 test01인 사람의 address를 인천으로 변경하겠다.*/
/*트리거가 돌았겠지. 백업을 확인해보자*/



/*이번엔 딜레트*/
DELETE FROM tbl_user WHERE id = 'test01';






/*이번엔 BEFORE 트리거를 제작해보자*/
CREATE OR REPLACE TRIGGER trg_user_insert
    BEFORE INSERT 
    ON tbl_user /*원본테이블에붙임*/
    FOR EACH ROW
BEGIN
    /*INSERT 되기 전에 BEFORE트리거가 실행된다. */
    :NEW.name := SUBSTR(:NEW.name, 1, 1) || '**'; /*성을 짜르고 나머지는 **로 처리하겠다.*/
END;

/*인서트해보자*/
INSERT INTO tbl_user VALUES('test04', '메롱이', '대전');

















/* 
트리거의 활용 -> INSERT가 진행이 주문 테이블에서 이뤄진다. -> 
주문 테이블 INSERT 트리거 실행 (물품 테이블에 업데이트 담당을 하게 된다면)
*/
/*간단하게 주문들어왔을떄 재고수량이 빠지는지 확인해보자~*/


/*주문히스토리*/
CREATE TABLE order_history (
    history_no NUMBER(5) PRIMARY KEY,
    order_no NUMBER(5),
    product_no NUMBER(5),
    total NUMBER(10),
    price NUMBER(10)
);

/*상품 (상품이 있어야 주문이 가능하니..)*/
CREATE TABLE product(
    product_no NUMBER(5) PRIMARY KEY,
    product_name VARCHAR2(20),
    total NUMBER(5),
    price NUMBER(5)
);


/*history_no, product_no를 위한 시퀀스 만들자*/
CREATE SEQUENCE order_history_seq NOCACHE;

CREATE SEQUENCE product_seq NOCACHE;



/*이제 상품을 집어 넣자*/
INSERT INTO product VALUES(product_seq.NEXTVAL, '피자', 100, 10000);
INSERT INTO product VALUES(product_seq.NEXTVAL, '치킨', 100, 20000);
INSERT INTO product VALUES(product_seq.NEXTVAL, '햄버거', 100, 5000);


SELECT *
FROM product;

/*
피자 3판들어오면 재고상품에서 3개가 빠져야하니 97개가 되어야하지? 
즉, 주문테이블에 인서트될때마다 프로덕트에 있는 상품수량이 빠져야한다.
트리거한테 시키자~
*/
/*즉, 주문 히스토리에 데이터가 들어오면 트리거를 실행해보자*/
CREATE OR REPLACE TRIGGER trg_order_history
    AFTER INSERT
    ON order_history
    FOR EACH ROW
    
DECLARE
    v_total NUMBER;
    v_product_no NUMBER;
BEGIN
    DBMS_output.put_line('트리거 실행!');
    
    
    
    /*트리거활용*/
    SELECT
        :NEW.total /*인서트되고있는 수량을 파악하자*/
    INTO
        v_total
        FROM dual;
    
    /*상품이 무엇인지도 확인한 다음 */
    v_product_no := :new.product_no;
    UPDATE product SET total = total - v_total /*재고상품테이블의 수량을 조절하는 것을 볼 수 있다. */
    WHERE product_no = v_product_no;
END;


/*주문이들어왔으면 */
INSERT INTO order_history VALUES(order_history_seq.NEXTVAL, 200, 1, 5, 50000); /*인서트되고있는 수량을 파악하자*/
/*그럼이제 위로올라가서 트리거활용.*/

SELECT *
FROM product;
    