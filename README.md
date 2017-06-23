# backend
Toy example of a simple distributed web application in nomad, using consul and vault.

## Building

## Running it locally 

 1. Start consul in dev mode (and enable the UI) 

```
$ consul agent -dev -ui
```

 2. Vault

    2.1 Start vault 

    ```
    $ vault agent -dev
    ```

    You should see the output of the server including something like

    ```
    ==> WARNING: Dev mode is enabled!

    In this mode, Vault is completely in-memory and unsealed.
    Vault is configured to only have a single unseal key. The root
    token has already been authenticated with the CLI, so you can
    immediately begin using the Vault CLI.

    The only step you need to take is to set the following
    environment variables:

        export VAULT_ADDR='http://127.0.0.1:8200'

    The unseal key and root token are reproduced below in case you
    want to seal/unseal the Vault or play with authentication.

    Unseal Key: IYW7RQoNaUea6hGvvMTx4IJPPrRhBNO3X3IGFFfctts=
    Root Token: 84b927aa-e2ad-8a5f-751f-d241058a0b60

    ==> Vault server started! Log data will stream in below:
    ```

    2.2 Configure the vault address to use

    ```
    $ export VAULT_ADDR=http://127.0.0.1:8200
    ```

    2.3 Login to vault using the root token

    ```
    $ vault auth
    Token (will be hidden): 
    Successfully authenticated! You are now logged in.
    token: 84b927aa-e2ad-8a5f-751f-d241058a0b60
    token_duration: 0
    token_policies: [root]
    ```
 
    2.3 Write some "secret" data into vault

    ```
    $ vault write secret/nomad/services/backend value='hello from the backend'
    Success! Data written to: secret/nomad/services/backend
    $ vault write secret/nomad/services/frontend value='hello from the frontend'
    Success! Data written to: secret/nomad/services/frontend
    ```

    2.4. Make a policy for your tasks to allow them access to the secret data

    ```
    $ vault policy-write nomad-services nomad-services-policy.hcl
    Policy 'nomad-services' written.
    ```

 3. Start nomad

```
VAULT_TOKEN=84b927aa-e2ad-8a5f-751f-d241058a0b60 nomad agent -dev -vault-enabled -vault-address=http://127.0.0.1:8200
```

 4. Start traefik

```
docker run traefik --web --consulcatalog --consulcatalog.domain=localhost
```

 5. Add frontend.localhost and backend.localhost to your /etc/hosts file to allow the services to be resolved

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 frontend.localhost backend.localhost
```
