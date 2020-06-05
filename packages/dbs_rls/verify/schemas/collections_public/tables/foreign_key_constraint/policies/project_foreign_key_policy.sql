-- Verify schemas/collections_public/tables/foreign_key_constraint/policies/project_foreign_key_policy  on pg

BEGIN;

SELECT verify_policy ('can_select_foreign_key_constraint', 'collections_public.foreign_key_constraint');
SELECT verify_policy ('can_insert_foreign_key_constraint', 'collections_public.foreign_key_constraint');
SELECT verify_policy ('can_update_foreign_key_constraint', 'collections_public.foreign_key_constraint');
SELECT verify_policy ('can_delete_foreign_key_constraint', 'collections_public.foreign_key_constraint');

SELECT verify_function ('collections_private.foreign_key_constraint_policy_fn');



ROLLBACK;
