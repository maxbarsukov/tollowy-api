```
  +-------------------+
  | RESOURCE EXISTS ? |
  +-------------------+
    |       |
 NO |       v YES
    v      +-----------------------
   404     | IS LOGGED-IN ? (authenticated)
           +-----------------------
              |              |
           NO |              | YES
              v              v
              401            +-----------------------
                             | CAN ACCESS RESOURCE ? (permission, authorized, ...)
                             +-----------------------
             redirect          |            |
             to login       NO |            | YES
                               |            |
                               v            v
                               403          OK 200, redirect, ...
```
