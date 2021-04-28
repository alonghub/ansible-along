# Along Ansible
## 1. 基础测试
```
ansible 127.0.0.1 -m ping
```

## 2. 部署服务器基础环境
```
# 测试
ansible-playbook playbooks/base.yaml --tags BASE --limit 127.0.0.1 -C
# 运行
ansible-playbook playbooks/base.yaml --tags BASE --limit 127.0.0.1
```
