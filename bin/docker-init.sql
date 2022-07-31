CREATE USER tollowy;
ALTER USER tollowy WITH SUPERUSER;

CREATE extension pg_stat_statements;
SELECT pg_stat_statements_reset();
