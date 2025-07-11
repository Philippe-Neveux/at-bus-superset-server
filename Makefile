install-collections:
	uv run ansible-galaxy collection install -r requirements.yml

VAULT_PASS_FILE ?= .vault_pass

check-syntax-playbooks:
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/deploy.yml --vault-password-file $(VAULT_PASS_FILE)
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/backup.yml --vault-password-file $(VAULT_PASS_FILE)
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/restore.yml --vault-password-file $(VAULT_PASS_FILE)
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/update.yml --vault-password-file $(VAULT_PASS_FILE)
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/download_backup.yml --vault-password-file $(VAULT_PASS_FILE)
	uv run ansible-playbook --syntax-check -i inventory/hosts.yml playbooks/upload_backup.yml --vault-password-file $(VAULT_PASS_FILE)

deploy-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/deploy.yml --vault-password-file $(VAULT_PASS_FILE) --verbose

backup-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/backup.yml --vault-password-file $(VAULT_PASS_FILE) --verbose

download-backup:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/download_backup.yml --vault-password-file $(VAULT_PASS_FILE) --verbose

upload-backup:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/upload_backup.yml --extra-vars "backup_to_upload=$(BACKUP_NAME)" --vault-password-file $(VAULT_PASS_FILE) --verbose

restore-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/restore.yml --extra-vars "backup_to_restore=$(BACK_UP_NAME)" --vault-password-file $(VAULT_PASS_FILE) --verbose

update-superset:
	uv run ansible-playbook -i inventory/hosts.yml playbooks/update.yml --extra-vars "new_superset_version=$(NEW_SUPERSET_VERSION)" --vault-password-file $(VAULT_PASS_FILE) --verbose

see-decrypt-vault:
	uv run ansible-vault view inventory/group_vars/all/vault.yml --vault-password-file $(VAULT_PASS_FILE)

decrypt-vault:
	uv run ansible-vault decrypt inventory/group_vars/all/vault.yml --vault-password-file $(VAULT_PASS_FILE)

encrypt-vault:
	uv run ansible-vault encrypt inventory/group_vars/all/vault.yml --vault-password-file $(VAULT_PASS_FILE)