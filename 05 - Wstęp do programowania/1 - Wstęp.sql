
do $$
declare
	var1 varchar(10):='abc';
	var2 integer := 100;
BEGIN
	RAISE NOTICE 'Pokazuję zmienną % i %', var1,var2;
end
$$;

--IF
do $$
declare
	var int:=11;
begin
	if var>10 then
		RAISE NOTICE 'var większy od 10';
	else
		RAISE NOTICE 'var mniejszy lub równy';
	end if;
end
$$;


do $$
declare
	var int:=8;
begin
	if var>10 then
		RAISE NOTICE 'var > 10';
	elseif var=10 then
		RAISE NOTICE 'var = 10';
	else	
	RAISE NOTICE 'var < 10 ';
	end if;
end
$$;

--CASE

do $$
declare
	var int:=8;
begin
	case
		when var > 10 then RAISE NOTICE 'var > 10';
		when var = 10 then RAISE NOTICE 'var = 10';
	else
		RAISE NOTICE 'var < 10';
	end case;
end
$$;



--LOOP

do $$
declare
	var int:=11;
begin
	LOOP
	RAISE NOTICE ' % ', var;
	if var > 20 then
		exit;
	end if;
	var := var + 1;
	end loop;
end
$$;

--exit when
do $$
declare
	var int:=11;
begin
	LOOP
	RAISE NOTICE ' % ', var;
	exit when var > 20;
	var := var + 1;
	end loop;
end
$$;

--CONTINUE --Instrukcja continue przedwcześnie pomija bieżącą iterację pętli i przechodzi do następnej
do $$
declare
	var int:=11;
begin
	loop
		var := var + 1;
		RAISE NOTICE ' % ', var;
		exit when var > 20;
		continue when var < 16;
		RAISE NOTICE ' Continue: % ', var;	
	end loop;
end
$$;

--CONTINUE2
do
$$
declare
   x int = 0;
begin  
  loop
     x = x + 1;	 
	 exit when x > 10;	 
	 continue when mod(x,2) = 0;	 
	 raise notice '%', x;
  end loop;
end;
$$

--for
do $$
begin
	for x in 1..5 loop
		raise notice 'x: %', x;
   	end loop;
end
$$;


--for reverse
do $$
begin
   for x in reverse 5..1 loop
      raise notice 'x: %', x;
   end loop;
end; $$


--for by
do $$
begin 
  for x in 1..6 by 2 loop
    raise notice 'x: %', x;
  end loop;
end; $$


--WHILE

do $$
declare
	x int:=0;
begin
	while x < 5 loop
      raise notice 'x %', x;
	  x := x + 1;
   	end loop;
end
$$;

--read query
--v1
do
$$
declare
	emp varchar(100); --record
begin	
	for x in 100..206 loop
		select concat(last_name, salary) into emp from employees
		where employee_id = x;	
		raise notice 'Pracownik %', emp;
	end loop;
end
$$;

--v2
do
$$
declare
    f record;
begin
    for f in select last_name, salary
	       from employees
    loop 
	raise notice '%, % ', f.last_name, f.salary;
    end loop;
end;
$$

--v3
do
$$
declare
    emp record;
begin
    for emp in
        select concat(last_name, salary) as info from employees
    loop
        raise notice 'Pracownik %', emp.info;
    end loop;
end
$$;



--inside, outside
do
$$
<<outside>>
declare 
   i int = 0;
begin
  <<inside>>
  	for i in 1..5 loop	
	  raise notice 'Sprawdzam wartości outside %, inside %', outside.i, inside.i;
	end loop;
raise notice 'Koniec';
end;
$$


--EXIT WHEN
do
$$
declare 
   i int = 0;
   j int = 0;
begin
  <<outer_loop>>
  loop 
     i = i + 1;
     exit when i > 3;
	 j = 0;
     <<inner_loop>>
     loop 
		j = j + 1;
		exit when j > 3;
		raise notice '(i,j): (%,%)', i, j;
	 end loop inner_loop;
  end loop outer_loop;
end;
$$


--czytanie tabeli 
do
$$
declare 
   i employees.employee_id%TYPE;
begin
	for i in
		select employee_id from employees e
		loop
			raise notice 'Emp id %', i;
		end loop;
raise notice 'Koniec';	
end;
$$

--po tablicy
do
$$
declare 
   i int;
begin
	foreach i in array array[10,20,30] LOOP
			raise notice 'Wartosci %', i;
		end loop;
raise notice 'Koniec';	
end;
$$





--SELECT

--Bloku który pobieral i wyświetla liczbe pracowników.
--przekazywanie wartosci do zmiennych
DO $$
DECLARE
	v_liczba_pracownikow NUMERIC;
BEGIN
	SELECT count(*) INTO v_liczba_pracownikow
	FROM employees;
	RAISE NOTICE ' %', v_liczba_pracownikow;
END $$;


--Blok pokaże pierwszą wartośc
do $$
declare
	emp_id int;
begin
	select 
		employee_id into emp_id
		from employees e ;
	raise notice 'Employee_id: %', emp_id;
end
$$;


do $$
declare
	liczba_pracownikow int:=0;
begin
	liczba_pracownikow = (
							select 
								count(*) 
								from employees e) ;
	raise notice 'Ilość prac: %', liczba_pracownikow;
end
$$;

do $$
declare
	liczba_pracownikow int:=(select 
								count(*) 
								from employees e) ;
begin
	raise notice 'Ilość prac: %', liczba_pracownikow;
end
$$;

--Konstrukcja INSERT INTO SELECT.

create table t1 (id int, ln varchar(50))

do $$
begin
	insert into t1
	select
		employee_id, last_name from employees e 
	where department_id = 50;
end
$$;

select * from t1
drop table t1


--Wyjątki
DO $$
DECLARE
    v_liczba INTEGER := 25;
    v_wynik NUMERIC;
BEGIN
    -- Próba wykonania dzielenia przez zero
    BEGIN
        v_wynik := v_liczba / 0;
        RAISE NOTICE 'Ten komunikat nigdy się nie wyświetli';
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'Złapano wyjątek: próba dzielenia przez zero!';
            v_wynik := NULL;
    END;

    RAISE NOTICE 'Wynik: %', v_wynik;
END $$;


DO $$
DECLARE
    v_wynik NUMERIC;
BEGIN 
    -- Próba konwersji tekstu na liczbę
    BEGIN
        v_wynik := 'abc'::INTEGER;
        RAISE NOTICE 'Ten komunikat nigdy się nie wyświetli';
    EXCEPTION
        WHEN invalid_text_representation THEN
            RAISE NOTICE 'Złapano wyjątek: nieprawidłowa konwersja tekstu na liczbę!';
            v_wynik := -1;
    END;
    
    RAISE NOTICE 'Wynik po drugiej operacji: %', v_wynik;
END $$;  -- Zakończenie głównego bloku


DO $$
DECLARE 
	v_liczba int := 40;
BEGIN 
    -- Własny wyjątek
    BEGIN
        IF v_liczba > 20 THEN
            RAISE EXCEPTION 'Liczba % jest zbyt duża!', v_liczba
                USING HINT = 'Podaj liczbę mniejszą niż 20';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Złapano wyjątek: % (Wskazówka: %)', 
                         SQLERRM, 
                         SQLSTATE;
    END;
    
    RAISE NOTICE 'Blok anonimowy zakończony';
END $$;

DO $$
BEGIN
    -- Rzucanie wyjątku z własnym kodem SQLSTATE
    RAISE EXCEPTION USING
        ERRCODE = 'P0003',
        MESSAGE = 'To jest mój własny wyjątek',
        HINT = 'Oto wskazówka jak go naprawić',
        DETAIL = 'Szczegółowy opis problemu';
EXCEPTION
    WHEN SQLSTATE 'P0003' THEN
        RAISE NOTICE 'Złapano wyjątek: %', SQLERRM;
        RAISE NOTICE 'Szczegóły: %', SQLERRM;
END $$;



/*
Kursory
*/


DO $$
DECLARE
	lista_pracownikow CURSOR FOR select first_name, last_name from employees;
	emp RECORD;
BEGIN
	OPEN lista_pracownikow;
	LOOP
		FETCH lista_pracownikow INTO emp;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE ' %', emp;
		RAISE NOTICE 'FN: %, LN: %', emp.first_name, emp.last_name;
	END LOOP;
	CLOSE lista_pracownikow;
END $$;

select last_name from employees


--niejawny
--kursor, który przeczyta dane z tabeli DEPARTMENTS
DO $$
DECLARE
    emp_record RECORD;
BEGIN
    -- Kursor niejawny z konstrukcją FOR
    FOR emp_record IN 
        SELECT last_name, salary 
        FROM employees 
        ORDER BY last_name
    LOOP
        -- Przetwarzanie każdego rekordu
        RAISE NOTICE 'Pracownik: %, Pensja: %', 
                     emp_record.last_name, 
                     emp_record.salary;
        
        -- Przykład dodatkowej logiki
        IF emp_record.salary > 50000 THEN
            RAISE NOTICE '  -> Wysoka pensja!';
        END IF;
    END LOOP;
END $$;

