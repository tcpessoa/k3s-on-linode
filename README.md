# Usage guide
- Terraform to create infra
- Ansible to install k3s and relevant software
- Ansible again to retrieve the kubeconfig
- Access vpn through IP and create a new conf (`<LINODE_IP>:51821`)
- Add it to your wireguard
- You can now use kubectl

Now, add your first app, follow this example ingress:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-production
    spec.ingressClassName: traefik
  labels:
    app: myapp
  name: myapp
  namespace: default
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - backend:
          service:
            name: myapp
            port: 
              number: 80
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - myapp.example.com
    secretName: myapp-example-com-tls
```
check `./k8s/test.yaml`

# Initial setup
Create a python virtual environment and activate it.
Run `pip install -r requirements.txt`

Run `setup.sh` to initialize your terraform and ansible secrets.

You should now be able to edit:
- `terraform/terraform.tfvars`
- `ansible/group_vars/all/vault.yml`

For the latter use:
- `ansible-vault edit ansible/group_vars/all/vault.yml --vault-password-file ansible/.vault_password`

# Terraform
- Run `cd terraform`
- Initialize terraform with:

```sh
terraform init
```

Check what will be created with:

```sh
terraform plan -var-file="terraform.tfvars"
```

and then apply with:

```sh
terraform apply -var-file="terraform.tfvars"
```

# Ansible
- From the root of the project, run `cd ansible`

Now run `ansible-playbook playbooks/setup.yml` and then:


`ansible-playbook playbooks/retrieve_configs.yml` to get your kubeconfig on `./ansible/playbooks/configs/`.

Then visit `<LINODE_IP>:51821` to generate a VPN conf file. Add it to your wireguard client.

Now you are ready to run `kubectl`

# Troubleshoot
- Run `ansible-playbook -vvvv ...` to increase verbosity of commands
- Run `ansible-playbook -vvv playbooks/debug_role.yml` with the desired role to debug a single step

# Improvements
- [ ] Automatically generate VPN conf file and get it (generating the wg conf is more complex then I imagined)

## Cert manager

[reference article](https://levelup.gitconnected.com/easy-steps-to-install-k3s-with-ssl-certificate-by-traefik-cert-manager-and-lets-encrypt-d74947fe7a8)

