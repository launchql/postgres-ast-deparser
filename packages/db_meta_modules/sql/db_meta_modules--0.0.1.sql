\echo Use "CREATE EXTENSION db_meta_modules" to load this file. \quit
CREATE TABLE meta_public.rls_module (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	user_module_id uuid,
	tokens_module_id uuid,
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ),
	api_id uuid NOT NULL REFERENCES meta_public.apis ( id ),
	authenticate text NOT NULL DEFAULT ( 'authenticate' ),
	"current_role" text NOT NULL DEFAULT ( 'current_user' ),
	users_table_id uuid NOT NULL,
	current_role_id text NOT NULL DEFAULT ( 'current_user_id' ),
	current_group_ids text NOT NULL DEFAULT ( 'current_group_ids' ),
	tokens_table_id text NOT NULL,
	UNIQUE ( api_id ) 
);

CREATE TABLE meta_public.user_auth_module (
 	id uuid PRIMARY KEY DEFAULT ( uuid_generate_v4() ),
	user_module_id uuid,
	encrypted_secrets_module_id uuid,
	secrets_module_id uuid,
	tokens_module_id uuid,
	rls_module_id uuid,
	emails_module_id uuid,
	database_id uuid NOT NULL REFERENCES collections_public.database ( id ),
	api_id uuid NOT NULL REFERENCES meta_public.apis ( id ),
	sign_in_function text NOT NULL DEFAULT ( 'login' ),
	sign_up_function text NOT NULL DEFAULT ( 'register' ),
	set_password_function text NOT NULL DEFAULT ( 'set_password' ),
	reset_password_function text NOT NULL DEFAULT ( 'reset_password' ),
	forgot_password_function text NOT NULL DEFAULT ( 'forgot_password' ),
	send_verification_email_function text NOT NULL DEFAULT ( 'send_verification_email' ),
	verify_email_function text NOT NULL DEFAULT ( 'verify_email' ),
	UNIQUE ( api_id ) 
);