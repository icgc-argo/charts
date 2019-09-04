1- create namespace <bashar-test for example>

2- fill secrets in the values file: 

```
ego
googleClientId/secret: (get these from argo-dev helm get ego-argo-dev)

program service:
postgres user name : postgres

lectern
mongo user: root
```

3- install chart

```
helm install --name argo --namespace <bashar-test> -f values.yaml .
```
the name argo is changable, but you need to replace services names in the values file.


4- sql setup  (replace user name with things you want)

you may need to restart ego for now (doesn't crash and doesn't restart when it fails to connect to db)
```
kubectl scale deployment argo-ego --replicas=0
kubectl scale deployment argo-ego --replicas=1
```

```
INSERT INTO egouser (id, name, email, type, firstname, lastname, createdat, lastlogin, status, preferredlanguage) VALUES ('57b8f58e-cf8d-4a7f-ac49-51129e156f33', 'bashar@example.com', 'bashar@example.com', 'ADMIN', 'Foo', 'Bar', NOW(), NOW(), 'APPROVED', 'ENGLISH');

-- add program service permission
INSERT INTO policy (id, owner, name) VALUES ('27b08a5b-5328-4223-8ddc-c9e6dcaa48c3', NULL, 'PROGRAMSERVICE');

INSERT INTO policy (id, owner, name) VALUES ('37b08a5b-5328-4223-8ddc-c9e6dcaa48c3', NULL, 'CLINICALSERVICE');

-- add admin programservice.write 
INSERT INTO userpermission (id, policy_id, user_id, access_level) VALUES ('b69740f2-c9c9-413e-a682-d62b002b54a7', '27b08a5b-5328-4223-8ddc-c9e6dcaa48c3', '57b8f58e-cf8d-4a7f-ac49-51129e156f33', 'WRITE');

INSERT INTO userpermission (id, policy_id, user_id, access_level) VALUES ('c69740f2-c9c9-413e-a682-d62b002b54a7', '37b08a5b-5328-4223-8ddc-c9e6dcaa48c3', '57b8f58e-cf8d-4a7f-ac49-51129e156f33', 'WRITE');

-- urls should match the urls in values file
INSERT INTO egoapplication (id, name, clientid, clientsecret, redirecturi, description, status, type)  VALUES 
    ('96eeb453-e08f-46f1-bfa8-6ee377ee5b1f',
    'ego admin',
    'ego',
    'some secret value',
    'https://ego.test.argo.cancercollaboratory.org',
    'admin ui',
    'APPROVED',
    'ADMIN'),
    ('58037d95-63ab-46e4-9c35-f81889cd131c',
    'program service',
    'program-service',
    '< some secret value for ps here >',
    'https://na.ca',
    'program service',
    'APPROVED',
    'ADMIN'),
    ('58037d95-63ab-46e4-9e35-f81889cd131c',
    'argo ui',
    'platform-ui',
    'platform-ui ego secret value here',
    'https://platform-ui.test.argo.cancercollaboratory.org/logged-in',
    'platform ui',
    'APPROVED',
    'CLIENT')
;
```

5- add the ego url to google console (only needed once when we change the ego url)
https://ego.test.argo.cancercollaboratory.org/api/oauth/login/google



clean up: 
```
helm del --purge argo 
kubectl --namespace <bashar-test> delete pvc --all
```
