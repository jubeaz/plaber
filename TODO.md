# to check
## Expiration date
 https://github.com/clong/DetectionLab/blob/master/Vagrant/scripts/fix-windows-expiration.ps1

## bg info
 
 # Exchange
https://github.com/jborean93/exchange-test-environment/tree/master

https://www.it-connect.fr/installation-pas-a-pas-de-microsoft-exchange-2019-sur-windows-server-2022/

https://github.com/clong/DetectionLab/blob/master/Azure/Ansible/roles/exchange/tasks/main.yml
https://github.com/clong/DetectionLab/blob/master/Vagrant/scripts/install-exchange.ps1

 # GPO Restore

```
---
- name: check if the GPO has already been imported
  win_shell: if (Get-GPO -Name {{ pri_adcs_enrollment_gpo_name | quote }} -ErrorAction SilentlyContinue) { $true } else { $false }
  register: pri_adcs_enrollment_gpo_exists
  changed_when: no

- block:
  - name: create backup folder on host for GPO
    win_file:
      path: C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup
      state: directory

  - name: copy across backup of GPO
    win_copy:
      src: gpo_backup/
      dest: C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup\

  - name: restore GPO from backup
    win_shell: Import-GPO -BackupGpoName {{ pri_adcs_enrollment_gpo_name | quote }} -TargetName {{ pri_adcs_enrollment_gpo_name | quote }} -Path C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup -CreateIfNeeded

  - name: delete backup folder on host
    win_file:
      path: C:\temp\{{ pri_adcs_enrollment_gpo_name }}-backup
      state: absent
      
  when: not pri_adcs_enrollment_gpo_exists.stdout_lines[0]|bool

# The backup GPO has an ID that is unique to the domain it came from, these
# next 2 tasks get's the ID for this domain's auto enroll policy and set's
# that onto the newly imported domain
- name: get policy server ID
  win_shell: (Get-CertificateEnrollmentPolicyServer -Scope All -Context Machine).Id
  register: pri_adcs_enrollment_policy_id
  changed_when: no

- name: set the policy server ID for the GPO
  win_gpo_reg:
    gpo: '{{ pri_adcs_enrollment_gpo_name }}'
    path: HKLM\Software\Policies\Microsoft\Cryptography\PolicyServers\{{ item.path | default('') }}
    name: '{{ item.name | default(omit) }}'
    value: "{{ pri_adcs_enrollment_policy_id.stdout_lines[0] }}"
    type: String
  with_items:
  - {}
  - path: 37c9dc30f207f27f61a2f7c3aed598a6e2920b54
    name: PolicyID

- name: ensure GPO is linked and enforced
  win_gpo_link:
    name: '{{ pri_adcs_enrollment_gpo_name }}'
    state: present
    enforced: yes
    enabled: yes
```