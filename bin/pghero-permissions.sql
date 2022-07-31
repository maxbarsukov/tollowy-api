CREATE SCHEMA pghero;

-- view queries
CREATE OR REPLACE FUNCTION pghero.pg_stat_activity() RETURNS SETOF pg_stat_activity AS
$$
  SELECT * FROM pg_catalog.pg_stat_activity;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE VIEW pghero.pg_stat_activity AS SELECT * FROM pghero.pg_stat_activity();

-- kill queries
CREATE OR REPLACE FUNCTION pghero.pg_terminate_backend(pid int) RETURNS boolean AS
$$
  SELECT * FROM pg_catalog.pg_terminate_backend(pid);
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

-- query stats
CREATE OR REPLACE FUNCTION pghero.pg_stat_statements() RETURNS SETOF pg_stat_statements AS
$$
  SELECT * FROM public.pg_stat_statements;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE VIEW pghero.pg_stat_statements AS SELECT * FROM pghero.pg_stat_statements();

-- query stats reset
CREATE OR REPLACE FUNCTION pghero.pg_stat_statements_reset() RETURNS void AS
$$
  SELECT public.pg_stat_statements_reset();
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

-- improved query stats reset for Postgres 12+ - delete for earlier versions
CREATE OR REPLACE FUNCTION pghero.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) RETURNS void AS
$$
  SELECT public.pg_stat_statements_reset(userid, dbid, queryid);
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

-- suggested indexes
CREATE OR REPLACE FUNCTION pghero.pg_stats() RETURNS
TABLE(schemaname name, tablename name, attname name, null_frac real, avg_width integer, n_distinct real) AS
$$
  SELECT schemaname, tablename, attname, null_frac, avg_width, n_distinct FROM pg_catalog.pg_stats;
$$ LANGUAGE sql VOLATILE SECURITY DEFINER;

CREATE VIEW pghero.pg_stats AS SELECT * FROM pghero.pg_stats();

-- create user
CREATE ROLE pghero WITH LOGIN ENCRYPTED PASSWORD :pghero_password;
GRANT CONNECT ON DATABASE :database_name TO pghero;
ALTER ROLE pghero SET search_path = pghero, pg_catalog, public;
GRANT USAGE ON SCHEMA pghero TO pghero;
GRANT SELECT ON ALL TABLES IN SCHEMA pghero TO pghero;

-- grant permissions for current sequences
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO pghero;

-- grant permissions for future sequences
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON SEQUENCES TO pghero;
