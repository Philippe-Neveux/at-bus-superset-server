install-collections:
	uv run ansible-galaxy collection install -r requirements.yml

check-syntax-playbooks:
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/deploy.yml
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/backup.yml
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/restore.yml
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/update.yml

deploy-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --verbose

backup-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/backup.yml --vault-password-file .vault_pass --verbose

restore-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/restore.yml --extra-vars "backup_to_restore=$(BACK_UP_NAME)" --vault-password-file .vault_pass --verbose

update-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/update.yml --extra-vars "new_superset_version=$(NEW_SUPERSET_VERSION)" --vault-password-file .vault_pass --verbose

see-decrypt-vault:
	uv run ansible-vault view inventory/group_vars/all/vault.yml --vault-password-file .vault_pass

decrypt-vault:
	uv run ansible-vault decrypt inventory/group_vars/all/vault.yml --vault-password-file .vault_pass

encrypt-vault:
	uv run ansible-vault encrypt inventory/group_vars/all/vault.yml --vault-password-file .vault_pass