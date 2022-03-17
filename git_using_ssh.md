1. generate ssh key:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

2. add generated key to ssh client

```bash
ssh-add ~/.ssh/id_ed25519
```

__NOTE__ if you got error:

```
Could not open a connection to your authentication agent.
```

run next command:

```sh
eval "$(ssh-agent -s)"
```

and will try again

3. upload public key to github

4. authenticate to github via ssh

```bash
ssh -T git@github.com
```


After this steps you can clone your repositories as

```bash
git clone git@github.com:username/repo.git
```

__NOTE__ for repositories, that was downloaded earlier, you need update url:

```bash
git remote set-url origin git@github.com:username/your-repository.git
```
